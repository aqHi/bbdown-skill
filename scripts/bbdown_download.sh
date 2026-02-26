#!/usr/bin/env bash
set -euo pipefail

# A thin, stable wrapper around BBDown.
# Keeps common flags consistent and makes it easy for an agent to call.

usage() {
  cat <<'EOF'
Usage:
  bbdown_download.sh <bilibili_url>
    [--out-dir DIR]
    [--dfn-priority "8K 超高清, 1080P 高码率"]
    [--cookie STRING | --cookie-file FILE]
    [--debug]
    [--] [extra BBDown args...]

Examples:
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx'
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx' --out-dir ./downloads --dfn-priority "1080P 高码率, 1080P 高清"
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx' --cookie-file ./cookie.txt
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx' -- --audio-only

Notes:
  - Any extra args after "--" are passed through to BBDown.
  - For VIP/limited content, use --cookie/--cookie-file, or run: BBDown login
EOF
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: missing command: $1" >&2
    return 1
  }
}

# BBDown 在不同安装方式下可能是 `BBDown`（官方 release）或 `bbdown`（部分包管理器/别名）。
pick_bbdown_cmd() {
  if command -v bbdown >/dev/null 2>&1; then
    echo "bbdown"; return 0
  fi
  if command -v BBDown >/dev/null 2>&1; then
    echo "BBDown"; return 0
  fi
  echo ""; return 1
}

URL=""
OUT_DIR=""
DFN_PRIORITY=""
COOKIE_STRING=""
COOKIE_FILE=""
DEBUG=0
PASS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --out-dir)
      OUT_DIR="${2:-}"; shift 2
      ;;
    --dfn-priority)
      DFN_PRIORITY="${2:-}"; shift 2
      ;;
    # Back-compat: map old --quality to --dfn-priority
    --quality)
      DFN_PRIORITY="${2:-}"; shift 2
      ;;
    --cookie)
      COOKIE_STRING="${2:-}"; shift 2
      ;;
    --cookie-file|--cookies)
      COOKIE_FILE="${2:-}"; shift 2
      ;;
    --debug)
      DEBUG=1; shift
      ;;
    --)
      shift
      PASS+=("$@"); break
      ;;
    *)
      if [[ -z "$URL" ]]; then
        URL="$1"; shift
      else
        PASS+=("$1"); shift
      fi
      ;;
  esac
done

if [[ -z "$URL" ]]; then
  usage >&2
  echo "ERROR: missing <bilibili_url>" >&2
  exit 2
fi

BBDOWN_BIN="$(pick_bbdown_cmd || true)"
if [[ -z "$BBDOWN_BIN" ]]; then
  echo "ERROR: missing command: BBDown (or bbdown)" >&2
  echo "Hint: install from https://github.com/nilaoda/BBDown/releases and put BBDown on PATH." >&2
  exit 1
fi

CMD=($BBDOWN_BIN "$URL")

if [[ -n "$OUT_DIR" ]]; then
  mkdir -p "$OUT_DIR"
  CMD+=(--work-dir "$OUT_DIR")
fi

if [[ -n "$DFN_PRIORITY" ]]; then
  CMD+=(--dfn-priority "$DFN_PRIORITY")
fi

if [[ -n "$COOKIE_FILE" ]]; then
  if [[ ! -f "$COOKIE_FILE" ]]; then
    echo "ERROR: cookie file not found: $COOKIE_FILE" >&2
    exit 2
  fi
  # BBDown expects a cookie string (e.g., "SESSDATA=...; bili_jct=..."),
  # so we read the file content and pass it via -c/--cookie.
  COOKIE_STRING="$(tr -d '\n' < "$COOKIE_FILE")"
fi

if [[ -n "$COOKIE_STRING" ]]; then
  CMD+=(--cookie "$COOKIE_STRING")
fi

if [[ ${#PASS[@]} -gt 0 ]]; then
  CMD+=("${PASS[@]}")
fi

if [[ $DEBUG -eq 1 ]]; then
  echo "+ ${CMD[*]}" >&2
fi

"${CMD[@]}"
