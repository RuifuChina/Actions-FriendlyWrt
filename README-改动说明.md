# NanoPi NEO3 Plus 旁路由固件 - Actions-FriendlyWrt 定制包 (v2 修正版)

基于官方 friendlyarm/Actions-FriendlyWrt，针对 RK3528 (NEO3 Plus / Zero2) 的旁路由定制。

## v2 修正了两个 bug
1. 配置注入路径：种子配置是 `configs/rockchip/` 目录（mk-friendlywrt.sh 会 cat 目录里
   所有文件拼成 .config），改为往该目录写片段文件 `zzzz-custom.config`，不再是
   错误的 `friendlywrt/configs/rockchip`。
2. luci-app-frps 在 small-package 里没有，改成从 lwz322/luci-app-frps 单独 clone，
   后端 frp 仍从 small-package 取。

## 配置摘要
- FriendlyWrt 24.10，non-docker，仅编译 rk3528
- 旁路由：LAN 走 DHCP / 关 DHCP 服务器 / 关 IPv6 / 密码 root / argon 主题

## 覆盖这 4 个文件到 fork 仓库
- .github/workflows/build.yml
- scripts/add_packages.sh
- scripts/custome_config.sh
- files/etc/uci-defaults/99-custom-bypass   (需可执行权限)

## 触发
Actions → Build FriendlyWrt → Run workflow
产物：Releases 里的 Zero2-NEO3Plus-Series-FriendlyWrt-24.10.img.gz

## 注意
- 别忘了仓库/组织已开 Workflow write 权限，或 build.yml 顶部已加 permissions: contents: write
- Nikki 和 OpenClash 跑起来只启用一个
- fastnet / unishare 若日志显示 small-package 里没有，去仓库核对准确目录名后改
  add_packages.sh 的 SMALL_PKGS；注意：即使某个包没装上，make defconfig 会自动忽略
  无源的选项，不会导致编译失败。
