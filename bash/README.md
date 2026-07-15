# Server Health Toolkit (Bash)

## Overview

Server Health Toolkit is a Bash-based Linux system monitoring project developed to strengthen practical skills in Linux administration, Bash scripting, Git workflows, and DevOps fundamentals.

The toolkit collects important system information, generates timestamped health reports, monitors disk usage, detects failed SSH login attempts, supports scheduled execution with Cron, logs alerts, sends email notifications, and can execute health checks on remote Linux systems using SSH.

The project was developed incrementally using feature branches and pull requests, with each development stage building upon the previous one.

---

## Cross-Distribution Linux Support

The toolkit is designed to work across multiple Linux distributions by automatically detecting the operating system at runtime and selecting the appropriate system resources. No manual changes are required when moving the toolkit between supported distributions.

### Supported Distributions

| Distribution | Status | Authentication Log |
|--------------|--------|--------------------|
| Ubuntu | ✅ Supported | `/var/log/auth.log` |
| Debian | ✅ Supported | `/var/log/auth.log` |
| CentOS | ✅ Supported | `/var/log/secure` |
| Red Hat Enterprise Linux (RHEL) | ✅ Supported | `/var/log/secure` |
| Rocky Linux | ✅ Supported | `/var/log/secure` |
| AlmaLinux | ✅ Supported | `/var/log/secure` |
| Fedora | ✅ Supported | `/var/log/secure` |

### Automatic OS Detection

At startup, the toolkit reads the operating system information from:

```text
/etc/os-release
```

Based on the detected Linux distribution, it automatically:

- Selects the correct authentication log file.
- Uses the appropriate log location for failed SSH login monitoring.
- Prevents execution on unsupported Linux distributions by displaying a clear error message.

This approach eliminates the need to modify the script when deploying it on different Linux distributions, making the toolkit portable across Debian-based and Red Hat-based systems.

# Features

## System Information

Collects essential system information including:

- Hostname
- System uptime
- CPU load averages
- Memory usage
- Disk usage per mounted filesystem
- Top 5 memory-consuming processes

---

## Disk Monitoring

Supports configurable disk monitoring.

Features include:

- Configurable disk usage threshold
- Threshold warnings
- Quiet mode
- Alert logging
- Email notifications

---

## Report Generation

Automatically generates timestamped reports containing:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Top Processes
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
- Sends an email notification

Alerts are stored in:

```text
alerts/alerts.log
```

---

## Failed Login Detection

Scans Linux authentication logs for failed SSH login attempts.

Detected entries are stored in:

```text
logs/auth_failures.log
```

---

## Cron Support

Supports scheduled execution using Cron.

Cron output can be redirected to:

```text
logs/cron.log
```

---

## Remote Monitoring

Monitor remote Linux systems using SSH.

Features include:

- Copy the monitoring script to a remote server
- Execute the health check remotely
- Retrieve generated reports using SCP
- Store remote reports locally

Remote reports are stored inside:

```text
reports/remote/
```

---

# Repository Structure

```text
bash/
│
├── README.md
├── health.sh
├── config.conf
│
├── reports/
│   ├── report-YYYY-MM-DD-HHMM.log
│   └── remote/
│       └── report-YYYY-MM-DD-HHMM.log
│
├── alerts/
│   └── alerts.log
│
├── logs/
│   ├── auth_failures.log
│   └── cron.log
│
└── .gitignore
```

---


# Requirements

The toolkit has been tested on Ubuntu Linux.

Required software:

- Bash
- Git
- OpenSSH Client
- OpenSSH Server
- msmtp
- Cron
- ShellCheck

---

# Installation

Clone the repository:

```bash
git clone <repository-url>
```

Move into the Bash implementation:

```bash
cd server-health-toolkit/bash
```

Make the script executable:

```bash
chmod +x health.sh
```

Verify the script:

```bash
./health.sh
```

---

# Configuration

