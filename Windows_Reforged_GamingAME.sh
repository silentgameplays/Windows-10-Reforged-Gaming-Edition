#!/bin/bash

clear
echo "                 ╔═══════════════╗"
echo "                 ║ !!!WARNING!!! ║"
echo "╔════════════════╩═══════════════╩══════════════════╗"
echo "║ This script comes without any warranty.           ║"
echo "║ If your computer no longer boots, explodes, or    ║"
echo "║ divides by zero, you are the only one responsible ║"
echo "╟╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╢"
echo "║ This script only works on Debian based distros.   ║"
echo "║ An Ubuntu Live ISO is recommended.                ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
read -p "To continue press [ENTER], or Ctrl-C to exit"

title_bar() {
	clear
	echo "╔═════════════════════════════════════════════════════╗"
	echo "║ AMEliorate Windows 10 2004               2020.10.31 ║"
	echo "╚═════════════════════════════════════════════════════╝"
	echo ""
}

# prompts to install git and 7zip if not already installed
title_bar
	echo "This script requires the installation of a few"
	echo "dependencies. Please enter your password below."
	echo ""
sudo apt update
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")
echo "Checking for git: $PKG_OK"
if [ "" == "$PKG_OK" ]; then
	echo "curl not found, prompting to install git..."
	sudo apt-get -y install git
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' p7zip-full|grep "install ok installed")
echo "Checking for 7zip: $PKG_OK"
if [ "" == "$PKG_OK" ]; then
	echo "curl not found, prompting to install 7zip..."
	sudo apt-get -y install p7zip-full
fi

# prompts to install fzf if not already installed
title_bar
echo "The program fzf is required for this script to function"
echo "Please allow for fzf to install following this message"
echo "Enter "y" (yes) for all prompts"
echo ""
read -p "To continue press [ENTER], or Ctrl-C to exit"
echo "\n"
title_bar
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

title_bar
echo "Checking for existing AME Backup"
FILE=./AME_Backup/
if [ -d $FILE ]; then
	now=$(date +"%Y.%m.%d.%H.%M")
	7z a AME_Backup_$now.zip AME_Backup/
	rm -rf AME_Backup/
else
   echo "$FILE' not found, continuing"
fi



# start AME process
title_bar
echo "Starting AME process, searching for files..."
Term=(autologger clipsvc clipup DeliveryOptimization DeviceCensus.exe diagtrack dmclient dosvc EnhancedStorage homegroup hotspot invagent microsoftedge.exe msra sihclient slui startupscan storsvc usoclient usocore windowsmaps windowsupdate wsqmcons wua wus)
touch fzf_list.txt
for i in "${Term[@]}"
do
	echo "Looking for $i"
	$HOME/.fzf/bin/fzf -e -f $i >> fzf_list.txt
done

# check if fzf found anything
title_bar
if [ -s fzf_list.txt ]
then
	echo "Directory file not empty, continuing..."
else
	echo "ERROR! no files found, exiting..."
	exit 1	
fi

# directory processing starts here
rm dirs*
touch dirs.txt

# removes some outliers that are needed
awk '!/FileMaps/' fzf_list.txt > fzf_list_cleaned1.txt
awk '!/WinSxS/' fzf_list_cleaned1.txt > fzf_list_cleaned2.txt
awk '!/MSRAW/' fzf_list_cleaned2.txt > fzf_list_cleaned3.txt
awk '!/msrating/' fzf_list_cleaned3.txt > fzf_list_cleaned.txt

# removes everything after the last slash in the file list
sed 's%/[^/]*$%/%' fzf_list_cleaned.txt >> dirs.txt

# removes a trailing slash, repeats several times to get all the directories
for a in {0..12..2}
do
        if [ $a -eq 0 ]
        then
                cat dirs.txt > dirs$a.txt
        fi
        b=$((a+1))
        c=$((b+1))
        sed 's,/$,,' dirs$a.txt >> dirs$b.txt
        sed 's%/[^/]*$%/%' dirs$b.txt >> dirs$c.txt
        cat dirs$c.txt >> dirs.txt
