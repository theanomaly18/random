#!/bin/sh

num1=1
num2=1
lettern=n
letters=s
letterw=w
lettere=e

site="http://imgs.xkcd.com/clickdrag/"
format=".png"

while [ $num1 -lt 10 ]; do
  let num1=$num1
  while [ $num2 -lt 50 ]; do
    #let num2=$num2
	wget -N ${site}${num1}${lettern}${num2}${letterw}${format}
	let num2+=1
  done
  let num1+=1
  let num2=1
done

num1=1
num2=1

while [ $num1 -lt 10 ]; do
  let num1=$num1
  while [ $num2 -lt 50 ]; do
    let num2=$num2
	wget -N ${site}${num1}${lettern}${num2}${lettere}${format}
	let num2+=1
  done
  let num1+=1
  let num2=1
done

num1=1
num2=1

while [ $num1 -lt 10 ]; do
  let num1=$num1
  while [ $num2 -lt 50 ]; do
    let num2=$num2
	wget -N ${site}${num1}${letters}${num2}${lettere}${format}
	let num2+=1
  done
  let num1+=1
  let num2=1
done
 
num1=1
num2=1

while [ $num1 -lt 10 ]; do
  let num1=$num1
  while [ $num2 -lt 50 ]; do
    let num2=$num2
	wget -N ${site}${num1}${letters}${num2}${letterw}${format}
	let num2+=1
  done
  let num1+=1
  let num2=1
done

#EOF
