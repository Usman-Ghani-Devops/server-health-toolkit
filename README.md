  # Server Health Toolkit

## Overview

Server Health Toolkit is a Bash-based system monitoring project developed to practice Linux administration, Bash scripting, Git workflows, and DevOps fundamentals.

The toolkit collects important system information, generates timestamped reports, monitors disk usage, detects failed login attempts, supports scheduled execution, logs alerts, and can execute health checks on remote Linux systems over SSH.

The project was built incrementally, with one Git branch and pull request per development stage.

---

# Features

## System Information

- Display hostname
- Display system uptime
- Display CPU load averages
- Display memory usage
- Display disk usage per mounted filesystem
- Display the top 5 memory-consuming processes

---

## Disk Monitoring

- Configurable disk usage threshold
- Warn when any filesystem exceeds the configured threshold
- Quiet mode to display only warnings

Example:

```bash
./health.sh --threshold 80
```

---

## Configuration File

Default settings are stored in `config.conf`.

Example:

```text
THRESHOLD=80
QUIET=false
REPORT_DIR=reports
REPORT_RETENTION_DAYS=30
EMAIL=usman328ghani@gmail.com
```

The script automatically loads these settings.

---

## Error Handling

The script verifies that required Linux commands are installed before executing them.

If a required command is missing, execution stops with an appropriate error message and a non-zero exit status.

---

## Report Generation

Each execution creates a timestamped report.

Example:

```text
reports/report-2026-07-02-1430.log
```

Each report contains:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Top Processes
- Highest Disk Usage

---

## Report Summary

Generate a summary from previous reports.

Example:

```bash
./health.sh --summary 5
```

The script reads the latest reports and determines whether disk usage is:

- Increasing
- Decreasing
- Stable

---

## Report Cleanup

Delete reports older than the configured retention period.

Example:

```bash
./health.sh --cleanup
```

---

## Alert System

Whenever disk usage exceeds the configured threshold:

- A warning is displayed
- An alert is written to:

```text
alerts/alerts.log
```

---

## Failed Login Detection

The toolkit scans the authentication log for failed SSH login attempts.

Detected failures are:

- Saved to

```text
logs/auth_failures.log
```

- Logged as alerts

---

## Remote Monitoring (Bonus)

The toolkit supports monitoring remote Linux systems using SSH.

Features:

- Copy the monitoring script to the remote machine
- Execute the health check remotely
- Retrieve the generated report using SCP
- Handle connection and transfer failures gracefully

Example:

```bash
./health.sh --remote user@192.168.1.100
```

---

# Email Notification Setup

The Server Health Toolkit supports sending email notifications when the configured disk usage threshold is exceeded. Email delivery is handled using **msmtp**, a lightweight SMTP client.

---

## Install Required Packages

Update the package list and install the required packages:

```bash
sudo apt update
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

* `your_email@gmail.com` with your Gmail address.
* `YOUR_APP_PASSWORD` with your Google App Password.

Save the file and restrict its permissions:

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
REPORT_RETENTION_DAYS=7
EMAIL="your_email@gmail.com"
```

Replace `your_email@gmail.com` with the email address that should receive alert notifications.

---

## Google App Password

Google does not allow SMTP authentication using your normal account password.

To generate an App Password:

1. Open **Google Account**.
2. Navigate to **Security**.
3. Enable **2-Step Verification**.
4. Open **App Passwords**.
5. Generate a new App Password.
6. Copy the generated password and use it in the `password` field of `~/.msmtprc`.

---

## Test Email Configuration

Send a test email to verify the SMTP configuration:

```bash
echo -e "Subject: Test Email\n\nThis is a test email from Server Health Toolkit." | msmtp your_email@gmail.com
```

If the configuration is correct, the email should be delivered within a few seconds.

---

## How It Works

When the toolkit generates a report, it checks the highest disk usage on the system.

If the highest disk usage exceeds the configured threshold:

