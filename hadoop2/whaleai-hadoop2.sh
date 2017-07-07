#! /bin/bash
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 20170630
# Path: /whaleai/whale-bigdata/init.sh
# Organization: https://github.com/whaleai

HADOOP_VERSION=2.7.3
HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
install()
{
source whaleai-config.sh

if [[ ! -f hadoop-$HADOOP_VERSION.tar.gz ]]; then
  echo "目标文件不存在,请将　hadoop-$HADOOP_VERSION.tar.gz　下载并放置本文件中
5 秒后自动退出......"
  sleep 5
  exit 0
fi

if [[  -f $HADOOP_HOME/etc/hadoop/core-site.xml ]]; then
  #statements
  echo "需要移除hadoop残余文件
请执行 . whaleai-hadoop2.sh -r
8　秒后自动退出
"
  sleep 8
  exit 0

fi

sudo apt install -y openssh-server
sudo apt install -y ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
ssh-add
# ssh localhost
sudo apt install -y libxml2-utils
sudo apt install -y pdsh

# #解压
echo "hadoop-$HADOOP_VERSION　伪分布式正在自动安装部署..."
tar -zxf hadoop-$HADOOP_VERSION.tar.gz
echo "hadoop-$HADOOP_VERSION　>>解压完成"
sudo mv  hadoop-$HADOOP_VERSION /opt/
mkdir $HADOOP_VERSION/whaleai
#配置hadoop3的配置文件
echo "export JAVA_HOME=$JAVA_HOME">>$HADOOP_HOME/etc/hadoop/hadoop-env.sh
create_config --file core-site.xml
put_config --file core-site.xml --property fs.defaultFS --value "hdfs://localhost:9000"
put_config --file core-site.xml --property hadoop.tmp.dir --value "HADOOP_VERSION/whaleai"

create_config --file hdfs-site.xml
put_config --file hdfs-site.xml --property dfs.replication --value "1"

create_config --file mapred-site.xml
put_config --file mapred-site.xml --property mapreduce.framework.name --value "yarn"

create_config --file yarn-site.xml
put_config --file yarn-site.xml --property yarn.nodemanager.aux-services --value "mapreduce_shuffle"
echo "hadoop-$HADOOP_VERSION　>>xml文件配置完成"
#创建变量文件
echo "${Author} ${HadoopEnv}">hadoop-$HADOOP_VERSION.sh
sudo mv  hadoop-$HADOOP_VERSION.sh /etc/profile.d
sudo mv  core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml -t $HADOOP_HOME/etc/hadoop
source /etc/profile
echo "hadoop-$HADOOP_VERSION　>>变量配置完成 "
$HADOOP_HOME/bin/hdfs namenode -format
echoecho "hadoop-$HADOOP_VERSION >>format完成 "
echo "hadoop-$HADOOP_VERSION　>>服务启动中..."
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
echo "hadoop-$HADOOP_VERSION　启动完成 "
jps
echo "hadoop-$HADOOP_VERSION　开启成功...服务已经启动..."
echo "浏览器打开以下网址查看"
echo "
>> NameNode - http://localhost:50070/"
echo "
>> ResourceManager - http://localhost:8088/
"

#
}

remove()
{
echo "hadoop-$HADOOP_VERSION　正在卸载..."
$HADOOP_HOME/sbin/stop-all.sh
sudo rm -rf $HADOOP_HOME
sudo rm -rf /tmp/hadoop*

sudo rm -rf /etc/profile.d/hadoop-$HADOOP_VERSION.sh
source /etc/profile
echo "hadoop-$HADOOP_VERSION　卸载完成

使用　. whaleai-haoop2 -i　进行安装
"
}

help()
{
cat << EOF
已支持版本　hadoop-2.7.3 hadoop-2.8.0
This script installs Hadoop 2 with basic data, log, and pid directories.

USAGE:  whaleai-hadoop2.sh [options]
OPTIONS:
   -i, --install　        伪分布式安装部署hadoop3

   -r, --remove           卸载hadoop3

   -h, --help             Show this message.

EXAMPLES:
  如何安装？hadoop2 install:

		 . whaleai-hadoop2.sh -i　

		 Or . install-hadoop2.sh --install

  如何卸载？hadoop2 remove:

		 . whaleai-hadoop2.sh -r

		 Or . install-hadoop2.sh --remove
EOF
}

while true;
do
  case "$1" in

    -i|--install)
      install
			break
      ;;
    -r|--remove)
      remove
			break
      ;;
    *)
			help
      break
      ;;
  esac
done
