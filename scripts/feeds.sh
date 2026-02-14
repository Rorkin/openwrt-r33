#!/bin/bash
set -e

echo "==========================================="
echo "  Adding Passwall2 feeds"
echo "==========================================="

cat >> feeds.conf.default << 'EOF'
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main
EOF

echo ""
echo "--- feeds.conf.default ---"
cat feeds.conf.default
echo "---------------------------"
