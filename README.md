# portfolio-init

Spin up a personalized engineering portfolio in one command. Clones the [portfolio-template](https://github.com/waream2/portfolio-template) into a directory of your choice and installs the bundled `journal-post` skill globally so `/journal-post` works across all your projects.

## Two install paths

### With Claude Code (recommended)

Install the skill once:

```sh
git clone https://github.com/waream2/portfolio-init.git ~/.claude/skills/portfolio-init
```

Then in any Claude Code session:

```
/portfolio-init
```

The skill asks for a directory name and dispatches to `init.sh`.

### Without Claude Code

Run the script directly. Replace `<directory-name>` with whatever you want the portfolio repo to be called:

```sh
curl -fsSL https://raw.githubusercontent.com/waream2/portfolio-init/main/init.sh \
  | bash -s -- <directory-name>
```

This clones the template into `<directory-name>` in your current directory and installs the journal-post skill at `~/.claude/skills/journal-post/` for when you set up Claude Code later. Same end state as the skill flow.

## What `init.sh` does, exactly

1. Verifies `git` is available.
2. Refuses if the target directory already exists.
3. Clones the portfolio template.
4. Installs the journal-post skill at `~/.claude/skills/journal-post/`:
   - If a bundled copy is available locally (you ran the script via the skill), it `cp`s from there.
   - If not (you ran via `curl | bash`), it fetches the SKILL.md from this repo over HTTPS.
   - Skips silently if a journal-post skill already exists at that path.
5. Prints handoff instructions.

It does **not** run `npm install`, `cd` into the new repo, or modify files inside it. Project-level skills are scoped to the directory Claude Code launched from, so the handoff is a manual `cd` + relaunch — that's a Claude Code constraint, not a design choice.

## Repo layout

- `init.sh` — the setup script. Runs both via the skill (`bash <skill-path>/init.sh ...`) and standalone via `curl | bash`.
- `SKILL.md` — the `/portfolio-init` skill definition. A thin wrapper that asks for the directory name and dispatches to `init.sh`.
- `bundled/journal-post/SKILL.md` — payload copied into `~/.claude/skills/journal-post/` on install. Lets `/journal-post` work across all your projects, not just inside the portfolio repo. The portfolio template also ships with a project-local copy as a fallback for users who clone manually without this tooling.

## License

MIT
