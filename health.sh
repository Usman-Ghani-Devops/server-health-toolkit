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

generate_report() {
    mkdir -p "$REPORT_DIR"

    timestamp=$(date +"%Y-%m-%d-%H%M")
    file_name="$REPORT_DIR/report-$timestamp.log"

    highest_disk=$(df -h --output=pcent | tail -n +2 | tr -d '%' | sort -nr | head -n 1)

    {
        echo "SERVER HEALTH REPORT"
        echo "Generated: $(date)"
        echo

        host_name
        up_time
        cpu_load
        memory_usage
        disk_usage_per_mount
        top_5_proc_by_mem

        echo "Highest Disk Usage: ${highest_disk}%"

    } > "$file_name"

    echo "Report Generated"
}

summary(){
    count="$2"

    if [ ! -d "$REPORT_DIR" ]
    then
        echo "Report directory  not exsists"
        exit 1
    fi

    files=$(ls -t "$REPORT_DIR"/*.log 2>/dev/null | head -n "$count")

    if [ -z "$files" ]
    then
        echo "No reports found."
        exit 1
    fi

    prev=""
    trend="No change"

    while read -r file 
    do
        usage=$(grep "Highest Disk Usage:" "$file" | awk '{print $4}' | tr -d '%')
        
        echo "$file and usage is $usage" 

        if [ -n "$prev" ]
        then
            if [ "$usage" -gt "$prev" ]
            then
                trend="Increasing"
            elif [ "$usage" -lt "$prev" ]
            then
                trend="Decreasing"
            fi
        fi

        prev=$usage

    done <<< "$files"


    echo
    echo "Disk usage trend: $trend"
    
    
}

cleanup_report() {

    find "$REPORT_DIR" -type f -name "*.log" -mtime +"$REPORT_RETENTION_DAYS" -delete

    echo "Deleted reports older than $REPORT_RETENTION_DAYS"
}

main() {
    echo " Server Health Toolkit "
    echo

    generate_report

}

if [ "$1" = "--threshold" ]
then 
    if [ -z "$2" ]
    then
        echo "Second argument is not provided"
        exit 1
    fi
    THRESHOLD=$2
    disk_usage_per_mount "$@"
elif [ "$1" = "--quiet" ]
then   
    QUIET=true
    disk_usage_per_mount "$@"
elif [ "$1" = "--summary" ]
then
    if [ -z "$2" ]
    then 
        echo "Second Argument is not provided"
        exit 1
    fi
    summary "$@"
elif [ "$1" = "--cleanup" ]
then
    cleanup_report
else
    main
fi
