#!/usr/bin/env bash
set -euo pipefail

# A thin, stable wrapper around BBDown.
# Keeps common flags consistent and makes it easy for an agent to call.

usage() {
  cat <<'EOF'
Usage:
  bbdown_download.sh <bilibili_url> [--out-dir DIR] [--quality QN] [--cookies FILE] [--debug] [--] [extra BBDown args...]

Examples:
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx'
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx' --out-dir ./downloads --quality 80
  bbdown_download.sh 'https://www.bilibili.com/video/BVxxxx' --cookies ./cookies.txt

Notes:
  - --quality is passed to BBDown as "--quality <QN>" (if supported by your BBDown version).
  - Any extra args after "--" are passed through to BBDown.
EOF
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: missing command: $1" >&2
    return 1
  }
}

URL=""
OUT_DIR=""
QUALITY=""
COOKIES=""
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
    --quality)
      QUALITY="${2:-}"; shift 2
      ;;
    --cookies)
      COOKIES="${2:-}"; shift 2
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

need_cmd bbdown

# Build BBDown command.
CMD=(bbdown "$URL")

if [[ -n "$OUT_DIR" ]]; then
  mkdir -p "$OUT_DIR"
  CMD+=(--work-dir "$OUT_DIR")
fi

if [[ -n "$QUALITY" ]]; then
  CMD+=(--quality "$QUALITY")
fi

if [[ -n "$COOKIES" ]]; then
  if [[ ! -f "$COOKIES" ]]; then
    echo "ERROR: cookies file not found: $COOKIES" >&2
    exit 2
  fi
  CMD+=(--cookie "$COOKIES")
fi

# Pass-through args
if [[ ${#PASS[@]} -gt 0 ]]; then
  CMD+=("${PASS[@]}")
fi

if [[ $DEBUG -eq 1 ]]; then
  echo "+ ${CMD[*]}" >&2
fi

"${CMD[@]}"
