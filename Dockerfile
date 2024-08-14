FROM arm64v8/ubuntu:latest

RUN apt-get update && apt-get install -y sqlite3

COPY data/northwind_database.db /data/northwind_database.db

WORKDIR /data

CMD ["sqlite3", "/data/northwind_database.db"]
