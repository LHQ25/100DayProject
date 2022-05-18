package main

import (
	proto2 "Go/Grpc/proto"
	"context"
	"golang.org/x/net/trace"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/grpclog"
	"google.golang.org/grpc/metadata"
	"net"
	"net/http"

	//"protoc-gen-openapiv2/options/annotations.proto";
	"google.golang.org/grpc"
	//_ "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway"
	//_ "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2"
	//_ "google.golang.org/grpc/cmd/protoc-gen-go-grpc"
	//_ "google.golang.org/protobuf/cmd/protoc-gen-go"
)

type Hello struct {
	proto2.UnimplementedHellowServer
}

func (*Hello) SaySomething(ctx context.Context, req *proto2.HelloReq) (*proto2.HelloRes, error) {
	// 解析metada中的信息并验证
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, grpc.Errorf(codes.Unauthenticated, "Token verif is failed")
	}

	var (
		appid  string
		appkey string
	)

	if val, ok := md["appid"]; ok {
		appid = val[0]
	}

	if val, ok := md["appkey"]; ok {
		appkey = val[0]
	}

	if appid != "101010" || appkey != "i am key" {
		return nil, grpc.Errorf(codes.Unauthenticated, "Token认证信息无效: appid=%s, appkey=%s", appid, appkey)
	}

	resp := new(proto2.HelloRes)
	resp.Message = "12345678"

	return resp, nil
}

const (
	// Address gRPC服务地址
	address = "127.0.0.1:8090"

	// OpenTLS 是否开启TLS认证
	OpenTLS = true
)

func main() {

	// 初始化网络监听（TCP）
	listen, err := net.Listen("tcp", address)
	if err != nil {
		grpclog.Fatalf("failed to listen: %v", err)
	}

	// 创建service

	var opts []grpc.ServerOption
	var s *grpc.Server
	// 注册interceptor
	//opts = append(opts, grpc.UnaryInterceptor(interceptor))
	if OpenTLS {
		// 创建service TLS验证
		cred := tls()
		s = grpc.NewServer(grpc.Creds(cred))
	} else {
		s = grpc.NewServer(opts...)
	}

	// 注册Hello服务
	proto2.RegisterHellowServer(s, &Hello{})

	// 开启trace
	go startTrace()

	grpclog.Println("Listen on " + address)

	// 开始监听网络
	seer := s.Serve(listen)
	if seer != nil {
		panic("service failed" + seer.Error())
	}
}

/*TLS 认证*/
func tls() credentials.TransportCredentials {

	credent, err := credentials.NewServerTLSFromFile("gateway/cer/server.pem", "gateway/cer/server.key")
	if err != nil {
		panic("TLS File failed" + err.Error())
	}
	return credent
}

// auth 验证Token
func auth(ctx context.Context) error {
	md, ok := metadata.FromIncomingContext(ctx) //.FromContext(ctx)
	if !ok {
		return grpc.Errorf(codes.Unauthenticated, "无Token认证信息")
	}

	var (
		appid  string
		appkey string
	)

	if val, ok := md["appid"]; ok {
		appid = val[0]
	}

	if val, ok := md["appkey"]; ok {
		appkey = val[0]
	}

	if appid != "101010" || appkey != "i am key" {
		return grpc.Errorf(codes.Unauthenticated, "Token认证信息无效: appid=%s, appkey=%s", appid, appkey)
	}

	return nil
}

// interceptor 拦截器
func interceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	err := auth(ctx)
	if err != nil {
		return nil, err
	}
	// 继续处理请求
	return handler(ctx, req)
}

/*grpc内置了客户端和服务端的请求追踪，基于golang.org/x/net/trace包实现，默认是开启状态，可以查看事件和请求日志*/
func startTrace() {
	trace.AuthRequest = func(req *http.Request) (any, sensitive bool) {
		return true, true
	}
	// 开启一个http服务监听50051端口，用来查看grpc请求的trace信息
	// 访问：localhost:50051/debug/events
	go http.ListenAndServe(":50051", nil)
	grpclog.Println("Trace listen on 50051")
}
