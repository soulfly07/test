#!/usr/bin/bash

s=$1
m=`echo 60/$s|bc`
a=$(cd ~/ceremonyclient/node && ./node-1.4.21-linux-amd64 -balance | grep 'Unclaimed balance:' | egrep -o "[0-9].*$" | sed -r 's/ .+//')
sleep $s
b=$(cd ~/ceremonyclient/node && ./node-1.4.21-linux-amd64 -balance | grep 'Unclaimed balance:' | egrep -o "[0-9].*$" | sed -r 's/ .+//')
c=`echo $b-$a | bc` #сложить цифры float

echo Был баланс  $a , через $1 секунд стал  $b , прибыль на отрезке -  $c
echo В минуту      - 0`echo $c*$m | bc` QUIL
echo В час         - 0`echo $c*$m*60 | bc` QUIL
echo В сутки       - 0`echo $c*$m*60*24 | bc` QUIL
