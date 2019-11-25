#!/bin/bash
# Bash Menu Script Example
#  https://raw.githubusercontent.com/w1r4/termux-menu/master/termux-menu.sh

PS3='Please enter your choice: '
options=("Init" \
         "Backup" \
         "Restore" \
         "Enable Storage" \
         "Install VNC" \
         "Install Metasploit" \
         "install apkmod" \
         "Install MPS-YOUTUBE" \
         "Quit") 
select opt in "${options[@]}"
do
    case $opt in
        "Init")
            pkg install bash-completion 
            apt update && apt upgrade
            apt install wget git nano mc aria2 -y
            ;;
        "Backup")
            cd /data/data/com.termux/files
            tar -cvzf /sdcard/termux-backup.tgz --owner=0 --group=0 home usr
            ;;
        "Restore")
            cd /data/data/com.termux/files
            tar -xvzf /sdcard/termux-backup.tgz
            ;;                
        "Enable Storage")
            termux-setup-storage
            ;;
        "Install VNC")
            pkg install x11-repo
            pkg install  tigervnc fluxbox -y
            export DISPLAY=":1"
            vncserver
            ;;
        "Install Metasploit")
            pkg install unstable-repo
            pkg install metasploit -y
            ;;
        "install apkmod")
            cd $HOME
            wget  https://raw.githubusercontent.com/w1r4/termux-menu/master/termux-apk.sh
            sh termux-apk.sh
            ;;            
        "Install MPS-YOUTUBE")
            cd $HOME
            pkg install python -y
            pip install youtube_dl
            pip install mps_youtube
            pip install mpv
            mpsyt set show_video true, \
                  set download_command aria2c \
                  --stream-piece-selector=inorder \
                  --enable-http-pipelining=true \
                  --min-split-size=4m \
                  --file-allocation=none \
                  --max-connection-per-server=10 \
                  --split=10 --dir=%d --out=%f %u ,\
                  set ddir /storage/downloads/ , \
                  exit 
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
