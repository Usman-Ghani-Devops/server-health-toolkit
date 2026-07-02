# Server Health Toolkit

## Overview

Server Health Toolkit is a Bash-based project that monitors the health of a Linux server. The project is developed in multiple stages to practice Linux, Git, Networking, Bash scripting, and DevOps fundamentals.

The toolkit will collect system information, generate reports, detect potential issues, schedule automated health checks, and support remote monitoring over SSH.

---

## Project Goals

* Practice Linux system administration.
* Learn Bash scripting through a real-world project.
* Build clean and modular Bash scripts.
* Follow Git feature branch and Pull Request workflows.
* Write ShellCheck-compliant code.
* Gain practical DevOps experience.

---

# Development Stages

## Stage 0 – Project Setup

**Objective**

Prepare the project repository before writing any monitoring code.

**Tasks**

* Create the initial project structure.
* Add a `README.md`.
* Add a `.gitignore`.
* Decide the Git branch naming convention.
* Create the Stage 0 feature branch.
* Open a Pull Request and merge it into `main`.

---

## Stage 1 – Collector

The script will display:

* Hostname
* System uptime
* CPU load
* Memory usage
* Disk usage per mounted filesystem
* Top 5 memory-consuming processes

---

## Stage 2 – Robust Script

The script will include:

* Configurable disk usage threshold
* Quiet mode (`--quiet`)
* Configuration file support
* Error handling
* Modular functions
* ShellCheck-compliant code

---

## Stage 3 – History & Reporting

The toolkit will:

* Generate timestamped reports
* Store reports in a `reports/` directory
* Read previous reports
* Provide summary mode
* Automatically remove old reports

---

## Stage 4 – Scheduling & Alerts

The toolkit will:

* Run automatically using cron
* Log alerts
* Generate notification files
* Detect failed SSH login attempts
* Document the cron configuration

---

## Stage 5 – Remote Monitoring (Bonus)

The toolkit will:

* Connect to remote servers using SSH
* Execute health checks remotely
* Retrieve remote reports
* Handle unreachable hosts gracefully

---

## Project Structure

```text
server-health-toolkit/
├── README.md
├── .gitignore
└── health.sh
```

Future versions will also include:

```text
reports/
alerts.log
notification.txt
config.conf
```

---

## Requirements

* Ubuntu (recommended) or another Linux distribution
* Bash
* Git
* ShellCheck
* OpenSSH (Stage 5)

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
```

Move into the project directory:

```bash
cd server-health-toolkit
```

Make the script executable:

```bash
chmod +x health.sh
```

---

## Usage

Run the toolkit:

```bash
./health.sh
```

Additional command-line options will be introduced in later stages.

---

## Git Workflow

This project follows a feature-branch workflow.

### Main Branch

* `main`

### Feature Branches

* `feature/stage0`
* `feature/stage1`
* `feature/stage2`
* `feature/stage3`
* `feature/stage4`
* `feature/stage5`

Workflow:

1. Create a feature branch.
2. Complete the stage.
3. Commit the changes.
4. Push the branch to GitHub.
5. Open a Pull Request.
6. Merge into `main`.
7. Start the next stage.

---

## Development Roadmap

| Stage   | Description         | Status      |
| ------- | ------------------- | ----------- |
| Stage 0 | Project Setup       | ✅ Completed |
| Stage 1 | Collector           | ⏳ Planned   |
| Stage 2 | Robust Script       | ⏳ Planned   |
| Stage 3 | History & Reporting | ⏳ Planned   |
| Stage 4 | Scheduling & Alerts | ⏳ Planned   |
| Stage 5 | Remote Monitoring   | ⏳ Planned   |

---

## Current Status

Current Stage:

**Stage 0 – Project Setup**

The project repository has been initialized and prepared for development.

Next step:

**Stage 1 – Build the Server Health Collector**

---

## License

This project is created for educational purposes as part of a Linux, Git, Bash, Networking, and DevOps learning roadmap.

