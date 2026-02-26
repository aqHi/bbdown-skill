---
name: bbdown
description: Download bilibili videos using BBDown (nilaoda/BBDown). Use when the user asks to 下载/保存 B站视频, 批量下载, 选择清晰度, 指定输出目录, 需要 cookies 登录态, 或排查 BBDown 下载报错（403/大会员/分 P/字幕/弹幕）。
---

# BBDown

## Quick start

1) Ensure BBDown is installed and on PATH.

- macOS (Homebrew): `brew install bbdown`
- Or install via dotnet tool / release binaries: https://github.com/nilaoda/BBDown

2) Download a video

```bash
bash scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx'
```

## 常用参数示例（推荐直接用 wrapper）

- 指定输出目录（映射到 BBDown `--work-dir`）：

```bash
bash scripts/bbdown_download.sh '<url>' --out-dir ./downloads
```

- 选择清晰度优先级（BBDown `--dfn-priority`，逗号分隔）：

```bash
bash scripts/bbdown_download.sh '<url>' --dfn-priority "1080P 高码率, 1080P 高清, 720P 高清"
```

- 交互式选择清晰度（BBDown `-ia/--interactive`，透传参数）：

```bash
bash scripts/bbdown_download.sh '<url>' -- -ia
```

- 只下音频 / 只下视频：

```bash
bash scripts/bbdown_download.sh '<url>' -- --audio-only
bash scripts/bbdown_download.sh '<url>' -- --video-only
```

- 下载字幕 / 弹幕 / 封面：

```bash
bash scripts/bbdown_download.sh '<url>' -- --sub-only
bash scripts/bbdown_download.sh '<url>' -- --danmaku-only
bash scripts/bbdown_download.sh '<url>' -- --cover-only
```

- 多 P 视频：显示全部分P、选择分P范围（BBDown `--show-all` / `-p`）：

```bash
bash scripts/bbdown_download.sh '<url>' -- --show-all
bash scripts/bbdown_download.sh '<url>' -- -p 1-5
bash scripts/bbdown_download.sh '<url>' -- -p ALL
```

- 使用 TV / APP / 国际版接口解析（常用于解析差异/水印/地区内容）：

```bash
bash scripts/bbdown_download.sh '<url>' -- --use-tv-api
bash scripts/bbdown_download.sh '<url>' -- --use-app-api
bash scripts/bbdown_download.sh '<url>' -- --use-intl-api
```

- 自定义文件名（BBDown `--file-pattern` / `--multi-file-pattern`）：

```bash
bash scripts/bbdown_download.sh '<url>' -- --file-pattern '<videoTitle>[<dfn>]'
bash scripts/bbdown_download.sh '<url>' -- --multi-file-pattern '<videoTitle>/[P<pageNumberWithZero>]<pageTitle>[<dfn>]'
```

## Cookie / 会员内容

BBDown 的 `-c/--cookie` 需要的是 **Cookie 字符串**（如 `SESSDATA=...; bili_jct=...`）。

- 直接传 cookie 字符串：

```bash
bash scripts/bbdown_download.sh '<url>' --cookie 'SESSDATA=...; bili_jct=...'
```

- 从文件读取 cookie 字符串（文件里放一行即可）：

```bash
bash scripts/bbdown_download.sh '<url>' --cookie-file ./cookie.txt
```

- 也可以用 BBDown 自带扫码登录（会生成本地登录数据文件）：

```bash
BBDown login
```

## Troubleshooting

- 403 / 需要会员 / 地区限制：优先提供 `--cookie/--cookie-file`，或用 `BBDown login`。
- 下载失败：加 `--debug`（wrapper 会打印实际执行的 BBDown 命令），必要时把整段输出贴回来。
