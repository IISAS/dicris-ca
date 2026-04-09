# Dockerfile
FROM eclipse-temurin:17-jdk

# metadata
LABEL maintainer="you@example.com"
LABEL description="OpenJDK + OpenSSL image (includes keytool and openssl)"

# avoid interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# install openssl and common tools, clean apt cache to keep image small
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openssl \
      ca-certificates \
      procps \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /ca /certs

WORKDIR /ca
USER 1000
