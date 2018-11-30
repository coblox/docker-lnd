#!/usr/bin/env bash
set -e

cmd="$@"

echo "BACKEND_RPC_USER: $BACKEND_RPC_USER"
echo "BACKEND_RPC_PASS: $BACKEND_RPC_PASS"
echo "BACKEND_RPC_HOST: $BACKEND_RPC_HOST"

function check_backend () {
    curl -s --user $BACKEND_RPC_USER:$BACKEND_RPC_PASS --data-binary \
          "{\"jsonrpc\": \"1.0\",\"id\":\"curltest\",\"method\":\"getwalletinfo\", \"params\": [ ]}" -H 'content-type: text/plain;' "http://${BACKEND_RPC_HOST}" \
          | grep '.error.:null' >/dev/null
}

until check_backend; do
  >&2 echo "Backend is unavailable - sleeping"
  sleep 1
done

>&2 echo "Backend is up - executing command"
exec $cmd


