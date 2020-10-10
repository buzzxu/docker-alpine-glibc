FROM alpine:latest

LABEL MAINTAINER buzzxu <downloadxu@163.com>

ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'

RUN ARCHLINUX_BASE_URL= "https://archive.archlinux.org/packages" && \
    ZLIB_VERSION="1.2.11-4" && \
    GCC_LIBS_VERSION="10.2.0-3" && \
    ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.32-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates binutils xz zstd && \
    cd /tmp && \
    mkdir /tmp/gcc && \
    wget "${ARCHLINUX_BASE_URL}/g/gcc-libs/gcc-libs-${GCC_LIBS_VERSION}-x86_64.pkg.tar.zst" -O gcc-libs.tar.zst && \
    zstd -d /tmp/gcc-libs.tar.zst --output-dir-flat /tmp && \
    tar -xf /tmp/gcc-libs.tar -C /tmp/gcc && \
    mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib && \
    strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* && \
    mkdir /tmp/zlib && \
    wget "${ARCHLINUX_BASE_URL}/z/zlib/zlib-1%3A${ZLIB_VERSION}-x86_64.pkg.tar.xz" -O zlib.pkg.tar.xz && \
    tar xvJf zlib.pkg.tar.xz -C /tmp/zlib && \
    mv /tmp/zlib/usr/lib/libz.so* /usr/glibc-compat/lib && \
    wget -q -O "/etc/apk/keys/sgerrand.rsa.pub" "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm -rf "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef -i C -f UTF-8 "$LANG" && \
    \
    apk del glibc-i18n && \
    \
    rm -rf "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
    apk add --no-cache -U font-adobe-100dpi ttf-dejavu fontconfig tzdata && \ 
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone  && \
    fc-cache -f && \
    fc-list && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* 
