FROM google/dart


WORKDIR /app

ADD . /app

RUN pub get

EXPOSE 8080

ENTRYPOINT ["dart", "/app/example/app.dart"]

