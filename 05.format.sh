#!/bin/bash
################# vgcreate
#pvcreate /dev/sda3
vgcreate vg00 /dev/sda2
lvcreate -L 80G -n lv0 vg00

for i in {1..35}
do
lvcreate -L 2G -n lv${i} vg00
done

########################
umount `cat /etc/mtab|grep srv|awk '{print $2}'`
rm -rf /srv/node/*
########################

#DISKS="c:vg00/lv1:1 d:vg00/lv2:2 e:vg00/lv3:3 f:vg00/lv4:4 g:vg00/lv5:5 h:vg00/lv6:6 i:vg00/lv7:7 j:vg00/lv8:8 k:vg00/lv9:9 l:vg00/lv10:10 m:vg00/lv11:11 n:vg00/lv12:12"
DISKS="c:vg00/lv1:1 d:vg00/lv2:2 e:vg00/lv3:3 f:vg00/lv4:4 g:vg00/lv5:5 h:vg00/lv6:6 i:vg00/lv7:7 j:vg00/lv8:8 k:vg00/lv9:9 l:vg00/lv10:10 m:vg00/lv11:11 n:vg00/lv12:12"
DISKS="$DISKS o:vg00/lv13:13 p:vg00/lv14:14 q:vg00/lv15:15 r:vg00/lv16:16 s:vg00/lv17:17 t:vg00/lv18:18 u:vg00/lv19:19 v:vg00/lv20:20 w:vg00/lv21:21 x:vg00/lv22:22 y:vg00/lv23:23 z:vg00/lv24:24"
DISKS="$DISKS aa:vg00/lv25:25 ab:vg00/lv26:26 ac:vg00/lv27:27 ad:vg00/lv28:28 ae:vg00/lv29:29 af:vg00/lv30:30 ag:vg00/lv31:31 ah:vg00/lv32:32 ai:vg00/lv33:33 aj:vg00/lv34:34 b:vg00/lv35:35"

for dev in $DISKS
do

datad=`echo $dev|awk -F: '{print $1}'`
logd=`echo $dev|awk -F: '{print $2}'`
mntd=`echo $dev|awk -F: '{print $3}'`

disk="sd$datad"
logd="$logd"
mntd="sd$mntd"

umount /dev/$disk
umount /dev/$mntd

dd if=/dev/zero of=/dev/$disk bs=10M count=1
mkfs.xfs -f -l logdev=/dev/${logd},size=512m /dev/$disk
mkdir -p /srv/node/$mntd
mount -t xfs -o logdev=/dev/${logd},defaults,noatime,nodiratime,nobarrier,logbufs=8,inode64,logbsize=256k /dev/${disk} /srv/node/${mntd}

done

mkfs.xfs -f /dev/vg00/lv0
mkdir -p /srv/node/sd0
mount -t xfs -o defaults,noatime,nodiratime,nobarrier,logbufs=8,inode64,logbsize=256k /dev/vg00/lv0 /srv/node/sd0

chown -R swift:swift /srv/node
