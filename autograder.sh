#!/bin/bash

time=1
execfile="a.out"
testfolder="tests"
verbose= false

colorSuccess='\033[0;32m'
colorTimeout='\033[0;33m'
colorFailure='\033[0;31m'
colorRemove='\033[0m'

while getopts 't:p:d:v' flag; do
  case "${flag}" in
    t) time=${OPTARG} ;;
    p) execfile="${OPTARG}" ;;
    d) testfolder="${OPTARG}" ;;
    v) verbose= true ;;
  esac
done

if [ ! -f $execfile ]; then
  echo "Program not found, Aborting."
  exit
fi

if [ ! -d $testfolder ]; then
  echo "Test directory not found, Aborting."
  exit
fi

for file in $testfolder/*.in ; do
  name=${file%.in}
  if [ ! -f $name.out ]; then
    echo "Missing $name.out, Aborting."
    exit
  fi
done

for file in $testfolder/*.in ; do
  name=${file%.in}
  timeout $time ./$execfile < $file > $name.out.temp
  if [[ $? -eq 124 ]]; then
    echo -e "${colorTimeout}TIMEOUT : $name${colorRemove}"
  elif [[ $(diff $name.out $name.out.temp) ]]; then
    echo -e "${colorFailure}INCORRECT OUTPUT : $name}"
    echo -e "---========= Expected =========---${colorRemove}"
    cat $name.out
    echo -e "${colorFailure}---========= Produced =========---${colorRemove}"
    cat $name.out.temp
    echo -e "${colorFailure}---============================---${colorRemove}"
  else
    echo -e "${colorSuccess}PASSED : $name${colorRemove}"
  fi
done

rm -f tests/*.temp