done

# removes duplicates and sorts by length
awk '!a[$0]++' dirs.txt > dirs_deduped.txt
awk '{ print length($0) " " $0; }' dirs_deduped.txt | sort -n | cut -d ' ' -f 2- > dirs_sorted.txt
# appends root backup directory
awk -v quote='"' '{print "mkdir " quote "AME_Backup/" $0 quote}' dirs_sorted.txt > mkdirs.sh
# adds some needed things
echo 'mkdir "AME_Backup/Program Files (x86)"' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
echo 'mkdir AME_Backup/Windows/SoftwareDistribution' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
echo 'mkdir AME_Backup/Windows/InfusedApps' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
echo 'mkdir AME_Backup/Windows' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
echo 'mkdir AME_Backup' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
echo '#!/bin/bash' | cat - mkdirs.sh > temp && mv temp mkdirs.sh
chmod +x mkdirs.sh
rm dirs*

# creates backup script
awk -v quote='"' '{print "cp -fa --preserve=all " quote $0 quote " " quote "AME_Backup/" $0 quote}' fzf_list_cleaned.txt > backup.txt
# adds individual directories to top of script
echo 'cp -fa --preserve=all "Program Files/Internet Explorer" "AME_Backup/Program Files/Internet Explorer"' | cat - backup.txt > temp && mv temp backup.txt
# Appx fix testing
#echo 'cp -fa --preserve=all "Program Files/WindowsApps" "AME_Backup/Program Files/WindowsApps"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files/Windows Defender" "AME_Backup/Program Files/Windows Defender"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files/Windows Mail" "AME_Backup/Program Files/Windows Mail"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files/Windows Media Player" "AME_Backup/Program Files/Windows Media Player"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files (x86)/Internet Explorer" "AME_Backup/Program Files (x86)/Internet Explorer"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files (x86)/Windows Defender" "AME_Backup/Program Files (x86)/Windows Defender"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files (x86)/Windows Mail" "AME_Backup/Program Files (x86)/Windows Mail"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all "Program Files (x86)/Windows Media Player" "AME_Backup/Program Files (x86)/Windows Media Player"' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/System32/wua* AME_Backup/Windows/System32' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/System32/wups* AME_Backup/Windows/System32' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/SystemApps/*CloudExperienceHost* AME_Backup/Windows/SystemApps' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/SystemApps/*ContentDeliveryManager* AME_Backup/Windows/SystemApps' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/SystemApps/Microsoft.MicrosoftEdge* AME_Backup/Windows/SystemApps' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/SystemApps/Microsoft.Windows.Cortana* AME_Backup/Windows/SystemApps' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/SystemApps/Microsoft.XboxGameCallableUI* AME_Backup/Windows/SystemApps' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/System32/smartscreen.exe AME_Backup/Windows/System32/' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/System32/smartscreenps.dll AME_Backup/Windows/System32/' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/diagnostics/system/Apps AME_Backup/Windows/diagnostics/system' | cat - backup.txt > temp && mv temp backup.txt
echo 'cp -fa --preserve=all Windows/diagnostics/system/WindowsUpdate AME_Backup/Windows/diagnostics/system' | cat - backup.txt > temp && mv temp backup.txt
echo '#!/bin/bash' | cat - backup.txt > temp && mv temp backup.txt
awk '{ print length($0) " " $0; }' backup.txt | sort -n | cut -d ' ' -f 2- > backup.sh
rm backup.txt
chmod +x backup.sh

