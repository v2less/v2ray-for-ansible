# V2Ray for Ansible

本 Playbook 将利用 Ansible 在服务器上自动化部署 V2Ray。目前，仅在 Debian
GNU/Linux 10 上测试通过。Debian GNU/Linux 更低版本或 Ubuntu
系列大概也没有问题，其它 Linux
发行版本有待进一步测试。使用本仓库请自行承担风险。

根据 V2Ray 大多数用户推荐，本 Playbook 采用 [WebSocket+TLS+Web](https://toutyrater.github.io/advanced/wss_and_web.html) 部署方式。换句话说，它将在服务器上安装下列软件：

* Certbot：用于请求 SSL 证书
* NGINX：用于提供 Web 服务
* V2Ray

## 使用要求

为了正常使用 V2Ray，应当满足以下要求：

* 一台云主机，如[搬瓦工](https://bwh88.net/aff.php?aff=43530&pid=57)优惠码：`BWH3HYATVBJW`、 [Vultr](https://www.vultr.com/?ref=7123175)、[Linode](https://www.linode.com/?r=28bf53dae49d2c55dd671136769c0b7526db5891)、[DO](https://m.do.co/c/7758457f61ad) 等等。
* 一个域名且已经绑定到云主机。
* Ansible，可参考[官方文档](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-node)安装。

### 使用方法

`git submodule update --init roles/acme`

*编辑配置文件config"

- 服务端
`bash setup`
- 客户端
`bash v2ray_client`
