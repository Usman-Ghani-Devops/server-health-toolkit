#!/bin/bash

echo "=== Server Health Toolkit ==="

echo

echo "Host name"
hostname
echo 

echo "Uptime"
uptime -p
echo

echo "CPU Load"
uptime | awk -F'load average: ' '{print $2}'
echo

echo "Memory Usage"
free -h
echo

echo "Disk Usage per mount"
df -h
echo

echo "Top 5 process by memory"
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -6
