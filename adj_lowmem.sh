#!/system/bin/sh

#echo "12288,15360,18432,21504,24576,30720" > /sys/module/lowmemorykiller/parameters/minfree
echo "6144,7680,9216,10752,12288,15360" > /sys/module/lowmemorykiller/parameters/minfree
