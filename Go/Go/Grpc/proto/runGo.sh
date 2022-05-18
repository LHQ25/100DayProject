#!/bin/sh

# -I: 输入文件位置 .:当前目录、helloworld.proto: 目标文件、--go_out: 输出文件位置
protoc -I . helloworld.proto --go_out=.

# 生成grpc文件
protoc -I . helloworld.proto --go-grpc_out=.