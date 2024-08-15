FROM arm64v8/ubuntu:latest

RUN apt-get update && apt-get install -y sqlite3

COPY . .

WORKDIR /data

ENTRYPOINT ["sqlite3", "/data/northwind_database.db"]
