# BBDown Skill（OpenClaw）中文说明

这是一个给 OpenClaw/Codex 用的 Skill：把 [nilaoda/BBDown](https://github.com/nilaoda/BBDown) 常见的下载流程整理成更稳定、好调用的脚本与范例。

> 免责声明：请确保你的使用场景符合当地法律法规与 B 站条款，仅在你拥有合法授权的前提下下载内容。

## 1. 依赖

- 已安装 **BBDown** 且命令在 PATH 中。

  > 备注：Homebrew 里通常**没有** `bbdown` 这个 formula（`brew install bbdown` 很可能失败）。

  推荐两种安装方式：

  1) **GitHub Releases（二进制，最省事）**：
     - 打开：https://github.com/nilaoda/BBDown/releases
     - 下载与你系统匹配的包（例如 macOS Apple Silicon 通常是 `osx-arm64`）
     - 解压后把 `BBDown` 放到 PATH（例如 `~/.local/bin/BBDown`）

  2) **dotnet tool**（需要已安装 dotnet）：
     - 安装：`dotnet tool install --global BBDown`
     - 更新：`dotnet tool update --global BBDown`

- 如果需要混流（音视频合并）：通常还需要 `ffmpeg` 或 `mp4box`（BBDown 会提示）。

### 1.1 安装检查

运行下面任意一个命令能正常输出帮助/版本，就说明安装 OK：

```bash
BBDown --help
# 或
bbdown --help
```

## 2. 安装 Skill（通过链接）

把这个仓库 clone 到 OpenClaw 的 workspace skills 目录即可：

```bash
mkdir -p /Users/aqhi/.openclaw/workspace/skills
cd /Users/aqhi/.openclaw/workspace/skills

git clone https://github.com/aqHi/bbdown-skill.git bbdown
```

然后重启/新开一个 OpenClaw 会话，让技能重新加载。

## 3. 基本用法（推荐用 wrapper）

仓库里提供了一个 wrapper 脚本：

- `scripts/bbdown_download.sh`

### 3.1 最简单下载

```bash
bash scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx'
```

### 3.2 指定输出目录

```bash
bash scripts/bbdown_download.sh '<url>' --out-dir ./downloads
```

### 3.3 清晰度优先级（推荐）

对应 BBDown 的 `--dfn-priority`：

```bash
bash scripts/bbdown_download.sh '<url>' --dfn-priority "1080P 高码率, 1080P 高清, 720P 高清"
```

### 3.4 交互式选择清晰度

把参数透传给 BBDown：

```bash
bash scripts/bbdown_download.sh '<url>' -- -ia
```

### 3.5 只下音频 / 只下视频

```bash
bash scripts/bbdown_download.sh '<url>' -- --audio-only
bash scripts/bbdown_download.sh '<url>' -- --video-only
```

### 3.6 字幕 / 弹幕 / 封面

```bash
bash scripts/bbdown_download.sh '<url>' -- --sub-only
bash scripts/bbdown_download.sh '<url>' -- --danmaku-only
bash scripts/bbdown_download.sh '<url>' -- --cover-only
```

### 3.7 多 P：显示全部分P、选择分P

```bash
bash scripts/bbdown_download.sh '<url>' -- --show-all
bash scripts/bbdown_download.sh '<url>' -- -p 1-5
bash scripts/bbdown_download.sh '<url>' -- -p ALL
```

### 3.8 切换解析接口（TV / APP / 国际版）

```bash
bash scripts/bbdown_download.sh '<url>' -- --use-tv-api
bash scripts/bbdown_download.sh '<url>' -- --use-app-api
bash scripts/bbdown_download.sh '<url>' -- --use-intl-api
```

## 4. 会员/受限内容：Cookie 与登录

BBDown 的 `-c/--cookie` 需要的是 **Cookie 字符串**（例如 `SESSDATA=...; bili_jct=...`）。

### 4.1 直接传 cookie 字符串

```bash
bash scripts/bbdown_download.sh '<url>' --cookie 'SESSDATA=...; bili_jct=...'
```

### 4.2 从文件读取 cookie

把 cookie 字符串放到 `cookie.txt`（一行即可）：

```bash
bash scripts/bbdown_download.sh '<url>' --cookie-file ./cookie.txt
```

### 4.3 扫码登录（BBDown 原生命令）

```bash
BBDown login
```

## 5. 排错

- 403 / 需要会员 / 地区限制：优先用 `--cookie/--cookie-file`，或先 `BBDown login`。
- 想看实际执行的 BBDown 命令：加 `--debug`。

```bash
bash scripts/bbdown_download.sh '<url>' --debug
```
