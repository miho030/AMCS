"""
* software author : github.com/miho030
* software license : GPL2
"""

import os
import queue
import configparser
import signal
from datetime import datetime, timedelta

from concurrent.futures import ThreadPoolExecutor
from functools import partial
from threading import Event
from urllib.request import urlopen

from rich.progress import (
    BarColumn,
    DownloadColumn,
    Progress,
    TaskID,
    TextColumn,
    TimeRemainingColumn,
    TransferSpeedColumn,
)

from datetime import date, timedelta
from pyfiglet import Figlet
from rich.console import Console
from rich.panel import Panel

# ---------- import ini file
iniFile="./amcs.ini" # 배포 전에 경로 변경 필요
config = configparser.ConfigParser()
cl = Console()

# ---------- read config file
config.read(os.getcwd() + os.sep + iniFile, encoding='utf-8')
author = config['INFO']['author']
sfVersion = config['INFO']['sfVersion']
MalSector = config['DB_CONFIG']['malstorage']


def call_datetime_cli(contents :str):
    curDateTime = datetime.now().strftime('[%Y-%m-%d | %H:%M:%S]')
    cl.print("[bold magenta]%s[/bold magenta]\t[bold blue]%s[/bold blue]" % (curDateTime, contents), style="blue")
def call_cli(contents :str):
    cl.print("\t[bold magenta]> [/bold magenta] [bold yellow]%s[/bold yellow]" % (contents), style="#ffa500")
def software_info():
    panel = Panel("[bold green]Auto Malware Collect Server[/bold green]\n" + \
                  "[bold red]Automatic Malware archive samples collect service[/bold red]\n" + \
                  "software version: [bold yellow]%s[/bold yellow] \tauthor: [bold underline yellow]%s[/bold underline yellow]" % (sfVersion, author), style="bold blue")
    cl.print(panel)
    print("\n")

def print_ui():
    f = Figlet(font='slant')
    title = "AMCS " + str(sfVersion)
    print(f.renderText(title))
    software_info()


progress = Progress(
    TextColumn("[bold blue]{task.fields[filename]}", justify="right"),
    BarColumn(bar_width=None),
    "[progress.percentage]{task.percentage:>3.1f}%",
    "•",
    DownloadColumn(),
    "•",
    TransferSpeedColumn(),
    "•",
    TimeRemainingColumn(),
)
done_event = Event()

def handle_sigint(signum, frame):
    done_event.set()

signal.signal(signal.SIGINT, handle_sigint)
def copy_url(task_id: TaskID, url: str, path: str) -> None:
    """Copy data from a url to a local file."""
    progress.console.log(f"Requesting download malware archive {url}")
    response = urlopen(url)
    # This will break if the response doesn't contain content length
    progress.update(task_id, total=int(response.info()["Content-length"]))
    try:
        with open(path, "wb") as dest_file:
            progress.start_task(task_id)
            for data in iter(partial(response.read, 32768), b""):
                dest_file.write(data)
                progress.update(task_id, advance=len(data))
                if done_event.is_set():
                    return
        progress.console.log(f"Downloaded {path}")
    except Exception as err:
        call_datetime_cli("CRITICAL Error! Cannot download malware archive.")
        call_datetime_cli(str(err))
        return 1

def download_malware_archive(url: str, dest_dir: str):
    """Download multiple files to the given directory."""
    with progress:
        with ThreadPoolExecutor(max_workers=1) as pool:
            filename = url.split("/")[-1]
            dest_path = os.path.join(dest_dir, filename)
            task_id = progress.add_task("download", filename=filename, start=False)
            pool.submit(copy_url, task_id, url, dest_path)
    return 0

def print_target_info(filename: str, targetDate: str, url: str, downloadDir: str):
    call_datetime_cli("Here is today's malware sample information.")
    today = datetime.now().strftime('%Y-%m-%d')
    call_cli("Current datetime:  " + str(today))
    call_cli("Malware datetime:  " + str(targetDate))
    cl.print("\t[bold magenta]> [/bold magenta] [bold red]Malware file name:  %s[/bold red]" % (filename))
    call_cli("Download from:  " + url)
    cl.print("\t[bold magenta]> [/bold magenta] [bold red]Download locate:  %s[/bold red]" % (downloadDir))



def download_single_file(dateValue):
    targetYear = dateValue[:4]  # Extract year from start date
    malStorageDir = os.path.join(MalSector, str(targetYear))
    os.makedirs(malStorageDir, exist_ok=True)

    targetFileName = f"{dateValue}.zip"
    targetURL = f"https://datalake.abuse.ch/malware-bazaar/daily/{targetFileName}"
    downloadDir = os.path.join(malStorageDir, targetFileName)

    print_target_info(targetFileName, dateValue, targetURL, downloadDir)

    if os.path.exists(downloadDir):
        call_datetime_cli("Today's target malware archive file already exists, skipping.")
        return

    print("\n")
    download_malware_archive(targetURL, malStorageDir)
    exit(0)


