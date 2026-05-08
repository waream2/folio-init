#!/usr/bin/env bash
#
# portfolio-init: clone the portfolio template and install the journal-post
# skill globally.
#
# Usage:
#   bash init.sh <directory-name>
#   curl -fsSL https://raw.githubusercontent.com/waream2/portfolio-init/main/init.sh \
#     | bash -s -- <directory-name>

set -euo pipefail

TEMPLATE_REPO_URL="https://github.com/waream2/portfolio-template.git"
JOURNAL_POST_RAW_URL="https://raw.githubusercontent.com/waream2/portfolio-init/main/bundled/journal-post/SKILL.md"
SKILL_HOME="$HOME/.claude/skills"
LOCAL_BUNDLED="$SKILL_HOME/portfolio-init/bundled/journal-post"
JOURNAL_POST_DIR="$SKILL_HOME/journal-post"

err() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

# 1. Validate args and dependencies
TARGET_DIR="${1:-}"
if [ -z "$TARGET_DIR" ]; then
	err "directory name required.

Usage:
  bash init.sh <directory-name>
  curl -fsSL <init-url> | bash -s -- <directory-name>"
fi

command -v git >/dev/null 2>&1 || err "git is not installed."

[ -e "$TARGET_DIR" ] && err "'$TARGET_DIR' already exists. Pick a different name or remove it first."

# 2. Clone the template
echo "Cloning template into $TARGET_DIR..."
git clone --quiet "$TEMPLATE_REPO_URL" "$TARGET_DIR"

# 3. Install the journal-post skill globally
if [ -e "$JOURNAL_POST_DIR/SKILL.md" ]; then
	echo "Note: $JOURNAL_POST_DIR/SKILL.md already exists; leaving it untouched."
	echo "      Delete it manually and re-run if you want a fresh copy."
elif [ -f "$LOCAL_BUNDLED/SKILL.md" ]; then
	mkdir -p "$JOURNAL_POST_DIR"
	cp -R "$LOCAL_BUNDLED/." "$JOURNAL_POST_DIR/"
	echo "Installed journal-post skill at $JOURNAL_POST_DIR/ (from bundled copy)."
elif command -v curl >/dev/null 2>&1; then
	mkdir -p "$JOURNAL_POST_DIR"
	curl -fsSL "$JOURNAL_POST_RAW_URL" -o "$JOURNAL_POST_DIR/SKILL.md"
	echo "Installed journal-post skill at $JOURNAL_POST_DIR/ for when you set up Claude Code."
else
	echo "warning: curl not available; skipping journal-post global install." >&2
fi

# 4. Handoff
cat <<EOF

Done. Your portfolio is at $(pwd)/$TARGET_DIR.

Next steps:
  cd $TARGET_DIR
  claude

Then in the new session, run /onboard to personalize the template
and fill in the journal-post site config.
EOF
