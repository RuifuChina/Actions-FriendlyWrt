#!/bin/bash
# 工作目录 = project/ (与 friendlywrt/ kernel/ u-boot/ 平级)
# 在 build.yml 的 "Apply customizations" 步骤被 source 调用
set -eu

GHPROXY=""   # 国内可填 "https://ghfast.top/" 之类的加速前缀，留空走直连
PKG_DIR="friendlywrt/package"

clone() {  # clone <repo-url> <target-name> [branch]
    local url="${GHPROXY}$1" name="$2" br="${3:-}"
    echo ">>> clone $name"
    if [ -n "$br" ]; then
        git clone --depth 1 -b "$br" "$url" "${PKG_DIR}/$name" || true
    else
        git clone --depth 1 "$url" "${PKG_DIR}/$name" || true
    fi
}

# ===== 独立权威仓库（干净、不冲突）=====
clone https://github.com/nikkinikki-org/OpenWrt-nikki    nikki                  main
clone https://github.com/vernesong/OpenClash             OpenClash
clone https://github.com/jerrykuku/luci-theme-argon      luci-theme-argon
clone https://github.com/jerrykuku/luci-app-argon-config luci-app-argon-config
clone https://github.com/asvow/luci-app-tailscale        luci-app-tailscale
clone https://github.com/gdy666/luci-app-lucky           luci-app-lucky

# ===== 从 small-package 精选拷贝（只取需要的，避免整源冲突）=====
echo ">>> fetch small-package (临时)"
git clone --depth 1 "${GHPROXY}https://github.com/kenzok8/small-package" /tmp/small || true

# 需要的包 + 其后端依赖包目录名（存在才拷）
SMALL_PKGS="
luci-app-easytier easytier
luci-app-frps frp
luci-app-subconverter subconverter
luci-app-taskplan
luci-app-timewol
luci-app-fastnet
luci-app-unishare
"
for p in $SMALL_PKGS; do
    if [ -d "/tmp/small/$p" ]; then
        echo "    copy $p"
        cp -rf "/tmp/small/$p" "${PKG_DIR}/$p"
    else
        echo "    !! $p 在 small-package 中未找到，跳过（请核对准确包名）"
    fi
done

# ===== 同名冲突清理模板 =====
# 如果第三方包与官方 feed 重名导致编译失败，删官方让位，例如：
# rm -rf friendlywrt/feeds/luci/applications/luci-app-xxx
# 目前你的清单无需处理，留作模板。

echo ">>> add_packages done"
