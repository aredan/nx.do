#!/bin/bash
#Update script for "nx.do" on BIND9/Ubuntu 18.04

#Variables
TLD='nx.do'
NS='nxdns.aanetworks.org.'
EMAIL='admin.aanetworks.org.'
TTL='TTL 5m'
CHECKZONE=/usr/sbin/named-checkzone
TMP_DEST='db.nx.do-tmp'
WORK_DIR=''
FILE_NAME='db.nx.do'
FILES=${WORK_DIR}zone/*

# ADD NEW SOA!
{  
  echo "nx.do.		IN	SOA	$NS $EMAIL ("
  echo "        `date +%Y%m%d%H`  ; serial"
  echo "        4H    ; refresh (4 hours)"
  echo "        1H    ; retry (1 hour)"
  echo "        1W    ; expire (1 week)"
  echo "        1H    ; minimum (1 hour)"
  echo "        )"
} > $WORK_DIR$FILE_NAME

# ADD NAMESERVERS!
{ echo "; TLD information"
  echo "		IN	NS	ns2.he.net."
  echo "		IN	NS	ns3.he.net."
  echo "		IN	NS	ns4.he.net."
  echo "    IN  NS  ns5.he.net."
  echo ";"
  echo "; Additional zones"
  echo ";"
} >> $WORK_DIR$FILE_NAME


for f in $FILES
do
  cp $WORK_DIR$FILE_NAME $TMP_DEST
  cat $f >> $TMP_DEST

  TEST=$($CHECKZONE $TLD "$TMP_DEST" | tail -n 1)
  if [ "$TEST" != "OK" ]; then
    echo "Failed to add ${f}.nx.do to the main zone!"
    exit 1
  else
    echo "Processed ${f}.o Successfully"
    echo "; `git log --oneline -- $f | tail -n 1`" >> $FILE_NAME
    cat $f >> $FILE_NAME
  fi

  VERIFY=$($CHECKZONE $TLD "$WORK_DIR$FILE_NAME" | tail -n 1)
  if [ "$VERIFY" != "OK" ]; then
    echo "Some unknown error occured: $WORK_DIR$FILE_NAME"
    exit 1
  fi
done

exit 0
