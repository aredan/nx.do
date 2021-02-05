#!/bin/bash
#Update script for "nx.do" on BIND9/Ubuntu 18.04

#Variables
TLD='nx.do'
NS='nxdns.aanetworks.org.'
EMAIL='admin.aanetworks.org.'
CHECKZONE=/usr/sbin/named-checkzone
TMP_DEST='/tmp/db.nx.do'
WORK_DIR='/home/nxdo/nx.do/'
FILE_NAME='db.nx.do'
OUTPUT_DIR='/etc/bind/zone/master/'
FILES=${WORK_DIR}zone/*

cd $WORK_DIR
git fetch origin > /dev/null
git reset --hard origin > /dev/null

# ADD NEW SOA!
{ echo "nx.do.		IN	SOA	$NS $EMAIL ("
  echo "        `date +%Y%m%d%H`  ; serial"
  echo "        10800    ; refresh"
  echo "        1800    ; retry"
  echo "        604800    ; expire"
  echo "        3600    ; minimum"
  echo "        )"
} > $WORK_DIR$FILE_NAME

# ADD NAMESERVERS!
{ echo "; TLD information"
  echo "		IN	NS	ns2.he.net."
  echo "		IN	NS	ns3.he.net."
  echo "		IN	NS	ns4.he.net."
  echo "		IN	NS	ns5.he.net."
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
  else
    echo "Processed ${f}.nx.do Successfully"
    echo "; `git log --oneline -- $f | tail -n 1`" >> $FILE_NAME
    cat $f >> $FILE_NAME
  fi

  VERIFY=$($CHECKZONE $TLD "$WORK_DIR$FILE_NAME" | tail -n 1)
  if [ "$VERIFY" != "OK" ]; then
    echo "Some unknown error occured: $WORK_DIR$FILE_NAME"
    exit 1
  fi
done

rm ${OUTPUT_DIR}db*
cp $WORK_DIR$FILE_NAME $OUTPUT_DIR

sudo systemctl reload bind9
