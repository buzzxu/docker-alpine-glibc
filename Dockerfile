FROM frolvlad/alpine-glibc

LABEL MAINTAINER buzzxu <downloadxu@163.com>

RUN apk update && \ 
    apk upgrade && \ 
    apk add --update ttf-dejavu fontconfig tzdata && \ 
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

ENV LANG='C.UTF-8' \
    LC_ALL='C.UTF-8'