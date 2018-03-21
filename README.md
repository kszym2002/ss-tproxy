# SS/SSR 透明代理脚本
使用此脚本前，请确保你已正确安装以下组件：
- [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)：[安装方式](https://www.zfl9.com/ss-redir.html#shadowsocks-libev)
- [shadowsocksr-libev](https://github.com/shadowsocksr-backup/shadowsocksr-libev)：[安装方式](https://www.zfl9.com/ss-redir.html#shadowsocksr-libev)
- [chinadns](https://github.com/shadowsocks/ChinaDNS)：[安装方式](https://www.zfl9.com/ss-redir.html#chinadns)
- [dnsforwarder](https://github.com/holmium/dnsforwarder)：[安装方式](https://www.zfl9.com/ss-redir.html#dnsforwarder)
- ipset：[安装方式](https://www.zfl9.com/ss-redir.html#ipset)
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

**配置开机自启**
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
