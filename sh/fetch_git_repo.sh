#!/bin/sh

p=$(cd "$(dirname "$0")"; pwd)
cd $p
cd ../repo
echo "Working in $(pwd)"

for i in *.git
do 
cd $i
echo "In $(pwd)"
git fetch --all
cd ../
done

