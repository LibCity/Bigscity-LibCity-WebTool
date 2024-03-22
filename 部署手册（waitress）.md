# 部署手册

部署需要提供以下环境

- 操作系统：Ubuntu 20.04.4 LTS
- Nginx：nginx 1.18.0 (Ubuntu)
- 数据库：MySQL 8.0 版本及以上
- Anaconda：conda 4.10.3
- Python：Python 3.8.1

此项目依赖 LibCity 运行，所以事先还需要安装配置 LibCity 环境，推荐 LibCity 的依赖和此项目的依赖放同一个虚拟环境进行管理。

LibCity 安装文档：https://bigscity-libcity-docs.readthedocs.io/zh_CN/latest/get_started/install.html

推荐使用 Conda 创建虚拟环境并配置使用。

## 1 准备工作

**确认自己的IP**

**如果项目放到自己本机启动运行**，下面的 [机器IP]，都配置为 127.0.0.1

**如果项目放到了虚拟机或者服务器运行**，下面的 [机器IP]，要修改为你的虚拟机IP地址或者服务器IP地址

例如你的服务器IP地址为：10.21.1.97

假设下方配置文件内容是：`http://[机器IP]:8080` 就需要替换为 `http://10.21.1.97:8080`

## 2 后端部署

1. 将虚拟环境切换为运行 LibCity 的虚拟环境

   ```shell
   conda activate admin
   ```

2. 将后端代码上传至服务器，进入项目目录，并安装依赖

   ```shell
   pip install -r requirements.txt
   ```

3. 安装 waitress

   ```shell
   pip install waitress
   ```
   
4. 对项目配置文件进行配置

   ```shell
   vim smartcityms_backend/backend/settings.py
   ```

   **需要修改的项有：**

   1. 邮件相关配置
   2. 数据库配置
   3. 服务器安全配置，主要是配置服务器IP
   4. libcity 库程序相关配置

   ```python
   # ================== 邮件相关配置 ==================
   # 邮件发送相关
   # 邮件发送者邮箱地址
   SENDER_ADDRESS = ''
   # 邮箱授权码
   SENDER_AUTHORIZATION_CODE = ''
   # SMTP 服务器地址 例如：smtp.163.com
   SMTP_SERVER_ADDRESS = ''
   # SMTP 服务器端口
   SMTP_SERVER_PORT = 0
   
   # ================== 数据库配置 ==================
   # 数据库 注意修改数据库的 USER PASSWORD HOST PORT 四项
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'django',
           'USER': 'root',  # 数据库登录的用户名
           'PASSWORD': '123456',  # 登录数据库的密码
           'HOST': '[机器IP]',
           'PORT': '3306',  # MySQL默认启动端口，如果没有特殊配置，用默认的3306即可
       }
   }
   
   # ================== 服务器安全配置 ==================
   # 下方的 ? 处应该配置 IP 地址
   # 场景一：本机启动部署，填写本机 IP 或者 127.0.0.1 均可
   # 场景二：服务器启动部署，填写服务器 IP，内网就填写服务器内网 IP，公网部署就填写公网 IP
   ALLOWED_HOSTS = ['[机器IP]']
   
   # 跨域设置 这里配置的是前端的请求地址 修改为前端项目的 IP 和端口
   CORS_ORIGIN_WHITELIST = (
       'http://[机器IP]:8000',
   )
   
   # ================== libcity 库程序相关配置 ==================
   # libcity 程序目录
   LIBCITY_PATH = '/home/houge/Bigscity-LibCity-WebTool/Bigscity-LibCity'
   # 激活 libcity 库虚拟环境命令 配置为 None 代表就是当前环境（启动 uwsgi 时的虚拟环境）
   ACTIVE_VENV = None
   
   # 样例文件相关 分别是 数据集样例文件 和 参数配置样例文件
   DATASET_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/T_DRIVE_SMALL.zip'
   TASK_PARAM_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/config.json'
   
   # 前端项目路径 配置为前端打包后项目的存储路径
   ADMIN_FRONT_HTML_PATH = "/home/houge/Bigscity-LibCity-WebTool/dist/"
   ```

7. 导入基本数据表

   验证 MySQL 是否启动

   ```shell
   # 终端输入
   sudo service mysql status
   # 出现以下字样代表 MySQL 已经正常启动
   SUCCESS! MySQL running (18650)
   # 没有启动的话，使用以下命令启动
   sudo service mysql start
   ```
   
   登录mysql数据库，创建名为django的数据库，将`django.sql`输入导入。
   
   命令如下：
   
   ```sql
   create database django;
   use django;
   source django.sql;
   ```

## 3 前端部署

前端项目可以自己编译打包再部署，也可以直接使用打包好的部署包，如果直接使用打包好的部署包，可以直接看 2.2 的内容。

### 3.1 项目编译打包

1. 所需环境

   - node：v16.5.0
   - yarn：1.22.17

2. node 安装

   下载地址：https://nodejs.org/download/release/v16.5.0/

   下载文件：node-v16.5.0-linux-x64.tar.gz

   解压并配置环境变量：

   ```shell
   # 解压
   tar -zxvf node-v16.5.0-linux-x64.tar.gz
   # 配置环境变量
   cd /etc/profile.d
   vim my_env.sh
   # 写入以下内容 NODE_HOME 要配置成你的解压路径
   export NODE_HOME=/home/houge/node-v16.5.0
   export PATH=$PATH:$NODE_HOME/bin
   # 保存后 使环境变量生效
   source /etc/profile
   # 验证
   node -v
   ```