* A report is generated.
* The alert is logged.
* An email notification is automatically sent to the configured recipient.

---

## Troubleshooting

| Issue                                    | Solution                                                                                       |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `msmtp: command not found`               | Install `msmtp` and `msmtp-mta`.                                                               |
| `Application-specific password required` | Generate and use a Google App Password instead of your normal Gmail password.                  |
| `permissions on ~/.msmtprc are too open` | Run `chmod 600 ~/.msmtprc`.                                                                    |
| Email not received                       | Verify the App Password, SMTP configuration, internet connection, and recipient email address. |




# Project Structure

```text
server-health-toolkit/
├── README.md
├── health.sh
├── config.conf
├── .gitignore
├── reports/
│   └── remote/
├── alerts/
├── logs/
```

---

# Requirements

- Linux (Ubuntu recommended)
- Bash
- Git
- OpenSSH Client
- OpenSSH Server (for remote monitoring)

---

# Installation

Clone the repository:

```bash
git clone <repository-url>
cd server-health-toolkit
```

Make the script executable:

```bash
chmod +x health.sh
```

---

# Usage

Run a normal health check:

```bash
./health.sh
```

Check disk usage with a custom threshold:

```bash
./health.sh --threshold 90
```

Show only warnings:

```bash
./health.sh --quiet
```

Generate a report summary:

```bash
./health.sh --summary 5
```

Delete old reports:

```bash
./health.sh --cleanup
```

Run a remote health check:

```bash
./health.sh --remote user@192.168.1.100
```

---

## Cron Scheduling

The toolkit can be executed automatically using `cron`.

### Example

The following cron job runs the health check every **5 minutes**:

```cron
*/5 * * * * cd /home/usman-ghani/server-health-toolkit && /bin/bash health.sh >> logs/cron.log 2>&1
```

### Explanation

- `*/5 * * * *` — Run every 5 minutes.
- `cd /home/usman-ghani/server-health-toolkit` — Change to the project directory.
- `/bin/bash health.sh` — Execute the health monitoring script.
- `>> logs/cron.log` — Append the script output to `logs/cron.log`.
- `2>&1` — Redirect error messages (`stderr`) to the same log file.

This allows the toolkit to perform automated health checks while keeping a history of each scheduled execution in `logs/cron.log`.

---

# Development Stages

## Stage 0

- Repository setup
- README
- Git workflow
- Branching strategy

---

## Stage 1

Implemented basic system information collection.

Added:

- Hostname
- Uptime
- CPU Load
- Memory Usage
- Disk Usage
- Top 5 Processes

---

## Stage 2

Improved robustness.

Added:

- Configurable threshold
- Quiet mode
- Configuration file
- Error handling
- Modular functions
- ShellCheck compliance

---

## Stage 3

Implemented reporting.

Added:

- Timestamped reports
- Report history
- Summary mode
- Automatic cleanup

---

## Stage 4

Implemented monitoring and alerting.

Added:

- Alert logging
- Failed login detection
- Cron scheduling support

---

## Stage 5 (Bonus)

Implemented remote monitoring.

Added:

- SSH execution
- SCP report retrieval
- Remote health checks
- Connection error handling

---

# Technologies Used

- Bash
- Linux Utilities
- Git
- SSH
- SCP
- Cron
- ShellCheck

---

# Future Improvements

With more time, the following improvements could be added:

- Prevent duplicate failed login entries by tracking only new authentication events
- JSON report generation
- Multi-server monitoring
- Parallel remote execution
- Systemd service integration
- Unit testing for Bash functions

---

# Learning Objectives

This project demonstrates practical experience with:

- Linux system administration
- Bash scripting
- Process monitoring
- File handling
- Log analysis
- Git branching workflows
- SSH automation
- Cron scheduling
- Error handling
- Modular scripting
- ShellCheck best practices

---

# Author

Usman Ghani
