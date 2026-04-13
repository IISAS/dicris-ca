#/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

. ./envvars.sh

CA_HOME="${SCRIPT_DIR}/volumes/ca"
CA_CERTS="${SCRIPT_DIR}/volumes/certs"

CN="${CA_COMMON_NAME:-'CA'}"
DAYS=${CA_CERT_DAYS:-3650}

echo "🛈  CN=${CN}"
echo "🛈  DAYS=${DAYS}"

./ca.sh openssl req -x509 -newkey rsa:4096 -sha256 -nodes -out cacert.pem -outform PEM -subj "/CN=${CN}" -days ${DAYS}
