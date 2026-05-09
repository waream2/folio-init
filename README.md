<p align="center">
  <img src="assets/wordmark.svg" alt="/folio" height="56" />
</p>

<h1 align="center">folio-init</h1>

<p align="center">
  <strong>Spin up a personalized engineering portfolio in one command.</strong>
</p>

<p align="center">
  Clones the <a href="https://github.com/waream2/folio">/folio</a> template into a directory of your choice and installs the bundled <code>journal-post</code> skill globally — so <code>/journal-post</code> works from any project, not just the portfolio repo.
</p>

<p align="center">
  <a href="#install"><strong>Install</strong></a> ·
  <a href="#what-it-does"><strong>What it does</strong></a> ·
  <a href="#repo-layout"><strong>Repo layout</strong></a>
</p>

---

## Install

### With Claude Code (recommended)

Run the installer:

```sh
curl -fsSL https://raw.githubusercontent.com/waream2/folio-init/main/install.sh | bash
```

It installs or updates the `/folio-init` skill, then prints the next steps.

If you prefer to install manually:

```sh
git clone https://github.com/waream2/folio-init.git ~/.claude/skills/folio-init
```

Then `cd` to the folder where you want the new portfolio repo to live, start Claude Code, and run:

```
/folio-init
```

The skill asks for a directory name and dispatches to `init.sh`.

### Without Claude Code

Run the script directly. Replace `<directory-name>` with whatever you want the portfolio repo to be called:

```sh
curl -fsSL https://raw.githubusercontent.com/waream2/folio-init/main/init.sh \
  | bash -s -- <directory-name>
```

Clones the `/folio` template into `<directory-name>` in your current directory and installs the journal-post skill at `~/.claude/skills/journal-post/` for when you set up Claude Code later. Same end state as the skill flow.

If you are running from a real terminal and want the script to open Claude in the new repo after cloning, add `--claude`:

```sh
curl -fsSL https://raw.githubusercontent.com/waream2/folio-init/main/init.sh \
  | bash -s -- <directory-name> --claude
```

## What it does

`init.sh` runs these steps in order:

1. Verifies `git` is available.
2. Refuses if the target directory already exists.
3. Clones the `/folio` template.
4. Installs the journal-post skill at `~/.claude/skills/journal-post/`:
   - If a bundled copy is available locally (you ran the script via the skill), it `cp`s from there.
   - If not (you ran via `curl | bash`), it fetches the SKILL.md from this repo over HTTPS.
   - Skips silently if a journal-post skill already exists at that path.
5. Prints the exact `cd ... && claude` command for the new repo.

It does **not** run `npm install` or modify files inside the cloned repo. By default it also does not `cd` into the cloned repo, because a shell script cannot move the parent terminal after the script exits. Instead it prints the exact next command.

If you pass `--claude` from a real terminal, the script `cd`s into the new repo and opens Claude there. That option is intentionally not used by the `/folio-init` skill because project-level skills are scoped to the directory Claude Code launched from, and starting a nested Claude session from inside Claude Code can hang or confuse the flow.

## Repo layout

| Path                              | What it is                                                                                                                                                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `install.sh`                      | Installs or updates the `/folio-init` Claude Code skill globally, then prints the next steps.                                                                             |
| `init.sh`                         | The setup script. Runs via the skill (`bash <skill-path>/init.sh ...`) and standalone via `curl \| bash`.                                                                 |
| `SKILL.md`                        | The `/folio-init` skill definition. A thin wrapper that asks for the directory name and dispatches to `init.sh`.                                                      |
| `bundled/journal-post/SKILL.md`   | Payload copied into `~/.claude/skills/journal-post/` on install. Lets `/journal-post` work across all your projects, not just inside the portfolio repo.                  |
| `assets/`                         | Logo SVGs used in this README.                                                                                                                                            |

The `/folio` template also ships with a project-local copy of `journal-post` as a fallback for users who clone manually without this tooling.

---

<p align="center">
  <img src="assets/mark.svg" alt="" height="28" />
</p>

<p align="center">
  <sub>MIT · Built by <a href="https://x.com/earnwhere">@earnwhere</a></sub>
</p>
