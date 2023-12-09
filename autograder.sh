#!/bin/bash

time=1
execfile="a.out"
execcmd="./"
execauto=true
testfolder="tests"
verbose=false
showinput=false
specific=false
specificTest="0"

colorSuccess='\033[0;32m'
colorTimeout='\033[0;33m'
colorFailure='\033[0;31m'
colorRemove='\033[0m'

function printEndBar() {
  echo -e "${colorFailure}---============================---${colorRemove}"
}

function perfromExecution() {
  name=${file%.in}
  timeout $time $execcmd$execfile < $file > $name.out.temp
  if [[ $? -eq 124 ]]; then
    echo -e "${colorTimeout}TIMEOUT : $name${colorRemove}"
    if [ $showinput = true ]; then
      echo -e "${colorFailure}---========= Input ============---${colorRemove}"
      cat $name.in
      if [ $verbose = false ]; then
        printEndBar
      fi
    fi
    if [ $verbose = true ]; then
      echo -e "${colorFailure}---========= Expected =========---${colorRemove}"
      cat $name.out
      printEndBar
    fi
  elif [[ $(diff $name.out $name.out.temp) ]]; then
    echo -e "${colorFailure}INCORRECT OUTPUT : $name${colorRemove}"
    if [ $showinput = true ]; then
      echo -e "${colorFailure}---========= Input ============---${colorRemove}"
      cat $name.in
      if [ $verbose = false ]; then
        printEndBar
      fi
    fi
    if [ $verbose = true ]; then
      echo -e "${colorFailure}---========= Expected =========---${colorRemove}"
      cat $name.out
      echo -e "${colorFailure}---========= Produced =========---${colorRemove}"
      cat $name.out.temp
      printEndBar
    fi
  else
    echo -e "${colorSuccess}PASSED : $name${colorRemove}"
  fi
}

while getopts 't:p:d:vie:s:' flag; do
  case "${flag}" in
    t) time=${OPTARG} ;;
    p) execfile="${OPTARG}" ;;
    d) testfolder="${OPTARG}" ;;
    v) verbose=true ;;
    i) showinput=true ;;
    e) execcmd="${OPTARG}"
       execauto=false;;
    s) specific=true
       specificTest="${OPTARG}";;
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

if [ $execauto = true ]; then
  case ${execfile##*.} in
    out)
      execcmd="./";;
    py)
      execcmd="python ";;
  esac
fi

if [ $specific = true ]; then
  file=$testfolder/$specificTest.in
  if [ -f $file ]; then
    perfromExecution
  else
    echo "Missing $file, Aborting"
    exit
  fi
else
  for file in $testfolder/*.in ; do
    perfromExecution
  done
fi

rm -f tests/*.temp
