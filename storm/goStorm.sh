#!/bin/bash
#
# Configures a minimal storm cluster from environment variables
# Expects one or more of the following:
#     STORM_CFG - file to alter
#     KZK_PORT_2181_TCP_ADDR - IP of zookeeper host(s)
#     NIMBUS_PORT_6627_TCP_ADDR - IP of nimbus host
#     UI_PORT_8081_TCP_ADDR - IP of ui host
#     WORK_DIR - used for storm-local-dir

CFG=$STORM_CFG
ZK_HOST=$KZK_PORT_2181_TCP_ADDR
MY_ID=$(uname -n)
MY_HOST=$(grep $MY_ID /etc/hosts | awk '{print $1, "\t"}')

case $1 in
"nimbus") 
    NB_HOST=${MY_HOST} 
    ;;
"ui") 
    UI_HOST=${MY_HOST}
    NB_HOST=$NIMBUS_PORT_6627_TCP_ADDR
    ;;
"supervisor")
    NB_HOST=$NIMBUS_PORT_6627_TCP_ADDR    
    ;;
esac

echo "# created at $(date --rfc-3339=seconds)" > $CFG
echo "ui.port: 8081" >> $CFG
if [ -v UI_HOST ] ; then 
    echo "ui.host: $UI_HOST" >> $CFG
fi
echo "storm.zookeeper.servers:" >> $CFG
echo "   - $ZK_HOST" >> $CFG
echo "storm.local.dir: $WORK_DIR" >> $CFG
if [ -v NB_HOST ] ; then 
    echo "nimbus.seeds: [${NB_HOST}]" >> $CFG
    echo "nimbus.host: ${NB_HOST}" >> $CFG
fi
echo "--- dumping $CFG ---"
cat $CFG
echo "--- $CFG end ---"

CFG="service.cfg"
echo "[supervisord]" >> $CFG
echo "[program:$1]" >> $CFG
echo "autostart=true" >> $CFG
echo "autorestart=true" >> $CFG
echo "command=./storm $1" >> $CFG
# this should run some kind of supervision; but
# supervisord does not show log output by console
# (would require privs to do so); not using.
# supervisord -n -c $CFG

case $1 in
"nimbus")
  mkdir ${STORM_VOL}
  cp -r ${STORM_DIR}/* ${STORM_VOL} 
esac

./storm $1
