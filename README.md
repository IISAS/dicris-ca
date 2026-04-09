# DICRIS Certificate Authority

A Docker-based Certificate Authority (CA) using OpenSSL. The CA runs in a container with persistent state mounted via volumes.

## Prerequisites

- Docker
- Bash

## Directory Structure

```
.
├── Dockerfile              # CA image (eclipse-temurin:17-jdk + OpenSSL)
├── openssl.cnf             # OpenSSL CA configuration
├── build.sh                # Build the CA Docker image
├── ca.sh                   # Run a command inside the CA container
├── ca-init.sh              # Initialize the CA (generate key + self-signed cert)
├── ca-clean.sh             # Reset CA state (removes certs, resets index/serial)
├── ca-reissue-cacert.sh    # Reissue the CA certificate using the existing key
├── envars.sh               # Load .env / .env-global environment files
└── volumes/
    ├── ca/                 # CA key, certificate, index, and serial files
    ├── certs/              # Issued certificates
    └── etc/ssl/            # SSL configuration mounted into the container
```

## Configuration

Create a `.env` file in this directory to override defaults. A `.env-global` file (if present) takes precedence over `.env`.

| Variable         | Default | Description                              |
|------------------|---------|------------------------------------------|
| `CA_IMAGE_NAME`  | —       | Docker image name (used by `ca.sh`)      |
| `CA_IMAGE_TAG`   | —       | Docker image tag (used by `ca.sh`)       |
| `CA_COMMON_NAME` | `CA`    | Common Name for the CA certificate       |
| `DAYS`           | `3650`  | Validity period in days (init: 3650, reissue: 365) |

## Usage

### 1. Build the Docker image

```bash
./build.sh
```

Builds the `dicris-ca:latest` image from the local `Dockerfile`.

### 2. Initialize the CA

```bash
./ca-init.sh [CN]
```

Generates a new RSA 4096-bit private key (`cakey.pem`) and a self-signed CA certificate (`cacert.pem`) valid for 3650 days (10 years). The CN defaults to `$CA_COMMON_NAME` or `CA`.

### 3. Reissue the CA certificate

```bash
./ca-reissue-cacert.sh [CN]
```

Reissues the CA certificate using the existing private key. The previous `cacert.pem` is backed up with a timestamp suffix before reissue. Validity defaults to 365 days.

### 4. Clean / reset CA state

```bash
./ca-clean.sh
```

Removes all `.pem` files from `volumes/ca/`, resets `index.txt` and `serial.txt` to their initial state, and clears `volumes/certs/`. Use this to start fresh.

### 5. Run arbitrary OpenSSL commands

```bash
./ca.sh openssl <args>
```

Runs any command inside the CA container with the volumes mounted:

| Host path         | Container path |
|-------------------|----------------|
| `volumes/etc/ssl` | `/etc/ssl`     |
| `volumes/ca`      | `/ca`          |
| `volumes/certs`   | `/certs`       |

## Typical Workflow

```bash
# One-time setup
./build.sh
./ca-init.sh "My Root CA"

# Issue a certificate (example using ca.sh directly)
./ca.sh openssl ca -config /etc/ssl/openssl.cnf -in /certs/server.csr -out /certs/server.pem

# Renew the CA cert without replacing the key
./ca-reissue-cacert.sh "My Root CA"

# Start over
./ca-clean.sh
./ca-init.sh "My Root CA"
```
