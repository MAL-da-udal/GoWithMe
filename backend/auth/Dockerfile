FROM golang:tip-bullseye

WORKDIR /app

COPY go.mod ./
RUN go mod download
COPY . .

RUN go build -o main .
RUN chmod +x main
CMD ["./main"]