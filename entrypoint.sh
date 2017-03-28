#!/bin/bash
set -e

run_zk() {
    if [ -z $ZK_ID ]; then
        echo "no ZK_ID found. Getting from hostname"
        [[ ! `hostname` =~ -([0-9]+)$ ]] && echo "Unable to get ZK_ID from hostname!" && exit 1
        ordinal=${BASH_REMATCH[1]}
        
        ZK_ID=$((1 + $ordinal))
    fi

    echo $ZK_ID > /var/lib/zookeeper/myid
    cat /var/lib/zookeeper/myid

    if [ -f /etc/zookeeper/zoo.cfg ]; then
        cp -f /etc/zookeeper/zoo.cfg /opt/zookeeper/conf/
    fi

    sed -ie "s/`hostname`[^:]*:/0.0.0.0:/g" /opt/zookeeper/conf/zoo.cfg

    exec /opt/zookeeper/bin/zkServer.sh start-foreground
}

case "$1" in
    run)
        shift 1
        run_zk "$@"
        ;;
    *)
        exec "$@"
esac