The toolkit loads its configuration automatically from:

```text
config.conf
```

Example configuration:

```bash
# Report Configuration
REPORT_DIR="reports"
REMOTE_REPORT_DIR="reports/remote"
REPORT_RETENTION_DAYS=7

# Alert Configuration
ALERT_FILE="alerts/alerts.log"
AUTH_LOGS="logs/auth_failures.log"
EMAIL="your_email@gmail.com"

# Disk Monitoring
THRESHOLD=80
QUIET=false
```

## Configuration Options

| Variable | Description |
|----------|-------------|
| `REPORT_DIR` | Directory where generated server health reports are stored. |
| `REMOTE_REPORT_DIR` | Directory used to store reports retrieved from remote servers. |
| `REPORT_RETENTION_DAYS` | Number of days to retain generated reports before cleanup. |
| `ALERT_FILE` | File used to store warning and alert messages generated by the toolkit. |
| `AUTH_LOGS` | File used to store detected SSH failed login attempts. |
| `EMAIL` | Email address that receives disk usage alert notifications (requires `msmtp` configuration). |
| `THRESHOLD` | Disk usage percentage that triggers warning messages and email alerts. |
| `QUIET` | When set to `true`, only warning messages are displayed; normal disk usage output is suppressed. |
The script automatically loads these settings each time it executes.

---

# Email Notification Setup

The Server Health Toolkit supports sending email notifications whenever the configured disk usage threshold is exceeded.

Email delivery is handled using **msmtp**, a lightweight SMTP client.

---

## Install Required Packages

Update the package list:

```bash
sudo apt update
```

Install the required packages:

```bash
sudo apt install msmtp msmtp-mta
```

Verify the installation:

```bash
msmtp --version
```

---

## Configure SMTP

Create the msmtp configuration file:

```bash
nano ~/.msmtprc
```

Add the following configuration:

```ini
defaults
auth on
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account gmail
host smtp.gmail.com
port 587

from your_email@gmail.com
user your_email@gmail.com
password YOUR_APP_PASSWORD

account default : gmail
```

Replace:

- `your_email@gmail.com` with your Gmail address.
- `YOUR_APP_PASSWORD` with your Google App Password.

Save the file.

Restrict file permissions:

```bash
chmod 600 ~/.msmtprc
```

---

## Configure the Toolkit

Open the project configuration file:

```bash
nano config.conf
```

Example:

```bash
REPORT_DIR="reports"
THRESHOLD=80
QUIET=false
REPORT_RETENTION_DAYS=7
EMAIL="your_email@gmail.com"
```

Replace `your_email@gmail.com` with the email address that should receive notifications.

---

## Google App Password

Google no longer allows SMTP authentication using your normal account password.

To generate an App Password:

1. Open your Google Account.
2. Navigate to **Security**.
3. Enable **2-Step Verification**.
4. Open **App Passwords**.
5. Generate a new App Password.
6. Copy the generated password into the `password` field of `~/.msmtprc`.

---

## Test Email Configuration

Verify your SMTP configuration:

```bash
echo -e "Subject: Test Email\n\nThis is a test email from Server Health Toolkit." | msmtp your_email@gmail.com
```

If the configuration is correct, the email should arrive within a few seconds.

---

# Usage

Run a normal health check:

```bash
./health.sh
```

---

## Threshold Monitoring

Override the configured threshold:

```bash
./health.sh --threshold 90
```

The toolkit checks every mounted filesystem and displays a warning whenever usage exceeds the specified threshold.

---

## Quiet Mode

Display only warnings:

```bash
./health.sh --quiet
```

If no filesystem exceeds the configured threshold, the toolkit prints:

```text
No warnings.
```

---

## Report Summary

Generate a summary from previous reports:

```bash
./health.sh --summary 5
```

The toolkit reads the latest reports and determines whether disk usage is:

- Increasing
- Decreasing
- Stable

---

## Cleanup

Delete reports older than the configured retention period:

