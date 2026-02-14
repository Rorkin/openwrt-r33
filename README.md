# OpenWrt 23.05.5 — 极路由3 Pro + Passwall2

## 硬件信息

| 项目 | 参数 |
|---|---|
| 型号 | HiWiFi R33 / HC5861B / 极路由3 Pro |
| CPU | MT7620A 单核 580MHz |
| 架构 | mipsel_24kc |
| RAM | 128MB DDR2 |
| Flash | 128MB NAND |
| 交换芯片 | RTL8367RB (千兆) |
| WiFi | 2.4G (MT7620内置) + 5G (MT7612EN) |
| USB | USB 2.0 |

## 固件参数

| 项目 | 值 |
|---|---|
| 默认 IP | `192.168.10.1` |
| 默认密码 | 无 |

## 代理核心选择建议

128MB RAM 需要注意内存占用：

| 选项 | 核心 | 内存占用 | 适合场景 |
|------|------|----------|----------|
| `xray` | Xray-core | ~40-60MB | VLESS/REALITY 用户 (**推荐**) |
| `sing-box` | SingBox | ~40-60MB | Hysteria2/TUIC 用户 |
| `lightweight` | SS-libev + Xray | ~30-40MB | 内存紧张时 |
| `all` | 全部 | 安装大但只跑一个 | 想灵活切换 |

> ⚠️ 128MB RAM 建议只选一个核心，不要同时运行多个

## 编译

1. Fork → Actions → Run workflow → 选代理核心
2. 等 2~3 小时
3. Release 下载

## 刷机

### Breed 下
上传 `factory.bin`

### OpenWrt 下
```bash
sysupgrade -v /tmp/openwrt-*-sysupgrade.bin
