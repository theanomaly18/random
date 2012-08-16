#!/bin/sh
## note this was really my first attempt at any kind of original shell script

num=1
zero=0

site="http://www.odditieszone.com/wp-content/uploads/2012/01/drunk-vision-"
format=".jpg"

while [ $num -lt 46 ]; do
  let num=$num
  if [ $num -lt 10 ]
    then
	  wget ${site}${zero}${num}${format}
  fi
  if [ $num -gt 9 ]
    then
      wget ${site}${num}${format}
  fi
  let num+=1
done
  
#EOF