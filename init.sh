#!bin/bash
cat << EOF
+---------------------------------------------------------------------------+
|  Initialize for the CentOS 7_installed.                                   |
+---------------------------------------------------------------------------+
EOF
 
function format() {
    #sleep 1
    #echo -e "\033[42;37m ########### Finished ########### \033[0m\n"
    echo -e "\033[32m Install Success!!!\033[0m\n"
}

##########################################################################
# Epel update epel
#echo "Install epel AND Yum"
#YUM=/etc/yum.repos.d
#cd $YUM
#rm -rf *
#touch subin.repo
#cat <<EOF > subin.repo 
#[subin]
#name=subin
#baseurl=file:///media/cdrom
#gpgcheck=0
#EOF
#yum install wget -y
#wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo &> /dev/null
#format
##########################################################################
#Yum install tools  
echo 'install tools'
yum install bash-com* -y
yum install lrzsz.x86_64 -y
yum install psmisc
yum install net-tools
yum install vim -y
format
########################################################################### 
# Set  prompt
echo 'set prompt'
touch /etc/profile.d/subin.sh
cat <<EOF > /etc/profile.d/subin.sh
PS1="\[\e[32m\][\u@\h \w]\\$\[\e[0m\]" 
EOF
. /etc/profile.d/subin.sh
format
###########################################################################
# Disabled Selinux Selinux
echo "Disabled SELinux."
sed -ir '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
format
 
###########################################################################
# Stop firewalld   disabled firewalld
echo "disabled firewalld."
systemctl stop firewalld
systemctl disable  firewalld.service
iptables -F
format
 
###########################################################################
#Set VIM 
echo "Set Vim."
cat << EOF > ~/.vimrc
set number
set laststatus=2
set shiftwidth=4
set tabstop=4
set noexpandtab
set softtabstop=4
set cmdheight=3
set cursorline
set formatoptions=tcrqn 
set encoding=utf-8
set background=dark 
set ruler 
EOF
. ~/.vimrc
format

