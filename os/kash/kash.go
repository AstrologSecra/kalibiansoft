package main

import (
  "bufio"
  "fmt"
  "os"
  "os/exec"
  "os/user"
  "strconv"
  "strings"
)

func executeCommand(command string) {
  args := strings.Split(command, " ")

  switch args[0] {
  case "cd":
    if len(args) > 1 {
      err := os.Chdir(args[1])
      if err != nil {
        fmt.Fprintf(os.Stderr, "kash: cd: %s\n", err)
      }
    } else {
      fmt.Fprintf(os.Stderr, "kash: cd: missing argument\n")
    }
  case "exit":
    os.Exit(0)
  case "apt":
    args = append([]string{"sudo"}, args...)
    cmd := exec.Command(args[0], args[1:]...)
    cmd.Stdin = os.Stdin
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    err := cmd.Run()
    if err != nil {
      fmt.Fprintf(os.Stderr, "kash: apt: %s\n", err)
    }
  case "ls":
    var dir string
    if len(args) > 1 {
      dir = args[1]
    } else {
      dir = "."
    }
    entries, err := os.ReadDir(dir)
    if err != nil {
      fmt.Fprintf(os.Stderr, "kash: ls: %s\n", err)
      return
    }
    for _, entry := range entries {
      if entry.Name()[0] != '.' {
        fmt.Printf("%s  ", entry.Name())
      }
    }
    fmt.Println()
  case "chmod":
    if len(args) > 2 {
      mode, err := strconv.ParseUint(args[1], 8, 32)
      if err != nil {
        fmt.Fprintf(os.Stderr, "kash: chmod: %s\n", err)
        return
      }
      err = os.Chmod(args[2], os.FileMode(mode))
      if err != nil {
        fmt.Fprintf(os.Stderr, "kash: chmod: %s\n", err)
      }
    } else {
      fmt.Fprintf(os.Stderr, "kash: chmod: missing arguments\n")
    }
  case "help":
    fmt.Println("kash - Simple Command Line Interpreter")
    fmt.Println()
    fmt.Println("Supported commands:")
    fmt.Println("  cd <directory>   - Change the current directory.")
    fmt.Println("  exit             - Exit the shell.")
    fmt.Println("  apt <command>    - Run an apt command with sudo.")
    fmt.Println("  ls [directory]   - List files in the current or specified directory.")
    fmt.Println("  chmod <mode> <file> - Change the mode of a file.")
    fmt.Println("  help             - Display this help message.")
  default:
    cmd := exec.Command(args[0], args[1:]...)
    cmd.Stdin = os.Stdin
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    err := cmd.Run()
    if err != nil {
      fmt.Fprintf(os.Stderr, "kash: %s\n", err)
    }
  }
}

func main() {
  reader := bufio.NewReader(os.Stdin)
  user, _ := user.Current()
  host, _ := os.Hostname()

  for {
    cwd, _ := os.Getwd()
    fmt.Printf("\033[1;32m%s@%s\033[0m:\033[1;34m%s\033[0m$ ", user.Username, host, cwd)
    command, _ := reader.ReadString('\n')
    command = strings.TrimSpace(command)

    if command == "" {
      continue
    }

    executeCommand(command)
  }
}
