FROM golang:tip-bullseye

WORKDIR /app

COPY . .
RUN go mod download

RUN go build -o main ./cmd
RUN chmod +x main
CMD ["./main"]