package main

import (
	pb "Go/gateway/http_proto"
	"context"
	"crypto/tls"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"golang.org/x/net/http2"
	"google.golang.org/grpc"
	"google.golang.org/grpc/grpclog"
	"io/ioutil"
	"net"
	"net/http"
	"strings"
)

type servie struct {
	pb.UnimplementedYourServiceServer
}

func (*servie) Echo(ctx context.Context, req *pb.StringMessage) (*pb.StringMessage, error) {

	println("request value:", req.Value)
	return &pb.StringMessage{
		Value: "1235",
	}, nil
}

func main() {

	// 这种方式必须实现TLS以支持http2.0

	endpoint := "127.0.0.1:8090"
	conn, err := net.Listen("tcp", endpoint)
	if err != nil {
		grpclog.Fatalf("TCP Listen err:%v\n", err)
	}

	// grpc tls server
	//err := grpc.NewServer()
	//	//credentials.NewServerTLSFromFile("../../keys/server.pem", "../../keys/server.key")
	//if err != nil {
	//	grpclog.Fatalf("Failed to create server TLS credentials %v", err)
	//}
	grpcServer := grpc.NewServer()
	pb.RegisterYourServiceServer(grpcServer, &servie{})

	// gw server
	ctx := context.Background()
	//dcreds, err := credentials.NewClientTLSFromFile("../../keys/server.pem", "server name")
	//if err != nil {
	//	grpclog.Fatalf("Failed to create client TLS credentials %v", err)
	//}
	dopts := []grpc.DialOption{grpc.WithInsecure()}
	gwmux := runtime.NewServeMux()
	if err = pb.RegisterYourServiceHandlerFromEndpoint(ctx, gwmux, endpoint, dopts); err != nil {
		grpclog.Fatalf("Failed to register gw server: %v\n", err)
	}

	// http服务
	mux := http.NewServeMux()
	mux.Handle("/", gwmux)
	srv := &http.Server{
		Addr:    endpoint,
		Handler: grpcHandlerFunc(grpcServer, mux),
	}
	//srv := &http.Server{
	//	Addr:      endpoint,
	//	Handler:   grpcHandlerFunc(grpcServer, mux),
	//	TLSConfig: getTLSConfig(),
	//}

	grpclog.Infof("gRPC and https listen on: %s\n", endpoint)

	if err = srv.Serve(conn); /*srv.Serve(tls.NewListener(conn, srv.TLSConfig))*/ err != nil {
		grpclog.Fatal("ListenAndServe: ", err)
	}

	return
}

func getTLSConfig() *tls.Config {
	cert, _ := ioutil.ReadFile("../../keys/server.pem")
	key, _ := ioutil.ReadFile("../../keys/server.key")
	var demoKeyPair *tls.Certificate
	pair, err := tls.X509KeyPair(cert, key)
	if err != nil {
		grpclog.Fatalf("TLS KeyPair err: %v\n", err)
	}
	demoKeyPair = &pair
	return &tls.Config{
		Certificates: []tls.Certificate{*demoKeyPair},
		NextProtos:   []string{http2.NextProtoTLS}, // HTTP2 TLS支持
	}
}

// grpcHandlerFunc returns an http.Handler that delegates to grpcServer on incoming gRPC
// connections or otherHandler otherwise. Copied from cockroachdb.
func grpcHandlerFunc(grpcServer *grpc.Server, otherHandler http.Handler) http.Handler {
	if otherHandler == nil {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			grpcServer.ServeHTTP(w, r)
		})
	}
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.ProtoMajor == 2 && strings.Contains(r.Header.Get("Content-Type"), "application/grpc") {
			grpcServer.ServeHTTP(w, r)
		} else {
			otherHandler.ServeHTTP(w, r)
		}
	})
}
