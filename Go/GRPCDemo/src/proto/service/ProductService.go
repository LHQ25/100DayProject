package service

import (
	"GRPCDemo/src/proto/service/RequestService"
	"context"
)

type ProductService struct {
	RequestService.UnimplementedProdServiceServer
}

func (ps *ProductService) GetProductStock(ctx context.Context, req *RequestService.ProductRequest) (*RequestService.ProductResponse, error)  {
	return &RequestService.ProductResponse{ProdStaock: req.ProdId}, nil
}
