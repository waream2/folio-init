#!/usr/bin/env bash
#
# folio-init: clone the /folio template and install the journal-post
# skill globally.
#
# Usage:
#   bash init.sh <directory-name> [--claude]
#   curl -fsSL https://raw.githubusercontent.com/waream2/folio-init/main/init.sh \
#     | bash -s -- <directory-name> [--claude]

set -euo pipefail

TEMPLATE_REPO_URL="https://github.com/waream2/folio.git"
JOURNAL_POST_RAW_URL="https://raw.githubusercontent.com/waream2/folio-init/main/bundled/journal-post/SKILL.md"
SKILL_HOME="$HOME/.claude/skills"
LOCAL_BUNDLED="$SKILL_HOME/folio-init/bundled/journal-post"
JOURNAL_POST_DIR="$SKILL_HOME/journal-post"

err() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

usage() {
	cat <<EOF
Usage:
  bash init.sh <directory-name> [--claude]
  curl -fsSL <init-url> | bash -s -- <directory-name> [--claude]
EOF
}

# 1. Validate args and dependencies
TARGET_DIR="${1:-}"
if [ -z "$TARGET_DIR" ]; then
	printf 'error: directory name required.\n\n' >&2
	usage >&2
	exit 1
fi

LAUNCH_CLAUDE=0
case "${2:-}" in
	"")
		;;
	--claude|--launch-claude)
		LAUNCH_CLAUDE=1
		;;
	*)
		printf 'error: unknown option: %s\n\n' "$2" >&2
		usage >&2
		exit 1
		;;
esac

if [ "${3:-}" ]; then
	printf 'error: too many arguments.\n\n' >&2
	usage >&2
	exit 1
fi

command -v git >/dev/null 2>&1 || err "git is not installed."

[ -e "$TARGET_DIR" ] && err "'$TARGET_DIR' already exists. Pick a different name or remove it first."
TARGET_PATH="$(pwd)/$TARGET_DIR"
printf -v TARGET_PATH_QUOTED '%q' "$TARGET_PATH"

cat <<EOF
If this succeeds, your next command will be:
  cd $TARGET_PATH_QUOTED && claude

EOF

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

if [ "$LAUNCH_CLAUDE" -eq 1 ]; then
	command -v claude >/dev/null 2>&1 || err "--claude requested, but the claude command is not installed or not on PATH."
	[ -r /dev/tty ] || err "--claude requested, but no interactive terminal is available."

	cat <<EOF

Done. Your portfolio is at $TARGET_PATH.

Opening Claude there now.
When Claude starts, run /onboard to personalize the template
and fill in the journal-post site config.
EOF

	cd "$TARGET_DIR"
	exec claude < /dev/tty
fi

# 4. Handoff
cat <<EOF

Done. Your portfolio is at $TARGET_PATH.

NEXT COMMAND
  cd $TARGET_PATH_QUOTED && claude

Then run /onboard in the new Claude session.

Tip: if you run init.sh directly from a terminal, add --claude
to open Claude automatically after cloning.
EOF