3. yarn 安装

   ```shell
   npm install --global yarn
   # 验证
   yarn -v
   ```

4. 进入前端项目代码目录

   ```shell
   # 安装依赖
   npm install
   # 打包
   yarn build:prod
   ```

   打包后会在项目代码目录下多出一个 dist 文件夹，这就是部署包

### 3.2 前端项目部署

建议将打包好的 dist 部署包放入和后端项目同级的目录下，方便项目查找及管理。

0. 验证 Nginx 服务是否正常启动

   ```shell
   # 输入命令出现下列 nginx 进程代表 nginx 正常启动
   [root@localhost ~]# ps -ef | grep nginx
   nobody    8707 17593  0  2023 ?        00:04:59 nginx: worker process
   nobody    8708 17593  0  2023 ?        00:06:02 nginx: worker process
   root     17593     1  0  2023 ?        00:00:00 nginx: master process ./nginx
   root     30207 28291  0 14:42 pts/0    00:00:00 grep --color=auto nginx
   # 没有启动的话，使用以下命令启动
   sudo nginx
   # 或者用下面命令也可以启动
   sudo systemctl start nginx
   ```

​		或者访问 `http://[机器IP]/`，出现 `Welcome to nginx!`等内容，也代表 Nginx 已经正常启动

1. 配置 Nginx

   进入 Nginx 的站点配置目录，并创建站点配置文件

   ```shell
   cd /etc/nginx/sites-enabled
   # 创建站点配置文件
   vim mysite.conf
   ```

   写入以下内容，**需要修改的地方只有 libcity 管理平台的 server 下的 root 配置，修改为前端项目的部署包 dist 文件夹路径**。

   ```shell
       client_max_body_size 20000m;
       server {
           listen 8080;
           server_name 127.0.0.1;
           #charset koi8-r;
           #access_log logs/host.access.log main;
           location / {
                   # 配置 waitress 转发
                   proxy_set_header Host $host;
                   proxy_pass http://127.0.0.1:8090;
           }
       }
   
       # libcity 管理平台
       server {
           listen 8000;
           server_name 127.0.0.1;
           charset utf-8;
           proxy_buffer_size 8192k;
           proxy_buffers 32 8192k;
           proxy_busy_buffers_size 8192k;
           gzip on;
           gzip_buffers 32 4k;
           gzip_comp_level 6;
           gzip_min_length 200;
           gzip_types text/css text/xml application/javascript;
           gzip_vary on;
   
   
           location ~* \.(asp|aspx|php|jsp|cgi|7z)$ {
               return 404;
           }
           location ~* \.map$ {
               return 404;
           }
   		# [这里需要修改] 需要修改为前端项目的部署包 dist 路径
           root /home/houge/Bigscity-LibCity-WebTool/dist;
           index index.html;
   
           location ^~ / {
               add_header Access-Control-Allow-Origin '*';
               add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
               add_header Access-Control-Allow-Headers 'Authorization,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
   
               if ($request_method = 'OPTIONS') {
                   return 204;
               }
   
               try_files $uri $uri/ /index.html?/$request_uri;
           }
       }
   ```

2. 进入 dist 目录，需要修改后端请求地址

   此处服务器 IP 也分为两个场景：

   - 场景一：本机部署，填写本机 IP 或者 127.0.0.1 均可
   - 场景二：服务器部署，内网部署就填写服务器的内网 IP，公网部署就填写服务器的公网 IP

   ```shell
   cd /home/houge/Bigscity-LibCity-WebTool/dist
   vim static/serverconfig.js
   # 只需要把 IP 修改为服务器 IP 即可
   window.global_url = {
     Base_url: 'http://[机器IP]:8080/api'
   }
   ```

3. Nginx 重启

   ```shell
   sudo nginx -s reload
   ```

## 4 启动验证

1. 启动后端服务：进入项目目录，就是 `smartcityms_backend`文件夹下

   - 执行启动脚本：

     Windows：在终端执行`.\bin\start.bat`

     Linux：在终端执行`sh bin/start.sh`

   - 出现以下内容代表启动脚本已经正常执行

     ```shell
     Starting the application...
     Application started successfully.
     ```

   - 项目是否正常运行，还需要查看启动日志，执行命令：`cat waitress.log`

   - 出现以下内容，代表项目已经正常运行：

     ```shell
     2024-03-19 14:44:28.131 | INFO     | backend.settings:<module>:192 - base.py settings loading
     INFO:waitress:Serving on http://0.0.0.0:8090
     INFO:waitress:Serving on http://[::]:8090
     ```

2. 验证后端是否正常启动：访问 `http://[机器IP]:8080`，可以正常打开页面并且页面内容返回 Not Found，代表后端服务已经启动并且正常运行

3. 验证前端是否正常启动：访问 `http://[机器IP]:8000`，可以正常打开登录页面代表前端可以正常访问

4. 登录平台进行验证：

   管理员用户

   账号：admin

   密码：123456

5. 项目也提供了**服务停止脚本**，执行以下命令即可**停止服务**，进入到后端项目文件夹`smartcityms_backend`中：

   Windows：在终端执行`.\bin\stop.bat`

   Linux：在终端执行`sh bin/stop.sh`
