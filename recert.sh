#!/bin/bash
email_addr="waytoarcher@gmail.com"
domain_name=${1:-abc.abc.com}
acme.sh --register-account -m "${email_addr}"
acme.sh --issue -d "${domain_name}" --standalone -k ec-256 --force
sleep 2
acme.sh --installcert -d "${domain_name}" --fullchainpath /data/"${domain_name}".crt --keypath /data/"${domain_name}".key --ecc --force
