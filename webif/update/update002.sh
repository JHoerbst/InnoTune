#!/bin/bash
echo "running update002"

# add commands here

#installs wiringPi for tinkerboard
cd /root/
git clone http://github.com/TinkerBoard/gpio_lib_c --depth 1 GPIO_API_for_C
cd GPIO_API_for_C/
sudo chmod +x build

sudo ./build

#make dirs and files for gpio
sudo mkdir /opt/innotune/settings/gpio
sudo mkdir /opt/innotune/settings/gpio/mute

sudo printf "0" > /opt/innotune/settings/gpio/coding
sudo printf "0;0;0" > /opt/innotune/settings/gpio/fan_options

for i in $(seq -f "%02g" 1 10)
do
    sudo touch "/opt/innotune/settings/gpio/mute/p$i"
    sudo printf "0;0" > "/opt/innotune/settings/gpio/mute/state$i"
done

sudo chmod -R 777 /opt/innotune/settings

# kill programs so we can override the old ones
killall fanreg
killall mutecard
killall readCoding

#copy gpio files to the right place
sudo cp /var/www/src/gpio/fanreg /var/www/src/fanreg
sudo cp /var/www/src/gpio/mutecard /var/www/src/mutecard
sudo cp /var/www/src/gpio/readCoding /var/www/src/readCoding

sudo cp /var/www/src/gpio/fanreg.sh /var/www/fanreg.sh
sudo cp /var/www/src/gpio/mutereg.sh /var/www/mutereg.sh

sudo chmod -R 777 /var/www

sudo cp /opt/innotune/update/cache/InnoTune/dhclient.conf /etc/dhcp/dhclient.conf

sudo touch /opt/innotune/settings/lmswa.txt
sudo chmod 777 /opt/innotune/settings/lmswa.txt

sudo touch /var/www/InnoControl/log/lmswa.log
sudo chmod 777 /var/www/InnoControl/log/lmswa.log

ln -s /var/log /var/www/InnoControl/log/syslogs

touch /opt/innotune/settings/knxcallbacks
chmod 777 /opt/innotune/settings/knxcallbacks

touch /var/log/knxlistener
chmod 777 /var/log/knxlistener
touch /var/log/knxcallback
chmod 777 /var/log/knxcallback

sudo cp /opt/innotune/update/cache/InnoTune/logrotate.conf /etc/logrotate.conf
sudo cp /opt/innotune/update/cache/InnoTune/journald.conf /etc/systemd/journald.conf

sudo rm -R /var/log/journal
sudo rm -R /var/log.hdd/journal

# set new update count and reference to newer update file
sudo echo "2" > /opt/innotune/settings/update_cnt.txt
echo "100% - finished update" > /opt/innotune/settings/updatestatus.txt
#/var/www/update/update003.sh
