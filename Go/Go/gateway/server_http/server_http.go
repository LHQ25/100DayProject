package main

import (
	v1 "Go/gateway/http_proto"
	"context"
	"flag"
	"github.com/golang/glog"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	"google.golang.org/grpc"
	"net/http"
)

func run() error {
	// grpc service
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	endpoint := "127.0.0.1:9099"
	opts := []grpc.DialOption{grpc.WithInsecure()}
	mux := runtime.NewServeMux()

	err := v1.RegisterYourServiceHandlerFromEndpoint(context.Background(), mux, endpoint, opts)
	if err != nil {
		panic(err.Error())
	}

	return http.ListenAndServe(":8090", mux)
}

var (
	grpcServerEndpoint = flag.String("grpc_Server_Endpoint", "127.0.0.1:8090", "gRPC server endpoint")
)

func main() {

	flag.Parsed()
	defer glog.Flush()

	if err := run(); err != nil {
		glog.Fatal(err)
	}
}
