#!/usr/bin/env bash
#
# Install or update the /folio-init Claude Code skill.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/waream2/folio-init/main/install.sh | bash

set -euo pipefail

REPO_URL="https://github.com/waream2/folio-init.git"
SKILL_DIR="${FOLIO_INIT_SKILL_DIR:-$HOME/.claude/skills/folio-init}"

err() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

command -v git >/dev/null 2>&1 || err "git is not installed."

mkdir -p "$(dirname "$SKILL_DIR")"

if [ -d "$SKILL_DIR/.git" ]; then
	echo "Updating /folio-init at $SKILL_DIR..."
	git -C "$SKILL_DIR" pull --ff-only --quiet origin main
elif [ -e "$SKILL_DIR" ]; then
	err "$SKILL_DIR already exists and is not a git checkout. Move it aside and re-run this installer."
else
	echo "Installing /folio-init at $SKILL_DIR..."
	git clone --quiet "$REPO_URL" "$SKILL_DIR"
fi

cat <<EOF

Installed /folio-init.

NEXT
  1. cd to the folder where you want your portfolio repo to live
  2. run: claude
  3. in Claude Code, run: /folio-init

Example:
  cd ~/Documents
  claude
  /folio-init

EOF
