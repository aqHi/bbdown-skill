#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install_bbdown.sh [--version VERSION] [--dest DIR] [--force] [--quiet]

Install BBDown from GitHub Releases into a local bin directory.

Options:
  --version VERSION   Install a specific version (e.g. 1.6.3). Default: latest.
  --dest DIR          Install directory. Default: ~/.local/bin
  --force             Overwrite existing BBDown binary if present.
  --quiet             Less output.

Examples:
  bash scripts/install_bbdown.sh
  bash scripts/install_bbdown.sh --dest /usr/local/bin
  bash scripts/install_bbdown.sh --version 1.6.3

After install:
  BBDown --help
EOF
}

VERSION="latest"
DEST_DIR="${HOME}/.local/bin"
FORCE=0
QUIET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --version) VERSION="${2:-}"; shift 2 ;;
    --dest) DEST_DIR="${2:-}"; shift 2 ;;
    --force) FORCE=1; shift ;;
    --quiet) QUIET=1; shift ;;
    *)
      echo "Unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: missing command: $1" >&2
    exit 1
  }
}

need_cmd curl
need_cmd unzip
need_cmd python3

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) OS_ID="osx" ;;
  Linux) OS_ID="linux" ;;
  *)
    echo "ERROR: unsupported OS: $OS" >&2
    exit 1
    ;;
esac

case "$ARCH" in
  arm64|aarch64) ARCH_ID="arm64" ;;
  x86_64|amd64) ARCH_ID="x64" ;;
  *)
    echo "ERROR: unsupported arch: $ARCH" >&2
    exit 1
    ;;
esac

SUFFIX="${OS_ID}-${ARCH_ID}"

API_URL="https://api.github.com/repos/nilaoda/BBDown/releases/${VERSION}"
if [[ "$VERSION" == "latest" ]]; then
  API_URL="https://api.github.com/repos/nilaoda/BBDown/releases/latest"
else
  # VERSION like 1.6.3
  API_URL="https://api.github.com/repos/nilaoda/BBDown/releases/tags/${VERSION}"
fi

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

[[ $QUIET -eq 1 ]] || echo "Fetching release metadata: $API_URL" >&2
JSON_PATH="$TMPDIR/release.json"
curl -fsSL "$API_URL" -o "$JSON_PATH"

ASSET_URL="$(python3 - "$SUFFIX" "$JSON_PATH" <<'PY' || true
import json
import sys

suffix = sys.argv[1]
json_path = sys.argv[2]

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

assets = data.get('assets') or []

# Prefer zip assets that include the suffix (e.g. osx-arm64)
cands = []
for a in assets:
    name = a.get('name') or ''
    url = a.get('browser_download_url') or ''
    if url and (suffix in name) and name.endswith('.zip'):
        cands.append((name, url))

if not cands:
    # Fallback: any zip
    for a in assets:
        name = a.get('name') or ''
        url = a.get('browser_download_url') or ''
        if url and name.endswith('.zip'):
            cands.append((name, url))

if not cands:
    sys.exit(3)

print(cands[0][1])
PY
)"

if [[ -z "$ASSET_URL" ]]; then
  echo "ERROR: could not find a BBDown release asset for suffix: $SUFFIX" >&2
  echo "Try specifying --version, or check releases: https://github.com/nilaoda/BBDown/releases" >&2
  exit 1
fi

[[ $QUIET -eq 1 ]] || echo "Downloading asset: $ASSET_URL" >&2
ZIP_PATH="$TMPDIR/bbdown.zip"
curl -fL "$ASSET_URL" -o "$ZIP_PATH"

UNZ_DIR="$TMPDIR/unz"
mkdir -p "$UNZ_DIR"
unzip -q "$ZIP_PATH" -d "$UNZ_DIR"

BIN_PATH="$(find "$UNZ_DIR" -maxdepth 3 -type f -name 'BBDown' -perm -111 | head -n 1 || true)"
if [[ -z "$BIN_PATH" ]]; then
  # some zips may not preserve executable bit
  BIN_PATH="$(find "$UNZ_DIR" -maxdepth 3 -type f -name 'BBDown' | head -n 1 || true)"
fi

if [[ -z "$BIN_PATH" ]]; then
  echo "ERROR: BBDown binary not found in downloaded zip" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
DEST_BIN="$DEST_DIR/BBDown"

if [[ -e "$DEST_BIN" && $FORCE -ne 1 ]]; then
  echo "ERROR: $DEST_BIN already exists. Re-run with --force to overwrite." >&2
  exit 1
fi

cp "$BIN_PATH" "$DEST_BIN"
chmod +x "$DEST_BIN"

[[ $QUIET -eq 1 ]] || echo "Installed: $DEST_BIN" >&2

# Quick sanity check
"$DEST_BIN" --help >/dev/null 2>&1 || true
[[ $QUIET -eq 1 ]] || echo "OK. Try: BBDown --help" >&2
