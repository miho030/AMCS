import os
import configparser
import signal
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
iniFile="../amcs.ini" # 배포 전에 ./ 경로로 변경해야함.
config = configparser.ConfigParser()
cl = Console()

# ---------- read config file
config.read(os.getcwd() + os.sep + iniFile, encoding='utf-8')
author = config['INFO']['author']
sfVersion = config['INFO']['sfVersion']

# ---------- target malware sample information
targetDate = date.today() - timedelta(1)
targetYear = targetDate.year


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


def isDateTime_valid(date_text):
    try:
        datetime.strptime(date_text, "%Y-%m-%d")
        return True
    except ValueError:
        call_datetime_cli("Incorrect data format({0}), should be YYYY-MM-DD".format(date_text))
        return False

def userRequest():
    while True:
        call_datetime_cli("Enter target malware archive datetime (ex 2024-01-01) :")
        userInputData = input("\t > ")
        if userInputData == None or userInputData == " " or userInputData.find("-") == -1:
            call_datetime_cli("ERROR ! > Incorrect data format({0}), should be YYYY-MM-DD".format(userInputData))
            pass
        else:
            res = isDateTime_valid(str(userInputData))
            if res != False:
                return True, userInputData

def main():
    print_ui()

    if (os.path.exists(iniFile) != True):
        call_datetime_cli("Config file not founded !!")
        exit(1)

    dateRes, userInputData = userRequest()
    if dateRes == True:
        call_cli("your input data : %s" % (userInputData))




if __name__ == '__main__':
    main()