#!/bin/bash

analyze_cpu_load() {
    echo "Analyzing CPU load:"
    echo "-----------------------------------"
    echo "CPU Load:"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
    echo "-----------------------------------"
}

find_high_cpu_usage_processes() {
    echo "Finding processes with high CPU usage:"
    echo "-----------------------------------"
    echo "Processes with high CPU usage:"
    ps aux --sort=-%cpu | head -n 6
    echo "-----------------------------------"
}

echo "System Performance Analyzer"
echo "==========================="

if [ $# -eq 0 ]; then
    echo "Usage: $0 [cpu|high]"
    exit 1
fi

for arg in "$@"; do
    case $arg in
        cpu)
            analyze_cpu_load
            ;;
        high)
            find_high_cpu_usage_processes
            ;;
        *)
            echo "Invalid argument: $arg"
            echo "Usage: $0 [cpu|high]"
            exit 1
            ;;
    esac
done

echo "Analysis completed."
