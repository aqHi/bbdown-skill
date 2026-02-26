# bbdown-skill

**OpenClaw AgentSkill** for downloading bilibili videos via [nilaoda/BBDown](https://github.com/nilaoda/BBDown).

**English** | **[简体中文](docs/README.zh-CN.md)**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-4EAA25)](#)

## What’s inside

- `SKILL.md` — the Skill definition (how OpenClaw discovers/uses it)
- `scripts/bbdown_download.sh` — a stable wrapper around BBDown for agents/humans
- `docs/README.zh-CN.md` — Chinese usage & troubleshooting

## Prerequisites (BBDown)

You must have **BBDown** installed and available on PATH.

Notes:
- Homebrew usually **does not** provide a working `bbdown` formula. Prefer GitHub Releases or dotnet tool.
- Depending on install method, the executable may be `BBDown` (official releases) or `bbdown`.

### Install helper (recommended)

This repo includes an installer that downloads the correct BBDown release for your OS/arch:

```bash
bash scripts/install_bbdown.sh
# then
BBDown --help
```

Quick check:

```bash
BBDown --help || true
bbdown --help || true
```

## Install this skill

### Option A: clone into OpenClaw workspace skills (recommended)

```bash
mkdir -p ~/.openclaw/workspace/skills
cd ~/.openclaw/workspace/skills

git clone https://github.com/aqHi/bbdown-skill.git bbdown
```

Restart your OpenClaw session so it reloads skills.

### Option B: download zip

Download: <https://github.com/aqHi/bbdown-skill/archive/refs/heads/main.zip>

Unzip into your OpenClaw skills directory and rename the folder to `bbdown`.

## Usage (wrapper)

The recommended entrypoint is:

```bash
bash scripts/bbdown_download.sh '<bilibili_url>' --out-dir ./downloads
```

Audio-only example:

```bash
bash scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx' --out-dir ./downloads -- --audio-only
```

## Cross-platform notes

- **macOS/Linux**: the wrapper is `bash`.
- **Windows**: you can still use BBDown directly, or run the wrapper via WSL/Git-Bash. (PRs welcome for a PowerShell wrapper.)

## License

MIT
