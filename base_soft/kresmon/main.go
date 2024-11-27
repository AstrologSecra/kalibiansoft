package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

	"github.com/rivo/tview"
)

func getProcessInfo() []string {
	cmd := exec.Command("ps", "-eo", "pid,pcpu,comm", "--sort=-pcpu")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Error:", err)
		return nil
	}

	lines := strings.Split(string(output), "\n")
	var processInfo []string
	for i, line := range lines {
		if i > 0 && i < 11 {
			fields := strings.Fields(line)
			if len(fields) >= 3 {
				processInfo = append(processInfo, fmt.Sprintf("%s - %s%%", fields[2], fields[1]))
			}
		}
	}

	return processInfo
}

func getCPUUsage() string {
	cmd := exec.Command("top", "-bn1")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Error:", err)
		return ""
	}

	lines := strings.Split(string(output), "\n")
	for _, line := range lines {
		if strings.Contains(line, "Cpu(s)") {
			fields := strings.Fields(line)
			for i, field := range fields {
				if field == "id," {
					idle, _ := strconv.ParseFloat(fields[i-1], 64)
					cpuUsage := 100 - idle
					return fmt.Sprintf("%.2f%%", cpuUsage)
				}
			}
		}
	}

	return ""
}

func main() {
	app := tview.NewApplication()

	infoText := tview.NewTextView().
		SetDynamicColors(true).
		SetRegions(true).
		SetWordWrap(true).
		SetChangedFunc(func() {
			app.Draw()
		})

	processList := tview.NewList().
		ShowSecondaryText(false).
		SetSelectedFunc(func(index int, mainText string, secondaryText string, shortcut rune) {
			pid := strings.Split(mainText, " ")[0]
			pidInt, _ := strconv.Atoi(pid)
			process, err := os.FindProcess(pidInt)
			if err != nil {
				fmt.Println("Error:", err)
				return
			}
			process.Kill()
			fmt.Printf("Process with PID %s has been killed.\n", pid)
			app.Stop()
		})

	go func() {
		for {
			cpuUsage := getCPUUsage()
			processInfo := getProcessInfo()

			info := fmt.Sprintf("CPU Usage: %s\n\nTop Processes by CPU Usage:\n", cpuUsage)
			infoText.SetText(info)

			processList.Clear()
			for _, proc := range processInfo {
				processList.AddItem(proc, "", 0, nil)
			}

			time.Sleep(1 * time.Second)
		}
	}()

	flex := tview.NewFlex().
		AddItem(infoText, 0, 1, false).
		AddItem(processList, 0, 2, true)

	if err := app.SetRoot(flex, true).Run(); err != nil {
		panic(err)
	}
} 
