# bbdown-skill

An OpenClaw/Codex AgentSkill for downloading bilibili videos via [nilaoda/BBDown](https://github.com/nilaoda/BBDown).

## What's inside

- `SKILL.md` — the Skill definition
- `scripts/bbdown_download.sh` — stable wrapper around BBDown
- `docs/README.zh-CN.md` — 中文说明文档

## Install (via link)

### Option A: install into OpenClaw workspace skills (recommended)

```bash
mkdir -p /Users/aqhi/.openclaw/workspace/skills
cd /Users/aqhi/.openclaw/workspace/skills

# clone by URL
git clone https://github.com/aqHi/bbdown-skill.git bbdown
```

Restart your OpenClaw session so it reloads skills.

### Option B: download zip

Download: <https://github.com/aqHi/bbdown-skill/archive/refs/heads/main.zip>

Unzip into your OpenClaw skills directory and rename the folder to `bbdown`.

## Local test

```bash
# Ensure bbdown is installed
bbdown -h

bash scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx' --out-dir ./downloads --debug
```

## License

MIT
