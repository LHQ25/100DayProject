#!/bin/sh

# Generate OpenAPI definitions using protoc-gen-openapiv2
protoc -I ../ helloService.proto --openapiv2_out ../api \
    --openapiv2_opt logtostderr=true