# creates recovery script
awk -v quote='"' '{print "cp -fa --preserve=all " quote "AME_Backup/" $0 quote " " quote $0 quote}' fzf_list_cleaned.txt > restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files/Internet Explorer" "Program Files/Internet Explorer"' | cat - restore.txt > temp && mv temp restore.txt
#echo 'cp -fa --preserve=all "AME_Backup/Program Files/WindowsApps" "Program Files/WindowsApps"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files/Windows Defender" "Program Files/Windows Defender"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files/Windows Mail" "Program Files/Windows Mail"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files/Windows Media Player" "Program Files/Windows Media Player"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files (x86)/Internet Explorer" "Program Files (x86)/Internet Explorer"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "Program Files (x86)/Windows Defender" "Program Files (x86)/Windows Defender"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files (x86)/Windows Mail" "Program Files (x86)/Windows Mail"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all "AME_Backup/Program Files (x86)/Windows Media Player" "Program Files (x86)/Windows Media Player"' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/System32/wua* Windows/System32' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/System32/wups* Windows/System32' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/SystemApps/*CloudExperienceHost* Windows/SystemApps' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/SystemApps/*ContentDeliveryManager* Windows/SystemApps' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/SystemApps/Microsoft.MicrosoftEdge* Windows/SystemApps' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/SystemApps/Microsoft.Windows.Cortana* Windows/SystemApps' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/SystemApps/Microsoft.XboxGameCallableUI* Windows/SystemApps' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/System32/smartscreen.exe Windows/System32/' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/System32/smartscreenps.dll Windows/System32/' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/diagnostics/system/Apps Windows/diagnostics/system' | cat - restore.txt > temp && mv temp restore.txt
echo 'cp -fa --preserve=all AME_Backup/Windows/diagnostics/system/WindowsUpdate Windows/diagnostics/system' | cat - restore.txt > temp && mv temp restore.txt
awk '{ print length($0) " " $0; }' restore.txt | sort -n | cut -d ' ' -f 2- > restore.sh
echo 'read -p "To continue press [ENTER], or Ctrl-C to exit"' | cat - restore.sh > temp && mv temp restore.sh
echo 'echo "This script will restore all the necessary files for Windows Updates to be installed manually"' | cat - restore.sh > temp && mv temp restore.sh
echo '#!/bin/bash' | cat - restore.sh > temp && mv temp restore.sh
rm restore.txt
chmod +x restore.sh

# creates removal script
awk -v quote='"' '{print "rm -rf " quote $0 quote}' fzf_list_cleaned.txt > remove.sh
echo 'rm -rf "Program Files/Internet Explorer"' | cat - remove.sh > temp && mv temp remove.sh
#echo 'rm -rf "Program Files/WindowsApps"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files/Windows Defender"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files/Windows Mail"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files/Windows Media Player"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files (x86)/Internet Explorer"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files (x86)/Windows Defender"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files (x86)/Windows Mail"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Program Files (x86)/Windows Media Player"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/System32/wua*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/System32/wups*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/*CloudExperienceHost*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/*ContentDeliveryManager*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/Microsoft.MicrosoftEdge*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/Microsoft.Windows.Cortana*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/Microsoft.XboxGameCallableUI*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/SystemApps/Microsoft.XboxIdentityProvider*' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/diagnostics/system/Apps' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf Windows/diagnostics/system/WindowsUpdate' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Windows/System32/smartscreen.exe"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Windows/System32/smartscreenps.dll"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Windows/System32/SecurityHealthAgent.dll"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Windows/System32/SecurityHealthService.exe"' | cat - remove.sh > temp && mv temp remove.sh
echo 'rm -rf "Windows/System32/SecurityHealthSystray.exe"' | cat - remove.sh > temp && mv temp remove.sh
echo '#!/bin/bash' | cat - remove.sh > temp && mv temp remove.sh
chmod +x remove.sh



title_bar
echo "Creating Directories"
./mkdirs.sh
echo "Done."
echo "Backing up files"
./backup.sh
echo "Done."
echo "Removing files"
./remove.sh
echo "Done."
sync
title_bar
rm fzf_list_cleaned.txt
rm fzf_list_cleaned1.txt
rm fzf_list_cleaned2.txt
rm fzf_list_cleaned3.txt
echo "You may now reboot into Windows"