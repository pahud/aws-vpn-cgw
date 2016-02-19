#!/bin/bash

CGW_PUBLIC_IP='125.227.251.251'
VPNGW_PUBLIC_IP='52.69.16.16'
LEFT='192.168.31.232'
LEFT_SUBNET='192.168.31.0/24'
RIGHT_SUBNET='10.0.0.0/16'
PSK='xxxxxxxxxxxxxxxx'

# bring up IPSec kernel support from the host
ipsec setup restart
docker rm -f cgw
docker run --name cgw -d \
--privileged \
--net=host \
 -e CGW_PUBLIC_IP="${CGW_PUBLIC_IP}" \
 -e VPNGW_PUBLIC_IP="${VPNGW_PUBLIC_IP}" \
 -e LEFT="${LEFT}" \
 -e LEFT_SUBNET="${LEFT_SUBNET}" \
 -e RIGHT_SUBNET="${RIGHT_SUBNET}" \
 -e PSK="${PSK}" \
 pahud/aws-vpn-cgw:latest
