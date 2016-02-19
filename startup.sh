#!/bin/bash

#if [[ ! -z ${NGINX_CONF_URL} ]]; then
#  wget ${NGINX_CONF_URL} -O /opt/openresty/nginx/conf/nginx.conf
#fi

#if [[ ! -z ${EXTRA_NGINX_CONF_URL} ]]; then
#  wget ${EXTRA_NGINX_CONF_URL} -O /opt/openresty/nginx/conf/extra-locations.d/extra.conf
#fi

SECRETS_FILE='/var/lib/openswan/ipsec.secrets.inc'

CGW_PUBLIC_IP=${CGW_PUBLIC_IP-'undefined'}
VPNGW_PUBLIC_IP=${VPNGW_PUBLIC_IP-'undefined'}
PSK=${PSK-'undefined'}
#LEFT=$(ip a | grep "global eth0" | awk '{print $2}' | cut -d/ -f1)
LEFT=${LEFT-'undefined'}
LEFT_ID=${LEFT_ID-$CGW_PUBLIC_IP}
RIGHT=${RIGHT-$VPNGW_PUBLIC_IP}
RIGHT_ID=${RIGHT_ID-$VPNGW_PUBLIC_IP}

cat << EOF > ${SECRETS_FILE}
${CGW_PUBLIC_IP} ${VPNGW_PUBLIC_IP}: PSK "${PSK}"
EOF

cat << EOF  > /etc/ipsec.d/home-to-aws.conf
conn home-to-aws
   type=tunnel
   authby=secret
   left=${LEFT}
   leftid=${LEFT_ID}
   leftnexthop=%defaultroute
   leftsubnet=${LEFT_SUBNET}
   right=${RIGHT}
   rightid=${RIGHT_ID}
   rightsubnet=${RIGHT_SUBNET}
   rightnexthop=%defaultroute
   pfs=yes
   auto=start
EOF


service ipsec start && tail -f /dev/stdout /dev/stderr
#/usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon

