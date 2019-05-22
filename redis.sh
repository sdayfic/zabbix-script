#!/bin/bash
# Redis Cluster Install
# by subin
DATA_TMP="/tmp"
REDIS_VER=redis-5.0.5
INSTALL_DIR="/usr/local/redis"
CLUSTER_DIR="/data/cluster/"
CLUSTER_NUM=6
CLUSTER_CONFIG="redis.conf"

# Downlod File
download(){
yum install wget gcc -y
if [ ! -d $DATA_TMP ];then
        mkdir $DATA_TMP
fi

cd $DATA_TMP
if [ ! -f $REDIS_VER.tar.gz ];then
   wget http://download.redis.io/releases/$REDIS_VER.tar.gz
   tar xvf $REDIS_VER.tar.gz
fi
}



# Exec File

exec_file(){
cd $REDIS_VER
make MALLOC=libc/jemalloc && \
   make install PREFIX=$INSTALL_DIR && \
   cp $CLUSTER_CONFIG $INSTALL_DIR/bin/
}


#Edit Config

edit_config(){
cd $INSTALL_DIR/bin/
sed -i 's/daemonize no/daemonize yes/g'  $CLUSTER_CONFIG

#Create Cluster
if [ ! -d $CLUSTER_DIR ]; then
        mkdir -p $CLUSTER_DIR
fi

for i in `seq 1 $CLUSTER_NUM`;
do
        mkdir $CLUSTER_DIR/redis$i
        cd $CLUSTER_DIR/redis$i
        cp -r $INSTALL_DIR/bin .
        cd $CLUSTER_DIR/redis$i/bin
        sed -i 's/# cluster-enabled yes/cluster-enabled yes/g'  $CLUSTER_CONFIG
        sed -i "s/port 6379/port 700$i/g"  $CLUSTER_CONFIG
        ./redis-server $CLUSTER_CONFIG
        cd /
done
}

check(){

proccess=`ps aux | grep -v "grep" | grep "redis-server" | wc -l` 
if [ $proccess -eq  $CLUSTER_NUM ]; then
        echo " $proccess  Redis   Is  Started "
fi
}

# Add Cluster

add_cluster(){
        cd $INSTALL_DIR/bin
    ./redis-cli --cluster create 127.0.0.1:7001 && \
                 127.0.0.1:7002 127.0.0.1:7003 && \
                 127.0.0.1:7004  127.0.0.1:7005 && \
                 127.0.0.1:7006 


}


main(){
        download
        exec_file
        edit_config
        check
        add_cluster
}

main
echo 'REDIS CLUSTER IS ALL OK '
	
	




