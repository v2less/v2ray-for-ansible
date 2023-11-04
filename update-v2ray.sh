#!/bin/bash
set -e
source config
if ping -c 3 "$server_ip"; then
    cat << EOF | tee inventory/selfhost
[selfhost]
myserver ansible_port="$server_ssh_port" ansible_host="$server_ip" ansible_python_interpreter=/usr/bin/python3
EOF
fi
echo INFO set up env
ansible-playbook -vvv playbooks/env.yml

echo INFO update acme and v2ray for server
ansible-playbook -e domain_name="$domain_name" -e email_addr="$email_addr" -e domain_name="$domain_name" -D --tags cert,update_v2ray playbooks/v2ray.yml

#cat << EOF | tee inventory/selfhost
#[selfhost]
#EOF
