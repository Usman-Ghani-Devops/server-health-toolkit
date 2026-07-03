import subprocess
import shutil
import json
import argparse
import os
from datetime import datetime


def alert(msg):
    os.makedirs("alerts/",exist_ok=True)
    file_name = "alerts/alert.log"
    with open(file_name,"a") as file:
        file.write(msg)
        file.write('\n')

def failed_login_attempts():
    with open("/var/log/auth.log", "r") as f:
        for line in f:
            if "Failed password" in line:
                os.makedirs("logs", exist_ok=True)
                with open("logs/auth_failures.log", "a") as log:
                    log.write(line)


parser =    argparse.ArgumentParser()

parser.add_argument(
    "--threshold",
    type = int
)
parser.add_argument(
    "--cleanup",
    action="store_true"
)
parser.add_argument(
    "--quiet",
    action="store_true"
)

parser.add_argument(
    "--summary",
    type=int
)

args = parser.parse_args()


def read_config():
    global config
    with open("config.json","r") as f:
        config = json.load(f)

def check_command(command):
    if (shutil.which(command) is None):
        print(f"{command} command is not present")
        exit(1)


def execute(command):
    output = subprocess.run(command, shell=True, capture_output=True, text=True)
    return(output.stdout)

def host_name():
    check_command("hostname")
    print("Host name")
    print(execute("hostname"))

def up_time():
    check_command("uptime")
    print("Uptime")
    print(execute("uptime -p"))

def cpu_load():
    print("CPU Load")
    print(execute("uptime | awk -F 'load average' '{print $2}'"))

def memory_usage():
    check_command("free")
    print("Memory Usage")
    print(execute("free -h"))

def disk_usage_per_mount():
    warning = False
    check_command("df")
    if (args.threshold is not None or config["quiet"]):
        output = subprocess.run("df -h --output=source,pcent,target" , shell =True, capture_output=True,text = True)
        lines = output.stdout.splitlines()[1:]
        for line in lines:
            filesystem,usage,mount =line.split()
            usage = int(usage.replace("%"," "))
        
            if (usage >= config["threshold"]):
                War = (f"Warning usage is greater than the threshold of {filesystem} mount at {mount} and usage is {usage}" )
                print(War)
                alert(War)
                warning = True


    if(warning == False and config["quiet"]):
        print("No warning")
    elif (config["quiet"] == False and args.threshold is None):
        print(execute("df -h"))

def generate_report():
    os.makedirs(config["report_dir"],exist_ok=True)
    time= datetime.now().strftime("%Y-%m-%d-%H%M")
    filename = f"{config["report_dir"]}/report-{time}.log"

    with open(filename,"w") as f:
        f.write("Server Health Toolkit\n")
        f.write(f"Report Generated at {datetime.now()}\n")
        f.write("Hostname\n")
        f.write(execute("hostname"))

        f.write("Uptime\n")
        f.write(execute("uptime -p"))

        f.write("CPU Load\n")
        f.write(execute("uptime | awk -F 'load average' '{print $2}'"))

        f.write("Memory Usage\n")
        f.write(execute("free -h"))

        f.write("Disk Usage\n")
        f.write(execute("df -h"))
        output = subprocess.run("df -h --output=pcent | sort -nr | tr -d '%' | head -n 1" , shell =True, capture_output=True,text = True)
        alert(f"Highest Disk Usage {output.stdout}")
        f.write(f"Highest Disk Usage is {output.stdout} %")

    print("Report Generated")

def summary():
        previous = 0

        files = subprocess.run("find reports -type f -name '*.log' ",capture_output=True,text=True,shell=True)
        files = files.stdout.split()
        files.sort(reverse=True)
        files = files[:args.summary]
        for file in files:
            with open(file,"r") as f:
                for line in f:
                    if line.startswith("Highest Disk Usage"):
                        line = line.split(" ")
                        usage = int(line[5])

                        if (usage > previous):
                                trend = "Increasing"
                        elif (usage < previous):
                            trend = "Drcreasing"
                        else:
                            trend = "No change"
                        previous = usage

        print(trend)                    


def cleanup():
    subprocess.run(f"find reports/ -type f -name '*.log' -mtime +{config['retention_days']} -delete",shell = True)
    print(f"Delete files other than {config["retention_days"]}")


def main():
    read_config()

    print("Server Health Toolkit")

    if args.threshold is not None:
        config["threshold"] = args.threshold
        disk_usage_per_mount()
        exit(0)

    if args.quiet == True:
        config["quiet"] = True
        disk_usage_per_mount()
        exit(0)
    
    if args.summary is not None:
        summary()
        exit(0)
    if args.cleanup == True:
        cleanup()
        exit(0)

    generate_report()
    failed_login_attempts()

main()