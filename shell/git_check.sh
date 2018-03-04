#!/bin/bash 

clear
echo ""
echo "GIT changes for $1"
echo ""
cd $1 && git status -sbv
echo ""

echo "$1 directory contents"
echo ""
ls -lart
