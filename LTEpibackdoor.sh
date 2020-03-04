#!/bin/bash
#exit
cd /opt/nac_bypass/
echo "`date` - Restarting network-mananger to start fresh..." >> log.txt
service network-manager restart
ifconfig wwan0 up
ifmetric wwan0 0

echo "`date` - Starting NAC bypass in tmux session..." >> log.txt
tmux new-session -d -s "nac" "./nac_bypass_setup.sh -1 eth0 -2 eth1 -a" 
echo "`date` - Creating pcap..." >> log.txt
timeout 28800 tcpdump -i eth0 -s 65535 -t -w pi_`date +%Y%M$D%H%M%S`.pcap &

# Sometimes LTE won't come up...
ifmetric wwan0 0
echo "`date` - Checking LTE IP..." >> log.txt
IP=`timeout 5 curl -s icanhazip.com`
RE=^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$
while ! [[ $IP =~ ${RE} ]]; do
    echo "`date` - No LTE IP. Waiting..." >> log.txt
        sleep 10
        IP=`timeout 5 curl -s icanhazip.com`
done
echo "`date` - LTE IP is "$IP >> log.txt

# Make sure we have the correct time for Tor to work...
echo "`date` - Checking that NTP is up..." >> log.txt
service ntp restart
ntpstat
status=$?
while [ $status != "0" ]; do
    echo "`date` - Clock not synced..." >> log.txt
    service ntp restart
    for x in {1..10}; do
        sleep 6
        ntpstat
        status=$?
        if [ "$status" == "0" ]; then
            break
        fi
    done
done

# Sometimes Tor service hangs...
echo "`date` - Checking Tor IP..." >> log.txt
IP=''
IP=`timeout 5 torify curl -s icanhazip.com`
RE=^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$
while ! [[ $IP =~ ${RE} ]]; do
    echo "`date` - No Tor IP. Restarting Tor service..." >> log.txt
    service tor restart
    sleep 5
    IP=`timeout 5 torify curl -s icanhazip.com`
    echo "`date` - Tor exit IP is "$IP >> log.txt
done
