import os, sys, pwd, getpass, platform, shutil, configparser
from datetime import datetime
from pyfiglet import Figlet
from rich.console import Console
from rich.panel import Panel
from crontab import CronTab

# ---------- software version and info
author = "github.com/miho030"
sfVersion = "v3.0.1"
# ---------- ini file configurations
iniFile="./amcs.ini"
amcsUser = "malwareCollector"
amcsDir = ""
defaultMalSectorDir = ""
# ---------- pretty cli
config = configparser.ConfigParser()
cl = Console()


def call_datetime_cli(contents :str):
    curDateTime = datetime.now().strftime('[%Y-%m-%d | %H:%M:%S]')
    cl.print("[bold magenta]%s[/bold magenta]\t[bold blue]%s[/bold blue]" % (curDateTime, contents), style="blue")
def call_cli(contents :str):
    cl.print("\t[bold magenta]> [/bold magenta] [bold yellow]%s[/bold yellow]" % (contents), style="#ffa500")
def print_ui():
    f = Figlet(font='slant')
    title = "AMCS " + str(sfVersion)
    print(f.renderText(title))
    panel = Panel("[bold green]Auto Malware Collect Server Installer[/bold green]\n" + \
                  "software version: [bold yellow]%s[/bold yellow] \tauthor: [bold underline yellow]%s[/bold underline yellow]" % (
                  sfVersion, author), style="bold blue")
    cl.print(panel)
    print("\n")


def chk_amcs_user_exist():
    global amcsUser
    try:
        pwd.getpwnam(amcsUser)
        return True
    except KeyError:
        return False

if chk_amcs_user_exist() == False:
    call_datetime_cli("[ERROR] for security, you need to execute installer.sh file first.")
    sys.exit(1)

def chk_os():
    flag = 'None'
    strOS = platform.system()
    if strOS == "Windows":
        flag = 'win'
        return flag
    elif strOS == "Linux":
        flag = 'lin'
        return flag

def make_malStorage(osType :str):
    global amcsUser
    global amcsDir
    global defaultMalSectorDir

    winUser = getpass.getuser()

    if osType == "lin":
        amcsDir = "/home/" + amcsUser + "/AMCS/"
        defaultMalSectorDir = amcsDir + "malSector/"

    elif osType == "win":
        amcsDir = "C:\\Users\\" + winUser + "\\AMCS\\"
        defaultMalSectorDir = amcsDir + "malSector\\"

    if (os.path.isdir(amcsDir) == False):
        os.makedirs(defaultMalSectorDir)

    return amcsDir, defaultMalSectorDir


def exist_Ini_File():
    if (os.path.exists(iniFile) == False):
        return False
    else:
        return True
def make_ini():
    if exist_Ini_File == True:
        pass
    else:
        MalStorage = defaultMalSectorDir

        config['INFO'] = {
            'author': author,
            'sfVersion': sfVersion
        }

        config['DB_CONFIG'] = {
            'malStorage': MalStorage
        }

        with open(iniFile, 'w') as f:
            config.write(f)


def installPack():
    call_datetime_cli("Starting install and Copying AMCS package to local system..")

    # copy source file to root directory
    dailyFile = amcsDir + 'daily_AMCS.py'
    selectFile = amcsDir + 'select_AMCS.py'

    if (os.path.exists(dailyFile) == True) and (os.path.exists(selectFile) == True):
        call_cli("AMCS source files already exist at install path!")
    else:
        shutil.copy(iniFile, amcsDir)
        shutil.copy('./src/daily_AMCS.py', amcsDir)
        shutil.copy('./src/select_AMCS.py', amcsDir)
    call_cli("Successfully installed AMCS packages!")

def register_package():
    call_cli("register!")
    call_datetime_cli("Starting register crontab processing..")

    global amcsUser
    global dailyFile
    dailyFile = str(amcsDir + 'daily_AMCS.py')

    cron = CronTab(user=amcsUser)
    cronComm = str("python3 " + dailyFile)
    registerJob = cron.new(command=cronComm, comment="AMCS - daily malware archive downloader")

    registerJob.setall('0 1 * * *')
    #registerJob.every().dom()
    registerJob.enable()

    call_datetime_cli("Writing crontab settings..")
    cron.write()
    call_cli("Successfully write registering settings")



def winMain():
    global amcsDir

    if (os.path.isdir(amcsDir) == False):
        os.makedirs(defaultMalSectorDir)
        print("[+] Successfully create malsector!")
        make_ini()

    # copy source file to root directory
    dailyFile = amcsDir + 'daily_AMCS.py'
    selectFile = amcsDir + 'select_AMCS.py'

    if (os.path.exists(dailyFile) == True) and (os.path.exists(selectFile) == True):
        print("[*] source files are already exist!")
    else:
        shutil.copy(iniFile, amcsDir)
        shutil.copy('./src/daily_AMCS.py', amcsDir)
        shutil.copy('./src/select_AMCS.py', amcsDir)
        print("[+]  Successfully installed AMCS packages.")

def main():
    resOS = chk_os() # 1
    if resOS == None or resOS == "Darwin":
        print("This OS platform not support yet! sorry.")

    make_malStorage(resOS) # 2
    make_ini()  # 3

    if resOS == "win":
        print("windows!")
        winMain()

    elif resOS == 'lin':
        print("linux!")
        make_malStorage(str(resOS)) # 1
        installPack()
        register_package()

if __name__ == '__main__':
    main()
