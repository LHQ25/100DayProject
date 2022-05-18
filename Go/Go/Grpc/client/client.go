package main

import (
	proto2 "Go/Grpc/proto"
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/grpclog"
	"time"
)

const (
	// Address gRPC服务地址
	address = "127.0.0.1:8090"

	// OpenTLS 是否开启TLS认证
	OpenTLS = true
)

// customCredential 自定义认证
type customCredential struct{}

func (c *customCredential) RequireTransportSecurity() bool {
	return OpenTLS
}

func (*customCredential) GetRequestMetadata(context.Context, ...string) (map[string]string, error) {

	return map[string]string{
		"appid":  "101010",
		"appkey": "i am key",
	}, nil
}

func main() {

	// 创建一个网络连接
	var opts []grpc.DialOption

	// 指定客户端interceptor
	opts = append(opts, grpc.WithUnaryInterceptor(interceptor))

	// 使用自定义认证
	opts = append(opts, grpc.WithPerRPCCredentials(new(customCredential)))

	var conn *grpc.ClientConn
	var err error

	if OpenTLS {

		cred := tls()
		opts = append(opts, grpc.WithTransportCredentials(cred))
		// TLS 网络连接 记得把server name改成你写的服务器地址
		conn, err = grpc.Dial(address, opts...)
	} else {

		opts = append(opts, grpc.WithInsecure())
		conn, err = grpc.Dial(address, opts...)
	}

	if err != nil {
		panic("conn create failed")
	}

	defer conn.Close()

	// 初始化客户端
	client := proto2.NewHellowClient(conn)

	// 请求及返回数据
	res, err := client.SaySomething(context.Background(), &proto2.HelloReq{Name: "bobby"})
	if err != nil {
		panic("client request failed" + err.Error())
	}

	fmt.Println("返回数据" + res.Message)
}

func tls() credentials.TransportCredentials {

	credent, err := credentials.NewClientTLSFromFile("gateway/cer/client.pem", "dever")
	if err != nil {
		panic("TLS File failed" + err.Error())
	}
	return credent
}

// interceptor 客户端拦截器
func interceptor(ctx context.Context, method string, req, reply interface{}, cc *grpc.ClientConn, invoker grpc.UnaryInvoker, opts ...grpc.CallOption) error {
	start := time.Now()
	err := invoker(ctx, method, req, reply, cc, opts...)
	grpclog.Printf("method=%s req=%v rep=%v duration=%s error=%v\n", method, req, reply, time.Since(start), err)
	return err
}
