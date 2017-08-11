FROM ubuntu:xenial
MAINTAINER sharkseven <shark@dodora.com>

ADD etc /etc
ADD supervisord.conf /etc/supervisor/conf.d/nginx.conf
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y apt-transport-https ca-certificates curl net-tools sudo vim openssh-server build-essential wget git inotify-tools nano pwgen supervisor && \
	apt-get clean && \
	echo -n > /var/lib/apt/extended_states && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


# ssh密码登录
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# 设置初始密码
RUN echo 'root:sharkseven' | chpasswd

# 创建工作目录
RUN mkdir /root/workspace

# 创建配置 数据目录
RUN mkdir /config /data

# 添加core用户
RUN useradd -u 500 core

# 修改时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ADD config /config

RUN wget -O /config/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64
RUN chmod +x /config/dumb-init /config/main


# nginx

RUN curl https://nginx.org/keys/nginx_signing.key | apt-key add - && \
	echo "deb http://nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	apt-get install -y nginx && \
	apt-get clean && \
	echo -n > /var/lib/apt/extended_states && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN rm -rf /etc/nginx/*.d /etc/nginx/sites-* && \
	mkdir -p /etc/nginx/addon.d /etc/nginx/config.d /etc/nginx/host.d /etc/nginx/nginx.d

# mariadb

ENV DBUSER=docker
ENV DBPASS=docker

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CBCB082A1BB943DB && \
	echo "deb http://ftp.osuosl.org/pub/mariadb/repo/10.1/debian/ jessie main" > /etc/apt/sources.list.d/mariadb.list && \
	apt-get update && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	echo -n > /var/lib/apt/extended_states && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
RUN sed -i -e "s/^bind-address/#bind-address/" /etc/mysql/my.cnf && \
	sed -i -e "s/^datadir.*=.*/datadir = \/data/" /etc/mysql/my.cnf && \
	sed -i -e "s/^user.*=.*/user = core/" /etc/mysql/my.cnf && \
	sed -i -e "s/\/var\/log\/mysql/\/data\/log/" /etc/mysql/my.cnf && \
	chown -R core:adm /var/log/mysql.err && \
	chown -R core:adm /var/log/mysql.log && \
	chown -R core:adm /var/log/mysql && \
	chown -R core:root /run/mysqld

# nvm

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
    && nvm install v4.6.0
RUN bash -c '. /root/.nvm/nvm.sh && cd /root/.gospely/.socket && nvm use v4.6.0 && npm install -g cnpm --registry=https://registry.npm.taobao.org && cnpm install'


# redis

EXPOSE 22 80 3306 7936
ENTRYPOINT /config/main
