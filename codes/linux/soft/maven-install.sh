#!/usr/bin/env bash

###################################################################################
# 控制台颜色
BLACK="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
RESET="$(tput sgr0)"
###################################################################################

printf "${BLUE}"
cat << EOF

###################################################################################
# 安装 Maven3 脚本
# Maven 会被安装到 /opt/maven 路径。
# @system: 适用于所有 linux 发行版本。
# 注意：Maven 要求必须先安装 JDK
# @author: Zhang Peng
###################################################################################

EOF
printf "${RESET}"

printf "${GREEN}>>>>>>>> install maven begin.${RESET}\n"

command -v java >/dev/null 2>&1 || { printf "${RED}Require java but it's not installed.${RESET}\n"; exit 1; }

if [[ $# -lt 1 ]] || [[ $# -lt 2 ]];then
  printf "${PURPLE}[Hint]\n"
  printf "\t sh maven-install.sh [version] [path]\n"
  printf "\t Example: sh maven-install.sh 3.6.0 /opt/maven\n"
  printf "${RESET}\n"
fi

version=3.6.0
if [[ -n $1 ]]; then
  version=$1
fi

path=/opt/maven
if [[ -n $2 ]]; then
  path=$2
fi

# install info
printf "${PURPLE}[Info]\n"
printf "\t version = ${version}\n"
printf "\t path = ${path}\n"
printf "${RESET}\n"

# download and decompression
mkdir -p ${path}
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O ${path}/apache-maven-${version}-bin.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz
tar -zxvf ${path}/apache-maven-${version}-bin.tar.gz -C ${path}

# setting env
path=${path}/apache-maven-${version}
cat >> /etc/profile << EOF
export MAVEN_HOME=${path}
export PATH=\$MAVEN_HOME/bin:\$PATH
EOF
source /etc/profile

# replace mirrors in settings.xml
echo -e "\n>>>>>>>>> replace ${path}/conf/settings.xml"
cp ${path}/conf/settings.xml ${path}/conf/settings.xml.bak
wget -N https://gitee.com/turnon/linux-tutorial/raw/master/codes/linux/soft/config/settings-aliyun.xml -O ${path}/conf/settings.xml

printf "${GREEN}<<<<<<<< install maven end.${RESET}\n"
mvn -v
