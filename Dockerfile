FROM debian:latest

RUN apt-get update && apt-get install -y stress \
        --no-install-recommends && rm -r /var/lib/apt/lists/*

CMD ["stress", "--verbose", "--vm", "1", "--vm-bytes", "256M"]
