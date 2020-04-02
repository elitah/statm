#!/bin/sh

totalmem="0"

for path in `find /proc -maxdepth 1 -type d`
do
  if [ -f ${path}/statm ]; then
    realpath=`readlink -f ${path}/exe`
    cmdline=`cat ${path}/cmdline | head -c 1`
    resident=`cat ${path}/statm | awk '{print $2}'`
    if [ ! -z ${cmdline} ] && [ ! -z ${resident} ]; then
      if [ 1024 -le ${resident} ]; then
        echo -e "\033[31;1m"
      elif [ 256 -le ${resident} ]; then
        echo -e "\033[35;1m"
      elif [ 128 -le ${resident} ]; then
        echo -e "\033[33;1m"
      elif [ 64 -le ${resident} ]; then
        echo -e "\033[34;1m"
      elif [ 32 -le ${resident} ]; then
        echo -e "\033[32;1m"
      fi
      totalmem=`expr ${totalmem} + ${resident}`
      echo "--- `basename ${path}` ---------------------------------------------------------"
      echo "appname: ${realpath}"
      echo "cmdline: `cat ${path}/cmdline | tr '\0' ' '`"
      echo "statm: `cat ${path}/statm`"
      if [ 256 -le ${resident} ]; then
        echo "statm: ${resident}(`expr ${resident} \* 4 / 1024` MB)"
      else
        echo "statm: ${resident}(`expr ${resident} \* 4` KB)"
      fi
      echo -e "\033[0m"
    fi
  fi
done

echo ""
echo ""
echo ""
echo ""
echo "total: ${totalmem}(`expr ${totalmem} \* 4 / 1024` MB)"
