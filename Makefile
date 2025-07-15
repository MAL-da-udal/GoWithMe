
.PHONY: all
all: backend_dependencies backend_docs

.PHONY: backend_dependencies
backend_dependencies:
	cd backend && go install github.com/swaggo/swag/cmd/swag@latest
	cd backend && go mod tidy

backend_docs:
	cd backend && swag init --generalInfo cmd/main.go
