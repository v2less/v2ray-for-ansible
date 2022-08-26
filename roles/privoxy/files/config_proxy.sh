#!/bin/bash
## 让 privoxy 代理服务器使用 gfwlist 自动分流
#请修改为可用的socks代理
apt_install () {
    command -v "$1" || apt install -y "$1"
}
socks_proxy_ip="${1:-127.0.0.1}"
socks_proxy_port="1080"
apt_install privoxy
apt_install python3-pip
apt_install proxychains
sed -ri '/^socks.*$/d' /etc/proxychains.conf
sed -ri '/^http.*$/d' /etc/proxychains.conf
echo "socks5 $socks_proxy_ip $socks_proxy_port" | tee -a /etc/proxychains.conf

## 修改 privoxy 配置，默认使用 8118 本地端口
sed -ri '/^listen-address.*$/d' /etc/privoxy/config
grep -P '^listen-address\s+\d' /etc/privoxy/config || echo 'listen-address  0.0.0.0:8118' | tee -a /etc/privoxy/config
sed -ri "/$socks_proxy_ip:$socks_proxy_port/d" /etc/privoxy/config
sed -ri "/127.0.0.1:9050/i        forward-socks5t   \/             $socks_proxy_ip:$socks_proxy_port \."  /etc/privoxy/config
cd /tmp || exit
## 用户规则
cat  <<EOF | tee user.rule
.ajax.cloudflare.com
.amazonaws.com
.apkmirror.com
.bitbucket.com
.blogspot.tw
.cc
.cefamilie.com
.contentabc.com
.ecchi.iwara.tv
.frantech.ca
.github.io
.githubassets.com
.githubusercontent.com
.jimpop.org
.me
.phncdn.com
.pw
.python.org
.sosreader.com
.teamviewer.com
.tellapart.com
.webupd8.org
.yubico.com
EOF

## 生成 gfwlist.action 后刷新 privoxy
service privoxy force-reload
proxychains wget https://raw.githubusercontent.com/zfl9/gfwlist2privoxy/master/gfwlist2privoxy -O gfwlist2privoxy || exit 1
proxychains bash gfwlist2privoxy "$socks_proxy_ip":"$socks_proxy_port" --user-rule user.rule
cat <<EOF | tee -a gfwlist.action
{+forward-override{forward .}}
127.*.*.*
192.*.*.*
10.*.*.*
.uniontech.com
localhost
::1
EOF
[ -f gfwlist.action ] && mv -f gfwlist.action /etc/privoxy/
grep -q gfwlist.action /etc/privoxy/config || echo 'actionsfile gfwlist.action' | tee -a /etc/privoxy/config
service privoxy force-reload

client_ip=$(hostname -I | awk '{print $1}')
echo "The proxy: http://${client_ip}:8118"
