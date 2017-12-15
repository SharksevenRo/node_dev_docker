tee /usr/local/etc/nginx/servers/development.com.conf <<- 'EOF'
upstream nodejs__upstream_development {
        server 127.0.0.1:8085;
        keepalive 64;
}
server {
        listen 80;
        server_name www.development.com development.com;
        #access_log /var/log/nginx/moiveme.log;
        location / {
          proxy_set_header   X-Real-IP            $remote_addr;
          proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
          proxy_set_header   Host                   $http_host;
          proxy_set_header   X-NginX-Proxy    true;
          proxy_set_header   Connection "";
          proxy_http_version 1.1;
          proxy_pass         http://nodejs__upstream_development;
        }
}
EOF
# docker run --name mysql-wp -e MYSQL_ROOT_PASSWORD=projects -d mariadb:10.1 
docker run --name development-wordpress -p 8085:80 --link mysql-wp:mysql -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=projects  -d wordpress
# sudo echo '127.0.0.1 development.com' >> /etc/hosts && nginx -s reload


