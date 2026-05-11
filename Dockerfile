FROM debian:bookworm-slim
RUN dpkg --add-architecture amd64 \
 && apt-get update \
 && apt-get install -y --no-install-recommends libc6:amd64 \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY server ./server
COPY static ./static
EXPOSE 8080
CMD ["./server"]
