# Server Health Toolkit

## Overview

Server Health Toolkit is a Linux system monitoring project developed to strengthen practical skills in Linux administration, Bash scripting, Python scripting, Git workflows, and DevOps fundamentals.

The toolkit collects essential system information, generates timestamped health reports, monitors disk usage, detects failed login attempts, supports automated execution using Cron, logs alerts, and provides tools for monitoring Linux systems.

This repository contains **two implementations** of the same project:

- **Bash Implementation** (Stages 0–5)
- **Python Implementation** (Stages 0–4)

Both implementations share the same core functionality while demonstrating equivalent solutions using different programming languages.

---

# Repository Structure

```text
server-health-toolkit/
│
├── README.md
│
├── bash/
│   ├── README.md
│   ├── health.sh
│   ├── config.conf
│   ├── reports/
│   │   ├── report-YYYY-MM-DD-HHMM.log
│   │   └── remote/
│   │       └── report-YYYY-MM-DD-HHMM.log
│   ├── alerts/
│   │   └── alerts.log
│   └── logs/
│       ├── auth_failures.log
│       └── cron.log
│
├── python/
│   ├── README.md
│   ├── health.py
│   ├── config.json
│   ├── reports/
│   │   └── report-YYYY-MM-DD-HHMM.log
│   ├── alerts/
│   │   └── alert.log
│   └── logs/
│       └── auth_failures.log
│
└── .gitignore
```

---

# Implementations

## Bash Implementation

Location

```text
bash/
```

The Bash implementation demonstrates Linux automation using standard shell utilities and common administration tools.

Implemented Features

- Repository setup
- Modular Bash scripting
- Configuration file support
- System information collection
- Threshold monitoring
- Quiet mode
- Timestamped report generation
- Report summaries
- Automatic cleanup
- Alert logging
- Failed SSH login detection
- Email notifications using msmtp
- Cron scheduling
- Remote monitoring using SSH and SCP

Documentation

```text
bash/README.md
```

Status

```text
Completed (Stages 0–5)
```

---

## Python Implementation

Location

```text
python/
```

The Python implementation demonstrates the same monitoring concepts using Python standard libraries while following a modular programming approach.

Implemented Features

- Repository setup
- Modular Python functions
- JSON configuration
- System information collection
- Threshold monitoring
- Quiet mode
- Timestamped report generation
- Report summaries
- Automatic cleanup
- Alert logging
- Failed SSH login detection

Documentation

```text
python/README.md
```

Status

```text
Completed (Stages 0–4)
```

---

# Feature Comparison

| Feature | Bash | Python |
|----------|:----:|:------:|
| Repository Setup | ✅ | ✅ |
| Configuration File | ✅ | ✅ |
| Hostname | ✅ | ✅ |
| Uptime | ✅ | ✅ |
| CPU Load | ✅ | ✅ |
| Memory Usage | ✅ | ✅ |
| Disk Usage | ✅ | ✅ |
| Top 5 Processes | ✅ | ✅ |
| Threshold Monitoring | ✅ | ✅ |
| Quiet Mode | ✅ | ✅ |
| Timestamped Reports | ✅ | ✅ |
| Report Summary | ✅ | ✅ |
| Automatic Cleanup | ✅ | ✅ |
| Alert Logging | ✅ | ✅ |
| Failed Login Detection | ✅ | ✅ |
| Cron Scheduling | ✅ | Planned |
| Email Notifications | ✅ | Planned |
| Remote Monitoring | ✅ | Planned |

---

# Technologies Used

## Common

- Linux
- Git
- GitHub

## Bash Implementation

- Bash
- Core Linux Utilities
- SSH
- SCP
- Cron
- ShellCheck
- msmtp

## Python Implementation

- Python 3
- argparse
- subprocess
- json
- shutil
- os
- datetime

---

# Development Stages

## Stage 0

Repository setup

- Project initialization
- Git workflow
- Branching strategy
- Documentation

---

## Stage 1

System information collection

Implemented

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Top 5 Processes

---

## Stage 2

Monitoring improvements

Implemented

- Configurable threshold
- Quiet mode
- Configuration files
- Error handling
- Modular functions

---

## Stage 3

Reporting

Implemented

- Timestamped reports
- Report history
- Summary mode
- Automatic cleanup

---

## Stage 4

Monitoring and alerting

Implemented

- Alert logging
- Failed login detection

---

## Stage 5 (Bash Only)

Remote monitoring

Implemented

- SSH execution
- SCP report retrieval
- Remote health checks
- Connection error handling

---

# Installation

Clone the repository

```bash
git clone <repository-url>
```

Move into the project directory

```bash
cd server-health-toolkit
```

---

# Getting Started

For the Bash implementation, see

```text
bash/README.md
```

For the Python implementation, see

```text
python/README.md
```

Each README contains:

- Installation
- Configuration
- Usage
- Examples
- Requirements
- Project structure
- Feature explanations

---

# Learning Objectives

This project demonstrates practical experience with

- Linux system administration
- Bash scripting
- Python scripting
- Process monitoring
- File handling
- Log analysis
- Git branching workflows
- Configuration management
- SSH automation
- Cron scheduling
- Error handling
- Modular programming
- Report generation

---

# Future Improvements

Possible future enhancements include

- Multi-server monitoring
- JSON and HTML reports
- Parallel remote execution
- Email notifications in Python
- Remote monitoring in Python
- Systemd service integration
- Unit testing

---

# Author

**Usman Ghani**

Software Engineering Student

Linux • Bash • Python • Git • DevOps