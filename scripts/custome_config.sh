#!/bin/bash
# 工作目录 = project/
# 在 build.yml 的 "Apply customizations" 步骤被 source 调用（在 add_packages.sh 之后）
set -eu

# non-docker 的配置目录（mk-friendlywrt.sh 会 cat 目录里所有文件拼成 .config）
# 命名 zzzz-custom.config 保证 ls 排序时最后追加
CFG_DIR="configs/rockchip"

if [ ! -d "$CFG_DIR" ]; then
    echo "ERROR: $CFG_DIR 不存在（应为配置片段目录），检查 repo sync configs 是否成功"
    ls -la configs/ 2>/dev/null || true
    exit 1
fi

cat > "$CFG_DIR/zzzz-custom.config" << 'EOF'
# ============ 科学上网 ============
CONFIG_PACKAGE_nikki=y
CONFIG_PACKAGE_luci-app-nikki=y
CONFIG_PACKAGE_luci-i18n-nikki-zh-cn=y
CONFIG_PACKAGE_luci-app-openclash=y

# ============ 组网 / VPN ============
CONFIG_PACKAGE_luci-app-tailscale=y
CONFIG_PACKAGE_luci-app-wireguard=y
CONFIG_PACKAGE_luci-app-frps=y

# ============ 共享 / NAS ============
CONFIG_PACKAGE_luci-app-samba4=y
CONFIG_PACKAGE_luci-app-ksmbd=y
CONFIG_PACKAGE_luci-app-unishare=y

# ============ 工具 / 监控 ============
CONFIG_PACKAGE_luci-app-lucky=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-watchcat=y
CONFIG_PACKAGE_luci-app-taskplan=y
CONFIG_PACKAGE_luci-app-timewol=y
CONFIG_PACKAGE_luci-app-arpbind=y
CONFIG_PACKAGE_luci-app-netdata=y
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_luci-app-fastnet=y
CONFIG_PACKAGE_btop=y

# ============ 主题 ============
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y

# ============ 中文 & 常用命令行 ============
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
CONFIG_PACKAGE_luci-i18n-openclash-zh-cn=y
CONFIG_PACKAGE_luci-i18n-ttyd-zh-cn=y
CONFIG_PACKAGE_luci-i18n-samba4-zh-cn=y
CONFIG_PACKAGE_luci-i18n-watchcat-zh-cn=y
CONFIG_PACKAGE_luci-i18n-statistics-zh-cn=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_wget-ssl=y
CONFIG_PACKAGE_tcpdump=y
EOF

echo ">>> 已写入 $CFG_DIR/zzzz-custom.config"

# 把默认配置文件烤进固件（旁路由 / 密码 / 关 IPv6 / 关 DHCP）
mkdir -p friendlywrt/files/etc/uci-defaults
cp ../files/etc/uci-defaults/99-custom-bypass \
   friendlywrt/files/etc/uci-defaults/99-custom-bypass
chmod +x friendlywrt/files/etc/uci-defaults/99-custom-bypass

echo ">>> custome_config done"
