FROM golang:tip-bullseye

WORKDIR /app

RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY . .
RUN go mod download

RUN go build -o main ./cmd
RUN chmod +x main
RUN chmod +x setup_postgres.sh
CMD ./setup_postgres.sh && ./main