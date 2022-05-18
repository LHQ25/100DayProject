package main

import (
	"context"
	"fmt"

	pb "Go/gateway/http_proto"

	"google.golang.org/grpc"
)

func main() {

	conn, err := grpc.Dial("127.0.0.1:9099", grpc.WithInsecure())
	if err != nil {
		panic(err.Error())
	}

	c := pb.NewYourServiceClient(conn)

	res, err := c.Echo(context.Background(), &pb.StringMessage{
		Value: "89898",
	})
	if err != nil {
		panic("echo" + err.Error())
	}
	fmt.Println(res)
}