```bash
./health.sh --cleanup
```

The retention period is controlled by:

```bash
REPORT_RETENTION_DAYS
```

inside `config.conf`.

---

## Remote Monitoring

Run a health check on a remote Linux system:

```bash
./health.sh --remote user@192.168.1.100
```

The toolkit performs the following steps automatically:

1. Copies the monitoring script to the remote machine.
2. Copies the configuration file.
3. Executes the health check remotely.
4. Retrieves the generated report using SCP.
5. Stores the report inside:

```text
reports/remote/
```

---

# Cron Scheduling

The toolkit can be executed automatically using Cron.

Edit your crontab:

```bash
crontab -e
```

Example:

```cron
*/5 * * * * cd /path/to/server-health-toolkit/bash && /bin/bash health.sh >> logs/cron.log 2>&1
```

### Explanation

| Expression | Description |
|------------|-------------|
| `*/5 * * * *` | Run every 5 minutes |
| `cd ...` | Change to the project directory |
| `/bin/bash health.sh` | Execute the monitoring script |
| `>> logs/cron.log` | Append output to the cron log |
| `2>&1` | Redirect error messages to the same log |

Cron execution history is stored in:

```text
logs/cron.log
```

---

# Alert System

Whenever disk usage exceeds the configured threshold:

- A warning is displayed.
- The alert is written to:

```text
alerts/alerts.log
```

- An email notification is sent to the configured recipient.

---

# Failed Login Detection

The toolkit scans the Linux authentication log for failed SSH login attempts.

Detected entries are:

- Saved to

```text
logs/auth_failures.log
```

- Logged as alerts.

---

# Error Handling

The toolkit validates that required Linux commands are installed before execution.

Examples include:

- hostname
- uptime
- free
- df
- ps
- grep
- ssh
- scp
- msmtp

If a required command is unavailable, execution stops with an appropriate error message and a non-zero exit status.

# Development Stages

## Stage 0 — Repository Setup

Completed:

- Repository initialization
- Project documentation
- Git workflow
- Branching strategy
- Project structure

---

## Stage 1 — System Information Collection

Implemented:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Top 5 Memory-Consuming Processes

---

## Stage 2 — Robustness

Implemented:

- Configuration file support
- Configurable disk usage threshold
- Quiet mode
- Command validation
- Modular Bash functions
- ShellCheck compliance

---

## Stage 3 — Reporting

Implemented:

- Timestamped report generation
- Report history
- Report summary
- Automatic cleanup of old reports

---

## Stage 4 — Monitoring and Alerting

Implemented:

- Disk usage alerts
- Alert logging
- Failed SSH login detection
- Email notifications
- Cron scheduling support

---

## Stage 5 — Remote Monitoring

Implemented:

- Remote execution using SSH
- Report retrieval using SCP
- Remote report storage
- Connection error handling

---

# Technologies Used

The project was developed using the following technologies:

- Bash
- Linux Utilities
- Git
- OpenSSH
- SCP
- Cron
- msmtp
- ShellCheck

---

# Future Improvements

Potential enhancements include:

- HTML report generation
- JSON report export
- Monitoring multiple remote servers simultaneously
- Parallel SSH execution
- Systemd service integration
- Unit testing for Bash functions

---

# Learning Objectives

This project demonstrates practical experience with:

- Linux System Administration
- Bash Scripting
- Process Monitoring
- File Handling
- Log Analysis
- Configuration Management
- SSH Automation
- SCP File Transfers
- Cron Scheduling
- Email Notifications
- Error Handling
- Modular Script Design
- Shell Scripting Best Practices
- Git Branching Workflows
- ShellCheck Compliance

---

# License

This project is provided for educational purposes and portfolio demonstration.

Feel free to fork, modify, and extend it for learning.

---

# Author

**Usman Ghani**

Software Engineering Student

Linux • Bash • Python • Git • DevOps • Cloud Computing
