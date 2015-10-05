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
UI_HOST=$UI_PORT_8081_TCP_ADDR
ZK_HOST=$KZK_PORT_2181_TCP_ADDR
NB_HOST=$NIMBUS_PORT_6627_TCP_ADDR

echo "# created at $(date --rfc-3339=seconds)" > $CFG
echo "ui.port: 8081" >> $CFG
if [ -n $UI_PORT_8081_TCP_ADDR ] ; then 
    echo "ui.host: $UI_HOST" >> $CFG
fi
echo "storm.zookeeper.servers:" >> $CFG
echo "   - $ZK_HOST" >> $CFG
echo "storm.local.dir: $WORK_DIR" >> $CFG
if [ -n $NIMBUS_PORT_6627_TCP_ADDR ] ; then 
    echo "nimbus.seeds: [${NB_HOST}]" >> $CFG
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

./storm $1