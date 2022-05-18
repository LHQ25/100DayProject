package main

import (
	pb "Go/gateway/http_proto"
	"context"
	"google.golang.org/grpc"
	"net"
)

type servie struct {
	pb.UnimplementedYourServiceServer
}

func (*servie) Echo(context.Context, *pb.StringMessage) (*pb.StringMessage, error) {
	return &pb.StringMessage{Value: "1235"}, nil
}

func main() {

	listen, err := net.Listen("tcp", "127.0.0.1:8090")
	if err != nil {
		panic("listen failed")
	}

	s := grpc.NewServer()

	pb.RegisterYourServiceServer(s, &servie{})

	err = s.Serve(listen)
	if err != nil {
		panic("failed")
	}
}
