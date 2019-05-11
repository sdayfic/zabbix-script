# !/bin/bash

# Node List
NODE_LIST="192.168.1.40 192.168.1.50"

#Date/Time Env
LOG_DATE=`date "+%Y-%m-%d"`
LOG_TIME=`date "+%H:%M:%S"`

CDATE=`date "+%Y-%m-%d"`
CTIME=`date "+%H-%M-%S"`
# Shell Env
SHELL_NAME="deploy"
SHELL_DIR="/home/www/"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"

#Code Env
PRO_NAME="web-demo"
CODE_DIR="/deploy/code/"
CONFIG_DIR="/deploy/config/"
TMP_DIR="/deploy/tmp"
TAR_DIR="/deploy/tar"
LOCK_FILE="/tmp/deploy.lock"

# Remote Dir
REMOTE_DIR="/var/www/html"
RETMP_DIR="/mnt"


usage(){
        echo "Usage: $0 { deploy | rollback | [ list | version ] }"
}


write_log(){
        if [ ! -f  $SHELL_LOG ];then
           cd $SHELL_DIR  &&  touch ${SHELL_NAME}.log
        fi
        LOGINFO=$1
        echo "${LOG_DATE} ${LOG_TIME} $PRO_NAME-${SHELL_NAME} =======> ${LOGINFO}" >> ${SHELL_LOG}

}


lock(){
        touch ${LOCK_FILE}
}

unlock(){

        rm -rf ${LOCK_FILE}
}

code_get() {
        write_log "code_get"
                cd ${CODE_DIR}/$PRO_NAME &&  git pull
                cp -r ${CODE_DIR}/${PRO_NAME} ${TMP_DIR}/
                API_NAME=$(git show | grep commit | cut -d" " -f 2 | head -c 10)
}

code_build(){
        echo 'code_build'


}

code_config(){

        write_log "code_config"
                /bin/cp -r ${CONFIG_DIR}/$PRO_NAME/* ${TMP_DIR}/$PRO_NAME/
                PKG_NAME=${PRO_NAME}-${API_NAME}-${CDATE}-${CTIME}
                cd ${TMP_DIR} &&  mv ${PRO_NAME} ${PKG_NAME}
                write_log "copy and rename is ok"
}


code_tar() {
        write_log "starting tar"
                cd  ${TMP_DIR}  &&  tar czf ${PKG_NAME}.tar.gz ${PKG_NAME}
                write_log "${PKG_NAME}.tar.gz"
}

code_scp(){
        write_log "code_scp"
                for node in $NODE_LIST;do
                        scp ${TMP_DIR}/${PKG_NAME}.tar.gz $node:$RETMP_DIR
                done
                write_log "Completion of remote transmission"
}

cluster_node_remove(){
        write_log 'cluster_node_remove'

}

code_deploy(){
        write_log 'code_deploy'
                for node in $NODE_LIST;do
                        ssh $node "cd $RETMP_DIR \
                                 && tar xvf ${PKG_NAME}.tar.gz \
                                 && rm -f $REMOTE_DIR/${PRO_NAME} \
                                 && ln -s $RETMP_DIR/${PKG_NAME} $REMOTE_DIR/${PRO_NAME}"
                done
        write_log "Decompress Completa"

}


config_diff(){
        echo 'config_diff'

}



code_test(){
        echo "code_test"

}


cluster_node_in(){
        echo "cluster_node_in"



}

rollback_fun(){
    ls -l ${TMP_DIR}/$1 &> /dev/null 
        if [ $? -ne 0 ] ; then
           echo "Not Found Version !"
           unlock
       exit 1
        fi
           for node in $NODE_LIST;do
            ssh $node "rm -f ${REMOTE_DIR}/$PRO_NAME \
                              && ln -s ${RETMP_DIR}/$1 ${REMOTE_DIR}/$PRO_NAME"
           done
}


rollback(){
        write_log "rollback"
                if [ -z  $1 ]; then
                   echo "Usage  rollback [ list | version ]"
                   unlock
                   exit 1
                                fi
                case $1 in
                        list)
                          ls -lrt ${TMP_DIR} | grep "^d"
                                                   ;;
                        *)
                          rollback_fun $1;
                           ;;
                esac

}


main(){
        if [ -f $LOCK_FILE ] ; then
               echo "The Script Is Running" && exit 1
        fi
        DEPLOY_METHOD=$1
        ROLLBACK_VER=$2
        case ${DEPLOY_METHOD} in
                deploy)
                    lock;
                    code_get;
                    code_build;
                    code_config;
                    code_tar;
                    code_scp;
                    cluster_node_remove;
                    code_deploy;
                    config_diff;
                    code_test;
                    cluster_node_in;
                    unlock;
                    ;;
                rollback)
                    lock;
                    rollback ${ROLLBACK_VER};
                    unlock;
                    ;;
                *)
                    usage;
        esac
}

main $1 $2