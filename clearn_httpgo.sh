systemctl stop crond
systemctl stop pwnrigl
systemctl stop pwnrig
systemctl stop bashgo
sudo kill -9 $(pidof python) || kill -9 $(pidof curl) || ps aux
rm -f /tmp/go /tmp/i686 /tmp/x64b /tmp/x86_64 /tmp/x86_643 /tmp/dbusex /tmp/hxx
chattr -ia /var/spool/cron/root /var/spool/cron/crontabs/root /var/spool/cron/crontabs/bashgo /var/spool/cron/bashgo  /var/spool/cron/crontabs/httpgo /var/spool/cron/httpgo 
rm -f /var/spool/cron/root /var/spool/cron/crontabs/root /var/spool/cron/crontabs/bashgo /var/spool/cron/bashgo /var/spool/cron/crontabs/httpgo /var/spool/cron/httpgo 
chattr -ia /usr/bin/bprofr /usr/bin/crondr /usr/bin/initdr /usr/bin/sysdr /usr/bin/httpgo /usr/bin/bashgo
rm -f /usr/bin/bprofr /usr/bin/crondr /usr/bin/initdr /usr/bin/sysdr /usr/bin/httpgo /usr/bin/bashgo
kill -9 $(pidof dbused)
# chattr -ia ~/.bash_profile
# sed -i '$d' ~/.bash_profile
chattr -ia /etc/init.d/down /etc/init.d/pwnrig /etc/init.d/pwnrig/bashgo  /etc/init.d/pwnrig/httpgo
rm -f /etc/init.d/down /etc/init.d/pwnrig /etc/init.d/pwnrig/httpgo
chattr -ia /etc/cron.d/apache /etc/cron.d/nginx /etc/cron.d/pwnrig /etc/cron.d/root /etc/cron.d/bashgo /etc/cron.d/httpgo
rm -f /etc/cron.d/apache /etc/cron.d/nginx /etc/cron.d/pwnrig /etc/cron.d/root /etc/cron.d/bashgo /etc/cron.d/httpgo
chattr -ia /etc/cron.daily/pwnrig /etc/cron.daily/bashgo /etc/cron.daily/httpgo
rm -f /etc/cron.daily/pwnrig /etc/cron.daily/bashgo /etc/cron.daily/httpgo
chattr -ia /etc/cron.hourly/pwnrig /etc/cron.hourly/oanacroner1 /etc/cron.hourly/bashgo /etc/cron.hourly/httpgo
rm -f /etc/cron.hourly/pwnrig /etc/cron.hourly/oanacroner1 /etc/cron.hourly/bashgo /etc/cron.hourly/httpgo
chattr -ia /etc/cron.monthly/pwnrig /etc/cron.monthly/bashgo /etc/cron.monthly/httpgo
rm -f /etc/cron.monthly/pwnrig /etc/cron.monthly/bashgo /etc/cron.monthly/httpgo
chattr -ia /etc/cron.weekly/pwnrig /etc/cron.weekly/bashgo /etc/cron.weekly/httpgo
rm -f /etc/cron.weekly/pwnrig /etc/cron.weekly/bashgo /etc/cron.weekly/httpgo
rm -f /etc/rc0.d/K60pwnrig
rm -f /etc/rc1.d/K60pwnrig
rm -f /etc/rc2.d/S90pwnrig
rm -f /etc/rc3.d/S90pwnrig
rm -f /etc/rc4.d/S90pwnrig
rm -f /etc/rc5.d/S90pwnrig
rm -f /etc/rc6.d/K60pwnrig
chattr -ia /etc/systemd/system/pwnrige.service /etc/systemd/system/multi-user.target.wants/pwnrige.service /etc/systemd/system/multi-user.target.wants/pwnrigl.service /usr/lib/systemd/system/pwnrigl.service /etc/systemd/system/bashgo.service /etc/systemd/system/httpgo.service  /usr/lib/systemd/system/bashgo.service /usr/lib/systemd/system/httpgo.service
rm -f /etc/systemd/system/pwnrige.service etc/systemd/system/pwnrige.service /etc/systemd/system/multi-user.target.wants/pwnrige.service /etc/systemd/system/multi-user.target.wants/pwnrigl.service /usr/lib/systemd/system/pwnrigl.service  /etc/systemd/system/bashgo.service /etc/systemd/system/httpgo.service  /usr/lib/systemd/system/bashgo.service /usr/lib/systemd/system/httpgo.service
systemctl start crond
