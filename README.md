## ss-redir 透明代理/脚本
- 请先安装 [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)、[chinadns](https://github.com/shadowsocks/ChinaDNS)、[dnsforwarder](https://github.com/holmium/dnsforwarder)、ipset！
- 如果你不知道如何安装，请前往 [ss-redir透明代理 - 安装相关组件](https://www.zfl9.com/ss-redir.html#安装相关组件)。
- 并且，强烈建议先阅读 [ss-redir透明代理](https://www.zfl9.com/ss-redir.html)，不然，你会觉得一头雾水。

## ss-tproxy - 初始化
**获取一键脚本**
1. `git clone https://github.com/zfl9/ss-tproxy.git`
2. `cd ss-tproxy/`
3. `cp -af ss-tproxy /usr/local/bin/`
4. `cp -af ss-tproxy.conf /etc/`

**修改配置文件**
1. 只需修改`服务器信息`，其他的保持默认即可；如果需要修改其他参数，文件中有详细注释可参考。
2. `vim /etc/ss-tproxy.conf`，修改开头的"服务器信息"：服务器地址、服务器端口、加密方式、账户密码。
3. **服务器地址**可以为 IP，也可以为域名；如果是域名，务必将域名和 IP 的解析关系添加至`/etc/hosts`文件！
4. `ss-tproxy.conf`配置文件其实就是一个 shell 脚本，具体怎么玩，可以自由发挥。

**配置开机自启**
- RHEL/CentOS 6.x 及其它使用 sysvinit 的发行版
 1. 使用`/etc/rc.d/rc.local`文件
 2. `echo "/usr/local/bin/ss-tproxy start" >> /etc/rc.d/rc.local`
- RHEL/CentOS 7.x 及其它使用 systemd 的发行版
 1. 安装 ss-tproxy.service 服务
 2. `cp -af ss-tproxy.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable ss-tproxy`

**内网主机dns设置**
1. `ss-tproxy`脚本是在**网关/路由器**上运行的；启动后，默认占用 60080、60053、65353、53 端口；
2. 因此，内网其他主机的 dns 服务器必须指向 192.168.1.1（假设网关地址为 192.168.1.1）；
3. 如果使用 8.8.8.8 等国外 dns，查看 ss-redir 的 log 会看到`"ERROR: [udp] remote_recv_bind: Address already in use"`，dns 解析失败！
4. 原因很简单，dnsforwarder 占用了`0.0.0.0:53/udp`地址，导致 TPROXY 无法监听 8.8.8.8:53/udp 地址！
5. 那么是不是就意味着不能使用国外 dns 进行解析了呢？不是，我们可以使用非 53 端口，比如 OpenDNS 208.67.222.222:443/udp 解析，因为 443/udp 端口没有被占用；
6. 同理，如果内网主机要发送的 udp 包的目的端口为 60080、60053、65353，那么都会出现：地址被占用 - 错误！
7. 当然，很少有 udp 服务器会监听在 60080、60053、65353 端口上，因此这些问题都不必太过担心（这也是为什么我要将它们监听在高位端口的原因）；
8. 如果确实有需要发往 60080、60053、65353 端口的 udp 包，请修改`/etc/ss-tproxy.conf`中的 ss-redir、ss-tunnel、chinadns 监听端口！

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
- date: 2018-03-15 09:25:21 CST
