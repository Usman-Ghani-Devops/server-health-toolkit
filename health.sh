#!/bin/bash

CONFIG_FILE="config.conf"

if [ -f "$CONFIG_FILE" ] 
then
    source "$CONFIG_FILE"
fi

check_command(){
    if ! command -v "$1" > /dev/null 2>&1
    then
        echo "$1 command not Found"
        exit 1
    fi
}

host_name(){
    check_command hostname
    echo "Hostname" 
    hostname
    echo
}

up_time(){
    check_command uptime
    echo "Uptime"
    uptime -p
    echo
}

cpu_load(){
    check_command uptime
    echo "Cpu_Load"
    uptime | awk -F'load average: ' '{print $2}'
    echo
}

memory_usage(){
    check_command free
    echo "Memory Usage"
    free -h
    echo
}

disk_usage_per_mount() {
    check_command df

    if [ "$QUIET" = false ] && [ "$1" != "--threshold" ]
    then
        echo "Disk Usage per Mount"
        df -h
        echo
    fi

    Warning=false

    if [ "$1" != "--threshold" ]; then
    result=$(df -h --output=source,pcent,target | tail -n +2 |
    while read -r filesystem usage mount
    do
        usage=${usage//%/}

        if [ "$usage" -gt "$THRESHOLD" ]; then
            echo "WARNING: $filesystem is using ${usage}%"
            echo "true"
        fi
    done)
fi
    if [ "$1" = "--threshold" ] || [ "$1" = "--quiet" ]
    then 
    result=$(df -h --output=source,pcent,target | tail -n +2 |
    while read -r filesystem usage mount
    do
        usage=${usage//%/}

        if [ "$usage" -gt "$THRESHOLD" ]
        then
            echo "WARNING: $filesystem is using ${usage}% (threshold: ${THRESHOLD}%) mounted on $mount"
            echo "true"
        fi
    done)
    fi

    if echo "$result" | grep -q "true"; then
        Warning=true
    fi

    echo "$result" | grep -v "true"

    if [ "$QUIET" = true ] && [ "$Warning" = false ]; then
        echo "No warnings."
    fi
}
top_5_proc_by_mem() {
    check_command ps
    echo "Top 5 Process by Memory"
    ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -6
    echo
}

main() {
    echo " Server Health Toolkit "
    echo

    host_name
    up_time
    cpu_load
    memory_usage
    disk_usage_per_mount
    top_5_proc_by_mem

}

if [ "$1" = "--threshold" ]
then 
    if [ -z "$2" ]; then
    echo "Second argument is not provided"
    exit 1
    fi
    THRESHOLD=$2
    disk_usage_per_mount "$@"
elif [ "$1" = "--quiet" ]
then   
    QUIET=true
    disk_usage_per_mount "$@"
else
    main
fi
