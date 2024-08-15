FROM arm64v8/ubuntu:latest

# Install SQLite
RUN apt-get update && apt-get install -y sqlite3

# Copy all necessary files into the container
COPY . /data

# Set working directory
WORKDIR /data

# Make the initialization script executable
RUN chmod +x init_sqlite.sh

# Run the initialization script and then start the SQLite shell
ENTRYPOINT ["/data/init_sqlite.sh"]
