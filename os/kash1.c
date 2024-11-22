#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <dirent.h>
#include <pwd.h>
#include <sys/stat.h>

#define MAX_COMMAND_LENGTH 1024
#define MAX_ARGS 64

void execute_command(char *command) {
    char *args[MAX_ARGS];
    int arg_count = 0;

    // Разбиваем команду на аргументы
    char *token = strtok(command, " ");
    while (token != NULL && arg_count < MAX_ARGS - 1) {
        args[arg_count++] = token;
        token = strtok(NULL, " ");
    }
    args[arg_count] = NULL;

    // Обработка команды cd
    if (strcmp(args[0], "cd") == 0) {
        if (arg_count > 1) {
            if (chdir(args[1]) != 0) {
                perror("cd");
            }
        } else {
            fprintf(stderr, "kash: cd: missing argument\n");
        }
        return;
    }

    // Обработка команды exit
    if (strcmp(args[0], "exit") == 0) {
        exit(0);
    }

    // Обработка команды apt
    if (strcmp(args[0], "apt") == 0) {
        // Добавляем sudo перед apt
        char *sudo_args[MAX_ARGS];
        sudo_args[0] = "sudo";
        for (int i = 0; i < arg_count; i++) {
            sudo_args[i + 1] = args[i];
        }
        sudo_args[arg_count + 1] = NULL;

        // Создаем дочерний процесс для выполнения команды
        pid_t pid = fork();
        if (pid == 0) {
            // Дочерний процесс
            execvp(sudo_args[0], sudo_args);
            perror("execvp");
            exit(1);
        } else if (pid > 0) {
            // Родительский процесс
            waitpid(pid, NULL, 0);
        } else {
            perror("fork");
        }
        return;
    }

    // Обработка команды setbg
    if (strcmp(args[0], "setbg") == 0) {
        if (arg_count > 1) {
            // Используем w3m для отображения изображения
            char *w3m_args[MAX_ARGS];
            w3m_args[0] = "w3m";
            w3m_args[1] = "-o";
            w3m_args[2] = "imagelib=imlib2";
            w3m_args[3] = args[1];
            w3m_args[4] = NULL;

            // Создаем дочерний процесс для выполнения команды
            pid_t pid = fork();
            if (pid == 0) {
                // Дочерний процесс
                execvp(w3m_args[0], w3m_args);
                perror("execvp");
                exit(1);
            } else if (pid > 0) {
                // Родительский процесс
                waitpid(pid, NULL, 0);
            } else {
                perror("fork");
            }
        } else {
            fprintf(stderr, "kash: setbg: missing argument\n");
        }
        return;
    }

    // Обработка команды ls
    if (strcmp(args[0], "ls") == 0) {
        DIR *dir;
        struct dirent *ent;
        struct stat st;
        char path[MAX_COMMAND_LENGTH];

        if (arg_count > 1) {
            if (chdir(args[1]) != 0) {
                perror("ls");
                return;
            }
        }

        if ((dir = opendir(".")) != NULL) {
            while ((ent = readdir(dir)) != NULL) {
                if (ent->d_name[0] == '.') continue; // Пропускаем скрытые файлы

                snprintf(path, sizeof(path), "./%s", ent->d_name);
                if (stat(path, &st) == 0 && S_ISDIR(st.st_mode)) {
                    printf("\033[1;34m%s\033[0m\n", ent->d_name); // Подсветка для директорий
                } else {
                    printf("%s\n", ent->d_name);
                }
            }
            closedir(dir);
        } else {
            perror("ls");
        }
        return;
    }

    // Обработка команды chmod
    if (strcmp(args[0], "chmod") == 0) {
        if (arg_count > 2) {
            if (chmod(args[2], strtol(args[1], NULL, 8)) != 0) {
                perror("chmod");
            }
        } else {
            fprintf(stderr, "kash: chmod: missing arguments\n");
        }
        return;
    }

    // Обработка команды для запуска sh скриптов через kash
    if (strcmp(args[0], "sh") == 0) {
        if (arg_count > 1) {
            // Создаем дочерний процесс для выполнения команды
            pid_t pid = fork();
            if (pid == 0) {
                // Дочерний процесс
                execvp(args[0], args);
                perror("execvp");
                exit(1);
            } else if (pid > 0) {
                // Родительский процесс
                waitpid(pid, NULL, 0);
            } else {
                perror("fork");
            }
        } else {
            fprintf(stderr, "kash: sh: missing argument\n");
        }
        return;
    }

    // Обработка команды для запуска kash скриптов через kash
    if (strcmp(args[0], "kash") == 0) {
        if (arg_count > 1) {
            // Создаем дочерний процесс для выполнения команды
            pid_t pid = fork();
            if (pid == 0) {
                // Дочерний процесс
                execvp(args[0], args);
                perror("execvp");
                exit(1);
            } else if (pid > 0) {
                // Родительский процесс
                waitpid(pid, NULL, 0);
            } else {
                perror("fork");
            }
        } else {
            fprintf(stderr, "kash: kash: missing argument\n");
        }
        return;
    }

    // Создаем дочерний процесс для выполнения команды
    pid_t pid = fork();
    if (pid == 0) {
        // Дочерний процесс
        execvp(args[0], args);
        perror("execvp");
        exit(1);
    } else if (pid > 0) {
        // Родительский процесс
        waitpid(pid, NULL, 0);
    } else {
        perror("fork");
    }
}

int main() {
    char command[MAX_COMMAND_LENGTH];
    char hostname[256];
    char username[256];

    // Получаем имя пользователя и хост
    if (getlogin_r(username, sizeof(username)) != 0) {
        perror("getlogin_r");
        strcpy(username, "user");
    }
    if (gethostname(hostname, sizeof(hostname)) != 0) {
        perror("gethostname");
        strcpy(hostname, "host");
    }

    while (1) {
        printf("%s@%s: ", username, hostname);
        if (fgets(command, sizeof(command), stdin) == NULL) {
            break;
        }

        // Убираем символ новой строки
        command[strcspn(command, "\n")] = 0;

        // Выполняем команду
        execute_command(command);
    }

    return 0;
}
