# NanoPi NEO3 Plus 旁路由固件 - Actions-FriendlyWrt 定制包

基于官方 `friendlyarm/Actions-FriendlyWrt`，针对 RK3528 (NEO3 Plus / Zero2) 的旁路由定制。

## 配置摘要
- 版本：FriendlyWrt **24.10**，**non-docker**
- 仅编译 **rk3528**（产物同时适用 NEO3 Plus 和 Zero2）
- 旁路由模式：LAN 走 DHCP 获取地址 / 关闭 DHCP 服务器 / 关闭 IPv6
- 后台密码：root（**建议跑通后改强密码**）
- 主题：argon

## 使用步骤
1. Fork `friendlyarm/Actions-FriendlyWrt` 到你自己的账号
2. 把本压缩包内的文件**按目录结构覆盖**进 fork 的仓库：
   - `.github/workflows/build.yml`（覆盖）
   - `scripts/add_packages.sh`（覆盖）
   - `scripts/custome_config.sh`（覆盖）
   - `files/etc/uci-defaults/99-custom-bypass`（新增，注意保持可执行权限）
3. 提交并推送：
   ```bash
   git add .
   git commit -m "neo3plus bypass router"
   git push
   ```
4. 仓库页 → **Actions** → 左侧选 `Build FriendlyWrt` → 右侧 `Run workflow`
5. 约 40 分钟后到 **Releases** 下载：
   `Zero2-NEO3Plus-Series-FriendlyWrt-24.10.img.gz`
6. 烧到 SD 卡（balenaEtcher / dd），插上 NEO3 Plus 上电，首次启动等 2~3 分钟
7. 在主路由的 DHCP 客户端列表里找到它的 IP，浏览器进后台

## 软件包来源
- 官方 feed 自带（仅启用）：arpbind / ksmbd / samba4 / netdata / ttyd / watchcat /
  wireguard / zerotier / statistics / btop
- 独立仓库（单独 clone）：Nikki / OpenClash / argon主题 / tailscale / lucky
- small-package 精选拷贝：easytier / frps / subconverter / taskplan / timewol /
  fastnet / unishare

## 注意事项
1. **fastnet、unishare** 这两个包名未独立查证，脚本里做了"存在才拷"的保护。
   如果 Release 里没有它们，去 https://github.com/kenzok8/small-package 核对准确目录名，
   改 `scripts/add_packages.sh` 里的 `SMALL_PKGS` 列表。
2. **Nikki 和 OpenClash 只启用一个**，两者都是 mihomo/clash 内核会打架。
   1GB 内存建议用更轻的 Nikki。
3. 国内拉取慢：编辑 `scripts/add_packages.sh` 顶部的 `GHPROXY` 变量填加速前缀。
4. **根目录 Overlay 容量**：SD 卡镜像首次启动会自动扩展占满整张卡，无需固定。
   若确需锁定 1024M（如要单独分一个数据分区），需改
   `device/friendlyelec/rk3528/` 下的 parameter.txt 分区表，风险较高，按需再处理。
5. 编译失败先看 Actions 日志里 `make ... V=s` 的输出，多数是某个包依赖没满足。

## 触发方式说明
已把原仓库的"点 Star 触发"改成手动触发（workflow_dispatch）+ 推送 scripts/files 时触发，
并移除了 `if: owner.id == sender.id` 判断（否则 fork 后自己触发会被拒）。