def download_multi_file(startDatetimeDat, endDatetimeDat):
    """
    Generates a list of dates between startDatetimeDat and endDatetimeDat (inclusive).
    Request downloads malware archive files for all dates between startDatetimeDat and endDatetimeDat (inclusive).

    :param startDatetimeDat: Start date in 'YYYY-MM-DD' format.
    :param endDatetimeDat: End date in 'YYYY-MM-DD' format.
    """
    targetYear = startDatetimeDat[:4]  # Extract year from start date
    malStorageDir = os.path.join(MalSector, targetYear) + "/"

    # Create the storage directory if it does not exist
    if not os.path.exists(malStorageDir):
        os.makedirs(malStorageDir)

    # Convert string dates to datetime objects
    start_date = datetime.strptime(startDatetimeDat, "%Y-%m-%d")
    end_date = datetime.strptime(endDatetimeDat, "%Y-%m-%d")

    # Generate date list
    date_list = [(start_date + timedelta(days=i)).strftime("%Y-%m-%d")
                 for i in range((end_date - start_date).days + 1)]

    # Initialize a queue for sequential processing
    download_queue = queue.Queue()

    # Enqueue all download tasks
    for dateValue in date_list:
        targetFileName = f"{dateValue}.zip"
        targetURL = f"https://datalake.abuse.ch/malware-bazaar/daily/{targetFileName}"
        downloadDir = os.path.join(malStorageDir, targetFileName)

        print_target_info(targetFileName, dateValue, targetURL, downloadDir)
        print("\n")

        # Check if the malware archive file already exists
        if os.path.exists(downloadDir):
            call_datetime_cli(f"[INFO] {targetFileName} already exists, skipping download.")
            continue
        download_queue.put((targetURL, malStorageDir)) # Add to queue

    # Process queue sequentially
    while not download_queue.empty():
        targetURL, malStorageDir = download_queue.get()
        download_malware_archive(targetURL, malStorageDir)
        download_queue.task_done()

    print("[INFO] All downloads completed.")



def isDateTime_valid(date_text):
    try:
        datetime.strptime(date_text, "%Y-%m-%d")
        return True
    except ValueError:
        call_datetime_cli("Incorrect data format({0}), should be YYYY-MM-DD".format(date_text))
        return False

def userRequest():
    call_datetime_cli("AMCS Malicious File Download Option Selector")
    while True:
        call_datetime_cli("Select file download option:")
        call_cli("  1) Download malicious code compressed files collected on a specific date")
        print("\t\t- (single 1ea file will download")
        call_cli("  2) Bulk download of malicious code compressed files collected in a specific time period")
        print("\t\t- (provides a large number of files)")
        call_cli("  3) Exit AMCS program\n")
        choice = input("[INFO] Please enter your choice (1 or 2): ").strip()

        if choice == "1":
            while True:
                call_datetime_cli("Enter target malware archive datetime (ex 2024-01-01) :")
                userInputData = input("\t > ")
                if not userInputData or "-" not in userInputData:
                    call_datetime_cli(
                        "ERROR ! > Incorrect data format({0}), should be YYYY-MM-DD".format(userInputData))
                    continue
                else:
                    if isDateTime_valid(str(userInputData)):
                        download_single_file(userInputData)


        elif choice == "2":
            while True:
                call_datetime_cli("Enter the start datetime (ex 2024-01-01):")
                startUserInputData = input("\t > ").strip() # Get start datetime

                if not startUserInputData or "-" not in startUserInputData: # Validate start datetime
                    call_datetime_cli(f"ERROR! Incorrect data format ({startUserInputData}), should be YYYY-MM-DD")
                    continue

                startUserDataRes = isDateTime_valid(startUserInputData)
                if not startUserDataRes:
                    call_datetime_cli(f"ERROR! Invalid start datetime: {startUserInputData}")
                    continue


                call_datetime_cli("Enter the end datetime (ex 2024-01-01):") # Get end datetime
                endUserInputData = input("\t > ").strip()

                if not endUserInputData or "-" not in endUserInputData: # Validate end datetime
                    call_datetime_cli(f"ERROR! Incorrect data format ({endUserInputData}), should be YYYY-MM-DD")
                    continue

                endUserDataRes = isDateTime_valid(endUserInputData)
                if not endUserDataRes:
                    call_datetime_cli(f"ERROR! Invalid end datetime: {endUserInputData}")
                    continue

                # If both inputs are valid, return values
                download_multi_file(startUserInputData, endUserInputData)
                exit(0)


        elif choice == "3":
            call_cli("[INFO] Exiting AMCS...")
            exit(0)
        else:
            call_cli("[WARN] Invalid value entered, exit the program for safety.")
            exit(1)


def main():
    print_ui()

    if (os.path.exists(iniFile) != True):
        call_datetime_cli("Config file not founded !!")
        exit(1)

    userRequest()

if __name__ == '__main__':
    main()
