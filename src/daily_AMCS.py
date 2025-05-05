"""
* software author : github.com/miho030
* software license : GPL2
"""

import os, configparser, signal
import threading
from datetime import datetime

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
base_dir = os.path.dirname(os.path.abspath(__file__))
iniFile = os.path.join(base_dir, "amcs.ini")
config = configparser.ConfigParser()
cl = Console()

# ---------- read config file
config.read(iniFile, encoding='utf-8')
author = config['INFO']['author']
sfVersion = config['INFO']['sfVersion']

# ---------- target malware sample information
targetDate = date.today() - timedelta(1)
targetYear = targetDate.year



def datetime_caller():
    now = datetime.now().strftime('[%Y-%m-%d | %H:%M:%S]')
    return now
def call_datetime_cli(contents :str):
    curDateTime = datetime_caller()
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

def print_target_info(filename: str, url: str, downloadDir: str):
    call_datetime_cli("Here is today's malware sample information.")
    today = datetime.now().strftime('%Y-%m-%d')
    call_cli("Current datetime:  " + str(today))
    call_cli("Malware datetime:  " + str(targetDate))
    cl.print("\t[bold magenta]> [/bold magenta] [bold red]Malware file name:  %s[/bold red]" % (filename))
    call_cli("Download from:  " + url)
    cl.print("\t[bold magenta]> [/bold magenta] [bold red]Download locate:  %s[/bold red]" % (downloadDir))

def make_target_info():
    tempMalSector = config['DB_CONFIG']['malstorage']
    malStorageDir = tempMalSector + str(targetYear) + "/"
    if (os.path.exists(malStorageDir) == False):
        os.makedirs(malStorageDir)

    targetFileName = str(targetDate) + ".zip"
    targetURL = "https://datalake.abuse.ch/malware-bazaar/daily/" + targetFileName
    downloadDir = malStorageDir + targetFileName
    print_target_info(targetFileName, targetURL, downloadDir)

    # check target malware file
    if (os.path.exists(downloadDir)):
        call_datetime_cli("Today's target malware archive file already exist!")
        exit(0)

    print("\n")
    download_malware_archive(targetURL, malStorageDir)

def join_thread(func):
    threading.Thread(func)

def main():
    print_ui()

    if (os.path.exists(iniFile) != True):
        call_datetime_cli("Config file not founded !!")
        exit(1)

    down = threading.Thread(make_target_info())
    down.start()
    down.join()

    #make_target_info() # 1
if __name__ == '__main__':
    main()
