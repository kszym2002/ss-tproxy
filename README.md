# SS/SSR 透明代理脚本
使用此脚本前，请确保你已正确安装以下组件：
- [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)：[安装方式](https://www.zfl9.com/ss-redir.html#shadowsocks-libev)
- [shadowsocksr-libev](https://github.com/shadowsocksr-backup/shadowsocksr-libev)：[安装方式](https://www.zfl9.com/ss-redir.html#shadowsocksr-libev)
- [chinadns](https://github.com/shadowsocks/ChinaDNS)：[安装方式](https://www.zfl9.com/ss-redir.html#chinadns)
- [dnsforwarder](https://github.com/holmium/dnsforwarder)：[安装方式](https://www.zfl9.com/ss-redir.html#dnsforwarder)
- ipset：[安装方式](https://www.zfl9.com/ss-redir.html#ipset)
- haveged：[安装方式](https://www.zfl9.com/ss-redir.html#haveged)，或者 rng-utils/rng-tools
- 注：`shadowsocks-libev`用于 ss 透明代理，`shadowsocksr-libev`用于 ssr 透明代理，可自由选择，二者可同时安装

## ss-tproxy - 安装
**获取一键脚本**
1. `git clone https://github.com/zfl9/ss-tproxy.git`
2. `cd ss-tproxy/`
3. `cp -af ss-tproxy /usr/local/bin/`
4. `cp -af ss-tproxy.conf /etc/`

**修改配置文件**
1. 只需修改`服务器信息`，其它的保持默认即可；如果需要修改其它参数，文件中有详细注释可参考
2. `vim /etc/ss-tproxy.conf`，修改：服务器地址、服务器端口、加密方式、账户密码、是否使用 SSR、SSR 相关参数
3. 如果你觉得使用 vim 修改略麻烦，也可以使用这里提供的 `ss-switch` 一键切换脚本（注意它会自动重启 ss-tproxy）
4. 如果你使用此脚本可以正常 FQ，建议关闭 ss-redir、ss-tunnel、chinadns、dnsforwarder 的日志功能，具体可参考注释

**内网主机的 DNS 必须指向网关，即 dnsforwarder，否则无法正常解析 DNS**。详见 [部署环境说明](https://www.zfl9.com/ss-redir.html#%E9%83%A8%E7%BD%B2%E7%8E%AF%E5%A2%83%E8%AF%B4%E6%98%8E)

**配置开机自启**<br>
如果要配置开机自启，且 ss-tproxy.conf 中的 `server_addr` 为域名形式，**强烈建议**将其加入 `/etc/hosts` 文件中！特别是将 ss-tproxy 部署在路由上的，因为是 PPPOE 拨号方式，ss-tproxy 很有可能在 PPPOE 拨号未完成的情况下先启动，导致无法解析 `server_addr` 中的域名，进而导致 ss-redir/ss-tunnel/ssr-redir/ssr-tunnel 启动失败、iptables 规则配置失败等一系列问题。虽然可以通过 chkconfig 的优先级、systemd 的 Requires、After 字段来配置它们的启动顺序以及依赖关系，但是仍不可避免此问题（本人树莓派 3B 实测，踩了多次坑总结出来的经验）。

`/etc/hosts` 的语法非常简单，比如 server_addr 的域名为 ss1.server.org，IP 地址为 1.2.3.4，只需将 `1.2.3.4 ss1.server.org` 行加入该文件尾部，文件中可以使用 `#` 进行注释，和 shell 脚本的注释语法类似。

如果你使用的是 ArchLinux 发行版，也可以使用 netctl 的 hooks 钩子方式（建议），当指定网卡启动后会自动运行预先设置的 hooks 脚本（启用 ss-tproxy），非常方便。有兴趣的可以看看 ArchLinux 的[官方 wiki](https://wiki.archlinux.org/index.php/Netctl#Using_hooks)。

- RHEL/CentOS 6.x 及其它使用 sysvinit 的发行版
 1. 使用`/etc/rc.d/rc.local`文件
 2. `echo "/usr/local/bin/ss-tproxy start" >> /etc/rc.d/rc.local`
- RHEL/CentOS 7.x 及其它使用 systemd 的发行版
 1. 安装 ss-tproxy.service 服务
 2. `cp -af ss-tproxy.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable ss-tproxy`

## ss-tproxy - 参数
1. `ss-tproxy start`，运行 ss-tproxy；
2. `ss-tproxy status`，ss-tproxy 运行状态；
3. `ss-tproxy stop`，停止 ss-tproxy；
4. `ss-tproxy restart`，重启 ss-tproxy；
5. `ss-tproxy current_ip`，获取当前 IP 地址信息；
6. `ss-tproxy flush_dnsche`，清空 dnsforwarder dns缓存；
7. `ss-tproxy update_chnip`，更新 ipset-chnip 大陆地址段。

## ss-tproxy - 关于
- author：Otokaze
- url：https://www.zfl9.com
- ref: https://www.zfl9.com/ss-redir.html
- date: 2018-03-21 10:45:08 CST
