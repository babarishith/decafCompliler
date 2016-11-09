#!/bin/bash
rm -f recovered
cp $1 recovered
while read -r line 
do
	list=($line)
	from=${list[0]}
	to=${list[1]}
	sed "s/$from/$to/g" recovered > ol
	cp ol recovered
done < "$2"

