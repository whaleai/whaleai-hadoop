# whaleai-hadoop  

## 提供hadoop自动化部署方案,WhaleAI专注人工智能/大数据
> 如果已有ssh-keygen，在询问是否覆盖已有的ssh-keygen时要选择```n```(no).

```. whaleai-hadoop2.sh -i　```

## Document
- Debian/ubuntu 16.04  17.04
- hadoop2 版本　hadoop-2.7.3 hadoop-2.8.0 稳定支持
- hadoop3 alpha 不稳定支持

### install
- 1.下载hadoop缩文件并放置在hadoop2目录中，修改hadoop2/whaleai-hadoop2中```HADOOP_VERSION```字段（默认2.7.3）;
- 2.安装，执行脚本 . hadoop2/whaleai-hadoop2.sh -i ;
- 3.验证，是否成功输入```jps``` 如下，即安装成功。
```
7984 SecondaryNameNode
8165 ResourceManager
8493 NodeManager
7581 NameNode
7757 DataNode
8862 Jps
```

USAGE:  ```. whaleai-hadoop2.sh [options]```

OPTIONS:
```
  -i, --install　        伪分布式安装部署hadoop3

  -r, --remove           卸载hadoop3

  -h, --help             Show this message.
```
## EXAMPLES:
- 如何安装？hadoop2 install:

```
. haodop2/whaleai-hadoop2.sh -i　

. haodop2/install-hadoop2.sh --install
```


- 如何卸载？hadoop2 remove:

```
. haodop2/whaleai-hadoop2.sh -r
. haodop2/install-hadoop2.sh --remove
```
