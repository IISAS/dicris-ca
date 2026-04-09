#/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

. ./envars.sh

CA_COMMON_NAME=${CA_COMMON_NAME:-'CA'}
CN="${1:-$CA_COMMON_NAME}"
DAYS="${DAYS:-365}"

echo "🛈  CN=${CN}"
echo "🛈  DAYS=${DAYS}"


cp -v ${SCRIPT_DIR}/volumes/ca/cacert.pem ${SCRIPT_DIR}/volumes/ca/cacert.pem-"$(date '+%Y%m%d-%s')"

./ca.sh openssl req -x509 \
  -key cakey.pem \
  -sha256 \
  -days ${DAYS} \
  -out cacert.pem \
  -subj "/CN=${CN}"
