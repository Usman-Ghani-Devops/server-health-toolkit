# Server Health Toolkit (Python)

## Overview

Server Health Toolkit is a Python-based Linux system monitoring project developed to strengthen practical skills in Python programming, Linux administration, Git workflows, and DevOps fundamentals.

The toolkit collects essential system information, generates timestamped health reports, monitors disk usage, detects failed SSH login attempts, logs alerts, and provides configurable monitoring through a JSON configuration file.

The project follows a modular design, with each feature implemented incrementally across multiple development stages.

---

# Features

## System Information

Collects essential system information including:

- Hostname
- System uptime
- CPU load averages
- Memory usage
- Disk usage per mounted filesystem

---

## Disk Monitoring

Supports configurable disk monitoring.

Features include:

- Configurable disk usage threshold
- Threshold warnings
- Quiet mode
- Alert logging

---

## Report Generation

Automatically generates timestamped reports containing:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Highest Disk Usage

Reports are stored inside:

```text
reports/
```

---

## Report Summary

Generate a summary from previous reports.

The toolkit determines whether disk usage is:

- Increasing
- Decreasing
- Stable

---

## Automatic Cleanup

Automatically removes reports older than the configured retention period.

---

## Alert System

Whenever the configured threshold is exceeded, the toolkit:

- Displays a warning
- Stores the alert

Alerts are stored in:

```text
alerts/alert.log
```

---

## Failed Login Detection

Scans Linux authentication logs for failed SSH login attempts.

Detected entries are stored in:

```text
logs/auth_failures.log
```

---

# Repository Structure

```text
python/
│
├── README.md
├── health.py
├── config.json
│
├── reports/
│   └── report-YYYY-MM-DD-HHMM.log
│
├── alerts/
│   └── alert.log
│
├── logs/
│   └── auth_failures.log

```

---

# Requirements

The toolkit has been tested on Ubuntu Linux.

Required software:

- Python 3
- Git

Python Standard Libraries:

- argparse
- subprocess
- json
- shutil
- os
- datetime

No third-party Python packages are required.

---

# Installation

Clone the repository:

```bash
git clone <repository-url>
```

Move into the Python implementation:

```bash
cd server-health-toolkit/python
```

Verify Python is installed:

```bash
python3 --version
```

Run the toolkit:

```bash
python3 health.py
```

---

# Configuration

The toolkit loads its configuration automatically from:

```text
config.json
```

Example configuration:

```json
{
    "report_dir": "reports",
    "threshold": 80,
    "retention_days": 7,
    "email": "your_email@gmail.com",
    "quiet": false
}
```

## Configuration Options

| Variable | Description |
|----------|-------------|
| `report_dir` | Directory used to store generated reports |
| `threshold` | Disk usage percentage that triggers warnings |
| `retention_days` | Number of days to retain reports |
| `email` | Reserved for future email notification support |
| `quiet` | Display only warnings when enabled |

The toolkit automatically loads these settings whenever it executes.

---

# Usage

Run a normal health check:

```bash
python3 health.py
```

---

## Threshold Monitoring

Override the configured threshold:

```bash
python3 health.py --threshold 90
```

The toolkit checks every mounted filesystem and displays a warning whenever disk usage exceeds the specified threshold.

---

## Quiet Mode

Display only warnings:

```bash
python3 health.py --quiet
```

If no filesystem exceeds the configured threshold, the toolkit prints:

```text
No warning
```

---

## Report Generation

Generate a timestamped system health report:

```bash
python3 health.py
```

Each execution creates a report inside:

```text
reports/
```

Example:

```text
reports/report-2026-07-05-1830.log
```

Each report contains:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Highest Disk Usage

---

## Report Summary

Display a summary of previous reports:

```bash
python3 health.py --summary 5
```

The toolkit analyzes the latest reports and determines whether disk usage is:

- Increasing
- Decreasing
- Stable

---

## Cleanup

Delete reports older than the configured retention period:

```bash
python3 health.py --cleanup
```

The retention period is controlled by:

```json
"retention_days": 7
```

inside `config.json`.

---

# Alert System

Whenever disk usage exceeds the configured threshold:

- A warning is displayed.
- The alert is written to:

```text
alerts/alert.log
```

Each alert includes:

- Filesystem
- Mount point
- Current usage
- Configured threshold

---

# Failed Login Detection

The toolkit scans the Linux authentication log for failed SSH login attempts.

Detected entries are saved to:

```text
logs/auth_failures.log
```

This allows administrators to review unsuccessful login attempts for security monitoring.

---

# Error Handling

The toolkit validates that required Linux commands are available before execution.

Commands checked include:

- hostname
- uptime
- free
- df

If a required command is unavailable, execution stops with an appropriate error message.

---

# Command-Line Arguments

| Argument | Description |
|----------|-------------|
| `--threshold N` | Override the configured disk usage threshold |
| `--quiet` | Display only warnings |
| `--summary N` | Analyze the latest N reports |
| `--cleanup` | Delete reports older than the configured retention period |

---

# Example Commands

Run a normal health check:

```bash
python3 health.py
```

Check disk usage using a custom threshold:

```bash
python3 health.py --threshold 90
```

Display only warnings:

```bash
python3 health.py --quiet
```

Generate a summary from the latest five reports:

```bash
python3 health.py --summary 5
```

Delete old reports:

```bash
python3 health.py --cleanup
```

---

# Technologies Used

The project was developed using the following technologies:

- Python 3
- Linux Utilities
- Git
- argparse
- subprocess
- json
- shutil
- os
- datetime

---

# Future Improvements

Potential enhancements include:

- Email notifications
- Cron scheduling support
- Remote monitoring using SSH
- Parallel monitoring of multiple servers
- HTML report generation
- JSON report export
- Systemd service integration
- Unit testing

---

# Learning Objectives

This project demonstrates practical experience with:

- Python Programming
- Linux System Administration
- Process Monitoring
- File Handling
- Log Analysis
- JSON Configuration Management
- Argument Parsing
- Subprocess Management
- Error Handling
- Modular Program Design
- Report Generation
- Git Branching Workflows

---

# License

This project is provided for educational purposes and portfolio demonstration.

Feel free to fork, modify, and extend it for learning.

---

# Author

**Usman Ghani**

Software Engineering Student

Linux • Bash • Python • Git • DevOps • Cloud Computing