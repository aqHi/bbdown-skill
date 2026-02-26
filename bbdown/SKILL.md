---
name: bbdown
description: Download bilibili videos using BBDown (nilaoda/BBDown). Use when the user asks to 下载/保存 B站视频, 批量下载, 选择清晰度, 指定输出目录, 需要 cookies 登录态, 或排查 BBDown 下载报错（403/大会员/分 P/字幕/弹幕）。
---

# BBDown

## Quick start

1) Ensure BBDown is installed and on PATH.

- macOS (Homebrew): `brew install bbdown`
- Otherwise: see https://github.com/nilaoda/BBDown for binaries / dotnet tool.

2) Download a video

```bash
bash scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx'
```

## Common options

- Choose output directory:

```bash
bash scripts/bbdown_download.sh '<url>' --out-dir ./downloads
```

- Set quality (pass-through to BBDown):

```bash
bash scripts/bbdown_download.sh '<url>' --quality 80
```

- Use cookies (for会员/限制内容). Export cookies to a Netscape cookies.txt:

```bash
bash scripts/bbdown_download.sh '<url>' --cookies ./cookies.txt
```

## Troubleshooting

- If you see 403 / area restriction / need login: provide `--cookies`.
- If download fails, re-run with `--debug` to print the underlying BBDown command.
