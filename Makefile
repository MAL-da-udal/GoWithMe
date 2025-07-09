PROTOBUF=api/protobuf

.PHONY: backend_dependencies
backend_dependencies:
	cd backend/auth && go mod tidy
	cd backend/profile && go mod tidy
	cd backend/interests && go mod tidy
	cd backend/gateway && go mod tidy

generate_protobuf: api/protobuf/services.proto
	protoc --go_out=backend/auth/ --go-grpc_out=backend/auth/ \
	--go-grpc_opt=paths=source_relative $(PROTOBUF)/services.proto

	protoc --go_out=backend/profile/ --go-grpc_out=backend/profile/ \
	--go-grpc_opt=paths=source_relative $(PROTOBUF)/services.proto

	protoc --go_out=backend/interests/ --go-grpc_out=backend/interests/ \
    	--go-grpc_opt=paths=source_relative $(PROTOBUF)/services.proto

	protoc --go_out=backend/gateway/ --go-grpc_out=backend/gateway/ \
    	--go-grpc_opt=paths=source_relative $(PROTOBUF)/services.proto