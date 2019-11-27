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
         "Install Apkmod" \
         "Install MPS-YOUTUBE" \
         "Install QEMU" \
         "Setup QEMU Alpine" \
         "Run QEMU Alpine" \
         "Quit") 
select opt in "${options[@]}"
do
    case $opt in
        "Init")
            printf "Continue Init"
            read enter
            termux-wake-lock
            pkg install bash-completion 
            apt update && apt upgrade
            apt install wget git nano mc aria2 -y
            mkdir ~/.termux
            touch ~/.termux/termux.properties 
            cd $home
            git clone https://github.com/w1r4/termux-dotfiles.git
            cd ~/termux-dotfiles
            bash setup.sh
            echo "extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]" >> ~/.termux/termux.properties
            termux-reload-settings
            termux-wake-unlock
            cd $home
            ;;
        "Backup")
            printf "Continue Backup"
            read enter        
            termux-wake-lock
            cd /data/data/com.termux/files
            tar -cvzf /sdcard/termux-backup.tgz --owner=0 --group=0 home usr
            termux-wake-unlock
            ;;
        "Restore")
            printf "Continue Restore"
            read enter
            termux-wake-lock
            cd /data/data/com.termux/files
            tar -xvzf /sdcard/termux-backup.tgz
            termux-wake-unlock
            ;;                
        "Enable Storage")        
            termux-setup-storage
            ;;
        "Install VNC")
            printf "Continue Install VNC"
            read enter
            termux-wake-lock
            pkg install x11-repo
            pkg install  tigervnc fluxbox -y
            export DISPLAY=":1"
            vncserver
            termux-wake-unlock
            ;;
        "Install Metasploit")
            printf "Continue Install Metasploit"
            read enter
            termux-wake-lock
            pkg install unstable-repo
            pkg install metasploit -y
            termux-wake-unlock
            ;;
        "Install Apkmod")
            printf "Continue Install apkmod"
            read enter        
            cd $HOME
            curl  https://raw.githubusercontent.com/w1r4/termux-menu/master/termux-apk.sh -o termux-apk.sh
            sh termux-apk.sh
            ;;            
        "Install MPS-YOUTUBE")
            printf "Continue Install MPS-Youtube"
            read enter        
            termux-wake-lock
            cd $HOME
            pkg install python -y
            pip install youtube_dl
            pip install mps_youtube
            pip install mpv
            mpsyt set show_video true, \
                  set download_command "aria2c \
                  --stream-piece-selector=inorder \
                  --enable-http-pipelining=true \
                  --min-split-size=4m \
                  --file-allocation=none \
                  --max-connection-per-server=10 \
                  --split=10 --dir=%d --out=%f %u",\
                  set ddir $HOME/storage/downloads/ , \
                  exit 
              termux-wake-unlock    
            ;;
        "Install QEMU")
            printf "Continue Install QEMU"
            read enter
            pkg install x11-repo
            pkg update
            pkg install qemu-common qemu-system-x86_64 qemu-utils
            curl https://raw.githubusercontent.com/w1r4/termux-menu/master/runqemu -o runqemu
            ;;
         "Setup QEMU Alpine")
            qemu-img create -f qcow2 virtual_drive 4G
            aria2c -c --auto-file-renaming=false http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/x86_64/alpine-virt-3.10.3-x86_64.iso -o alpine_x86_64.iso
            qemu-system-x86_64 -nographic \
	                      -m 512m \
	                      -cdrom alpine_x86_64.iso \
	                      -boot d \
             		      -drive file=virtual_drive,media=disk,if=virtio                         
            ;;
         "Run QEMU Alpine")
            qemu-system-x86_64 -nographic \
	                      -boot c \
	                      -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::10080-:80 \
			      -drive file=virtual_drive,media=disk,if=virtio      
	                      -nic user,model=virtio \
	                      -m 512M \
	                      -smp 3
            ;;
         "Quit")
            printf "Continue Quit"
            read enter        
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
