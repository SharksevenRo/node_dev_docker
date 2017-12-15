FROM mhart/alpine-node:6.12.2

MAINTAINER xiongmao 'xiongmao@huanleguang.com'

RUN apk --update add git curl vim bash

RUN npm install -g cnpm --registry=https://registry.npm.taobao.org

RUN cnpm install webpack -g

EXPOSE  80 443

CMD [ "node" ]