#!/bin/bash

#
# This script will download and install hardinfo from the
# Nux Dextop repository (third-party)
#
# More information can be found here:
# https://centos.pkgs.org/7/nux-dextop-x86_64/hardinfo-0.5.1-5.el7.nux.x86_64.rpm.html
# 
# Target OS: CentOS 7
#
# Created by Tim Barth (September 2, 2021)
#
# Remember to set the execute bit on this script:
# chmod +x ./hardinfo-install.sh
#

# Verify that OS is Centos 7 before executing script
if grep -qi 'centos linux 7' /etc/os-release; then

    DownloadPath=$HOME/Downloads/nux-dextop-download

    printf "\nCreating download path ($DownloadPath)\n"
    if [ -d "$HOME/Downloads" ]
    then
        # create temporary folder for downloads
        mkdir $DownloadPath
    else
        mkdir -P $DownloadPath
    fi

    # Download the Nux Dextop repo rpm
    printf "\nDownloading Nux Dextop repo rpm (nux-dextop-release-0-5.el7.nux.noarch.rpm)..."
    curl http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm --output $DownloadPath/nux-dextop-release-0.5.1-5.el7.nux.x86_64.rpm  &> /dev/null
    printf "[DONE]\n"

    # Install Nux Dextop repo rpm
    printf "\nInstalling Nux Dextop repo rpm..."
    sudo rpm -Uvh $DownloadPath/nux-dextop-release*.rpm &> /dev/null
    printf "[DONE]\n"

    # Install hardinfo
    printf "\nInstalling hardinfo from Nux Dextop repo..."
    sudo yum install hardinfo -y &> /dev/null
    printf "[DONE]\n"

    # Fix /lib/libc.so.6 error
    printf "\nCreating symlink: /lib/libc.so.6 -> /usr/lib64/libc.so.6"
    sudo ln -s /usr/lib64/libc.so.6 /lib/libc.so.6 &> /dev/null
    printf " [DONE]\n"

    printf "\nhardinfo install path: $(which hardinfo)\n\n"

    # Prompt to open hardinfo
    read -p 'Would you like to open hardinfo (y/n)? ' YESNO
    case $YESNO in
        y|Y ) hardinfo &> /dev/null &;; # redirecting console ouput to suppress gnome-about command not found error
        * ) exit;;
    esac
else
    printf "\nERROR: OS needs to be CentOS 7\n\n"
fi

    




