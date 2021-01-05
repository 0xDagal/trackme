#/bin/bash

#Colors
ERROR='\0033[1;31m'
NOCOLOR='\033[0m'

#Default values
# victim='e0:dc:ff:f5:f2:05'
# network_ssid='"zai barty"'
# file=lastscan.pcapng
victim=''
network_ssid=''
file=''

#Different options
#f n and v needs an argument so me have a : in front of it
optstring='hf:n:v:'

nbOpt=0
help_s=0
file_s=0

while getopts ${optstring} arg; do
  nbOpt+=1
  case ${arg} in
    h)
      echo "Usage ./trackme.sh [options]"
      echo "    -v {victim @mac} To follow the mac address of your victim"
      echo "    -f {tshark/wireshark file capture} If you want to try in a past capture, 
      if you don't use this make sure to have sudo privilege, be sure to monitor your wireless driver first (with airmon-ng for example)"
      echo "    -n {network ssid} the ssid of the network you're scanning"
      echo "    -h See this actual help"
      help_s=1
      ;;
    f)
      file=$OPTARG
      file_s=1
      ;;
    v)
      victim=$OPTARG
      ;;
    n)
      network_ssid=$OPTARG
      ;;
    esac
  done
if [ $nbOpt -eq 0 ]; then
  echo -e "${ERROR}This script needs options. See -h for help${NOCOLOR}"
elif [ $help_s != 1 ]; then
  if [ $file_s -eq 1 ]; then 
    tshark -r $file "wlan.sa == $victim
      && wlan.ssid==$network_ssid
      && wlan.da!=ff:ff:ff:ff:ff:ff"
  else 
    tshark "wlan.sa == $victim
      && wlan.ssid==$network_ssid
      && wlan.da!=ff:ff:ff:ff:ff:ff"
  fi
fi
