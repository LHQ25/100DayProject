#!/bin/sh

# 生成.csr 证书签名请求文件
$ openssl req -new -key server.key -out server.csr \
    -subj "/C=GB/L=China/O=lixd/CN=www.louhanqing.com" \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:*.louhanqing.com,DNS:*.refersmoon.com"))
#/usr/local/etc/openssl/openssl.cnf
# 签名生成.crt 证书文件
$ openssl x509 -req -days 3650 \
   -in server.csr -out server.crt \
   -CA ca.crt -CAkey ca.key -CAcreateserial \
   -extensions SAN \
   -extfile <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:*.louhanqing.com,DNS:*.refersmoon.com"))
