FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl git unzip zip nginx ca-certificates && \
    apt-get clean

RUN git ls-remote https://github.com/flutter/flutter.git || exit 1

RUN git clone --single-branch --branch stable --depth 1 https://github.com/flutter/flutter.git /flutter

ENV PATH="$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin"

RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web

COPY . /app
WORKDIR /app

RUN flutter pub get && flutter build web --release

RUN mkdir -p /usr/share/nginx/html && cp -r build/web/* /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 