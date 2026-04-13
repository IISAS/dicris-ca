#/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

. ./envvars.sh

CA_HOME="${SCRIPT_DIR}/volumes/ca"
CN="${CA_COMMON_NAME:-'CA'}"
DAYS="${CA_CERT_DAYS:-3650}"

echo "🛈  CN=${CN}"
echo "🛈  CA_CERT_DAYS=${CA_CERT_DAYS}"


cp -v ${CA_HOME}/cacert.pem ${CA_HOME}/cacert.pem-"$(date '+%Y%m%d-%s')"

./ca.sh openssl req -x509 \
  -key cakey.pem \
  -sha256 \
  -days ${DAYS} \
  -out cacert.pem \
  -subj "/CN=${CN}"
