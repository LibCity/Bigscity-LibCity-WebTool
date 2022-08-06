# Deployment Manual

The following environment is required for deployment

- OS: Ubuntu 20.04.4 LTS
- Nginx: nginx 1.18.0 (Ubuntu)
- Database: MySQL version 8.0
- Anaconda: conda 4.10.3
- Python: Python 3.8.1

This project relies on LibCity to run, so you need to install and configure the LibCity environment beforehand. It is recommended that the LibCity dependencies and the project dependencies are managed in the same virtual environment.

LibCity installation documentation: https://bigscity-libcity-docs.readthedocs.io/zh_CN/latest/get_started/install.html

It is recommended to use Conda to create a virtual environment and configure it for use.

## 1 Backend Deployment

1. switch the virtual environment to run LibCity

   ```shell
   conda activate admin
   ```

2. Upload the backend code to the server, enter the project directory, and install the dependencies

   ```shell
   pip install -r requirements.txt
   ```

3. Install Uwsgi

   ```shell
   pip install uwsgi
   ```

4. Create a uwsgi working directory in the same level as the project folder

   ```shell
   mkdir uwsgi

5. Create the uwsgi.ini configuration file

   ```shell
   vim uwsgi.ini
   ```

   Write the following; chdir, virtualenv, pidfile and daemonize need to be configured according to the actual situation.

   ```shell
   [uwsgi]
   chdir = /home/houge/Bigscity-LibCity-WebTool/smartcityms_backend
   virtualenv = /home/houge/anaconda3/envs/admin
   module = backend.wsgi:application
   master = True
   processes = 1
   harakiri = 60
   max-requests = 5000
   
   socket = 127.0.0.1:8090
   plugin = python3
   
   pidfile = /home/houge/Bigscity-LibCity-WebTool/uwsgi/master.pid
   daemonize = /home/houge/Bigscity-LibCity-WebTool/uwsgi/backend.log
   vacuum = True
   enable-threads = true
   ```

6. Configuration of the project configuration file

   ```shell
   vim smartcityms_backend/backend/settings.py
   ```

   The items that need to be modified are.

   ```shell
   # Mailing-related
   # Email sender's email address
   SENDER_ADDRESS = ''
   # Mailbox authorization code
   SENDER_AUTHORIZATION_CODE = ''
   # SMTP server address e.g.: smtp.163.com
   SMTP_SERVER_ADDRESS = ''
   # SMTP server port
   SMTP_SERVER_PORT = 0
   
   # Suggested change to server IP = ?
   ALLOWED_HOSTS = ['?']
   
   # Database Note to modify the HOST USER PASSWORD of the database
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.mysql',
           'NAME': 'django', # the specified database name
           'USER': 'root', # username of the database login
           'PASSWORD': '123456', # the password to login to the database
           'HOST': '192.168.3.1',
           'PORT': '3366',
       }
   }
   
   # Cross-domain settings Here the request address of the front-end is configured to be the IP and port of the front-end project
   CORS_ORIGIN_WHITELIST = (
       'http://? :8000',
   )
   
   # libcity library program related
   # libcity program directory
   LIBCITY_PATH = '/home/houge/Bigscity-LibCity-WebTool/Bigscity-LibCity'
   # Activate libcity library virtual environment command Configured to None means it is the current environment (virtual environment when starting uwsgi)
   ACTIVE_VENV = None
   
   # Sample files related to dataset sample files and parameter configuration sample files, respectively
   DATASET_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/T_DRIVE_SMALL.zip'
   TASK_PARAM_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/config.json'
   
   # The front-end project path is configured as the path to store the front-end packaged project
   ADMIN_FRONT_HTML_PATH = "/home/houge/Bigscity-LibCity-WebTool/smartcityms_front/dist/"
   ```

7. Import the basic data table

   Login to the mysql database, create a database named django, and import the `django.sql` input.

   The command is as follows.

   ```mysql
   create database django;
   use django;
   source django.sql;
   ```

## 2 Front-end Deployment

Front-end projects can be compiled and packaged by themselves and then deployed, or you can directly use packaged deployment packages, if you directly use packaged deployment packages, you can directly see the content of 2.2.

### 2.1 Project compilation and packaging

1. required environment

   - node: v16.5.0
   - yarn: 1.22.17

2. node installation

   Download address: https://nodejs.org/download/release/v16.5.0/

   Download file: node-v16.5.0-linux-x64.tar.gz

   Unpack and configure the environment variables: 

   ```shell
   # Unpack
   tar -zxvf node-v16.5.0-linux-x64.tar.gz
   # Configure environment variables
   cd /etc/profile.d
   vim my_env.sh
   # Write the following NODE_HOME to be configured as your unpacking path
   export NODE_HOME=/home/houge/node-v16.5.0
   export PATH=$PATH:$NODE_HOME/bin
   # Save and make the environment variables take effect
   source /etc/profile
   # Verify that
   node -v
   ```

3. yarn installation

   ```shell
   npm install --global yarn
   # verify
   yarn -v
   ```

4. enter the front-end project code directory

   ```shell
   # Install the dependencies
   yarn
   # Build the package
   yarn build:prod
   ```

   The package will create an extra dist folder in the project code directory, which is the deployment package

### 2.2 Front-end project deployment

It is recommended to put the packaged dist deployment package in the same level as the back-end project to make it easier to find and manage the project.

1. Configuring Nginx

   Go to the Nginx site configuration directory and create a site configuration file

   ```shell
   cd /etc/nginx/sites-enabled
   # Create the site configuration file
   vim mysite.conf
   ```

   Write the following, the only place you need to change is the root configuration under the server of the libcity management platform, which needs to be changed to the dist folder path of the deployment package of the front-end project.

   ```shell
       server {
           listen 8080;
           server_name 127.0.0.1;
           #charset koi8-r;
           #access_log logs/host.access.log main;
           location / {
                   include /etc/nginx/uwsgi_params;
                   uwsgi_pass 127.0.0.1:8090;
                   # root html;
                   # index index.html index.htm;
           }
       }
   
       # libcity 
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
   		# The dist path of the deployment package that needs to be modified for the front-end project
           root /home/houge/Bigscity-LibCity-WebTool/smartcityms_front/dist;
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

2. Go to the dist directory, you need to change the backend request address.

   ```shell
   cd /home/houge/Bigscity-LibCity-WebTool/ai-admin-front/dist
   vim static/serverconfig.js
   # Just change the IP to the server IP
   window.global_url = {
     base_url: 'http://? :8080/api'
   }
   ```

3. Nginx restart authentication

   ```shell
   sudo nginx -s reload
   ```

## 3 Start Verification

1. go to the uwsgi directory and start the project

   ```shell
   uwsgi uwsgi.ini
   ```

2. Visit the page for validation: http://ip:8000

3. administrator user

   Account: admin

   Password: 123456