FROM alpine:latest

LABEL MAINTAINER buzzxu <downloadxu@163.com>

# ADD fonts/simsun.ttc /opt/simsun.ttc
# ADD fonts/simsunb.ttf /opt/simsunb.ttf

ENV LANG C.UTF-8
ENV TZ Asia/Shanghai

# Download and install glibc,zlib
RUN apk add --no-cache --virtual=.build-dependencies curl wget binutils && \
  GLIBC_VERSION="2.30-r0" && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  wget "https://www.archlinux.org/packages/core/x86_64/zlib/download" -O /tmp/libz.tar.xz && \
  mkdir -p /tmp/libz && \
  tar -xf /tmp/libz.tar.xz -C /tmp/libz && \
  mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib && \
  strip /usr/glibc-compat/lib/libz.so.* && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk add wqy-zenhei --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing --allow-untrusted && \
  apk del --purge .build-dependencies && \
  apk add --no-cache -U font-adobe-100dpi ttf-dejavu fontconfig tzdata && \ 
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  # mv /opt/simsun.ttc /usr/share/fonts && \
  # mv /opt/simsunb.ttf /usr/share/fonts && \
  fc-cache -f && \
  fc-list && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/* /tmp/* 

