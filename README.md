# ss-redir 透明代理
## 脚本依赖
- iproute2 工具
- iptables + [geoip](https://linux.cn/article-6885-1.html#geoip) + [ipset](https://www.zfl9.com/ss-redir.html#ipset) 工具
- curl 用于获取大陆地址段列表
- [haveged](https://www.zfl9.com/ss-redir.html#haveged) 解决系统熵过低的问题（可选，但建议）
- [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)（[安装参考](https://www.zfl9.com/ss-redir.html#shadowsocks-libev)）或 [shadowsocksr-libev](https://github.com/shadowsocksr-backup/shadowsocksr-libev)（[安装参考](https://www.zfl9.com/ss-redir.html#shadowsocksr-libev)）
- [chinadns](https://github.com/shadowsocks/ChinaDNS)，自带 `x86`、`x64`、`arm`、`arm64` 可执行文件（[安装参考](https://www.zfl9.com/ss-redir.html#chinadns)）
- [dnsforwarder](https://github.com/holmium/dnsforwarder)，自带 `x86`、`x64`、`arm`、`arm64` 可执行文件（[安装参考](https://www.zfl9.com/ss-redir.html#dnsforwarder)）

## 脚本用法
**获取**
- `git clone https://github.com/zfl9/ss-tproxy.git`

**安装**
- `cd ss-tproxy/`
- `cp -af ss-tproxy /usr/local/bin/`
- `cp -af ss-switch /usr/local/bin/`
- `cp -af chinadns/chinadns.ARCH /usr/local/bin/chinadns`（注意 ARCH）
- `cp -af dnsforwarder/dnsforwarder.ARCH /usr/local/bin/dnsforwarder`（注意 ARCH）
- `chmod 0755 /usr/local/bin/ss-tproxy`
- `chmod 0755 /usr/local/bin/ss-switch`
- `chmod 0755 /usr/local/bin/chinadns`
- `chmod 0755 /usr/local/bin/dnsforwarder`
- `mkdir -p /etc/tproxy/`
- `cp -af ss-tproxy.conf /etc/tproxy/`
- `cp -af ipset/chnroute.ipset /etc/tproxy/`
- `cp -af chinadns/chnroute.txt /etc/tproxy/`
- `cp -af dnsforwarder/dnsforwarder.conf /etc/tproxy/`

**配置**
- `vim /etc/tproxy/ss-tproxy.conf`
- 修改开头的 `ss/ssr 配置`，具体可参考文件注释
- 如果觉得使用 vim 修改略麻烦，也可以使用 `ss-switch` 切换脚本

**自启**（Systemd）
- `cp -af ss-tproxy.service /etc/systemd/system/`
- `systemctl daemon-reload`
- `systemctl enable ss-tproxy.service`

**自启**（SysVinit）
- `touch /etc/rc.d/rc.local`
- `chmod +x /etc/rc.d/rc.local`
- `echo "/usr/local/bin/ss-tproxy start" >> /etc/rc.d/rc.local`

> 配置 ss-tproxy 开机自启后容易出现一个问题，那就是必须再次运行 `ss-tproxy restart` 后才能正常代理（这之前查看运行状态，可能看不出任何问题，都是 running 状态），这是因为 ss-tproxy 启动过早了，且 server_addr 为 Hostname，且没有将 server_addr 中的 Hostname 加入 /etc/hosts 文件而导致的。因为 ss-tproxy 启动时，网络还没准备好，此时根本无法解析这个 Hostname。要避免这个问题，可以采取一个非常简单的方法，那就是将 Hostname 加入到 /etc/hosts 中，如 Hostname 为 node.proxy.net，对应的 IP 为 11.22.33.44，则只需执行 `echo "11.22.33.44 node.proxy.net" >> /etc/hosts`。不过得注意个问题，那就是假如这个 IP 变了，别忘了修改 /etc/hosts 文件哦。

**用法**
- `ss-tproxy help`：查看帮助
- `ss-tproxy start`：启动代理
- `ss-tproxy stop`：关闭代理
- `ss-tproxy restart`：重启代理
- `ss-tproxy status`：运行状态
- `ss-tproxy current_ip`：查看当前 IP（一般为本地 IP）
- `ss-tproxy flush_dnsche`：清空 dns 缓存（dnsforwarder）
- `ss-tproxy update_chnip`：更新大陆地址段列表（ipset、chinadns）

## 相关参考
- [holmium/dnsforwarder](https://github.com/holmium/dnsforwarder)
- [shadowsocks/ChinaDNS](https://github.com/shadowsocks/ChinaDNS)
- [shadowsocks/shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
- [shadowsocksr-backup/shadowsocksr-libev](https://github.com/shadowsocksr-backup/shadowsocksr-libev)
- 感谢以上开发者的无私贡献，让我们能够畅游互联网！
