# bbdown-skill

An OpenClaw/Codex AgentSkill for downloading bilibili videos via [nilaoda/BBDown](https://github.com/nilaoda/BBDown).

## What's inside

- `bbdown/` — the Skill folder
  - `SKILL.md`
  - `scripts/bbdown_download.sh`

## Local test

```bash
# Ensure bbdown is installed
bbdown -h

bash bbdown/scripts/bbdown_download.sh 'https://www.bilibili.com/video/BVxxxxxxxxx' --out-dir ./downloads --debug
```

## License

MIT
