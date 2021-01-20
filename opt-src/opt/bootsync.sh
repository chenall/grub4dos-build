#!/bin/sh
# put other system startup commands here, the boot process will wait until they complete.
# Use bootlocal.sh for system startup commands that can run in the background 
# and therefore not slow down the boot process.
/usr/bin/sethostname box
/opt/bootlocal.sh &
echo Start SSH Server...
sudo /usr/local/etc/init.d/openssh start &
for i in `seq 1 10`
do
	ROUTE=`route -n | awk '/^0.0.0.0/ { print $2 }'`
	echo ok | nc $ROUTE 22223 && break
	sleep 2
done


