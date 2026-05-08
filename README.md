# portfolio-init

A Claude Code skill that clones the [portfolio-template](https://github.com/waream2/portfolio-template) into a new directory and hands you off to its `/onboard` flow.

One command from "I want a portfolio" to a personalized site.

## Install

```sh
git clone https://github.com/waream2/portfolio-init.git ~/.claude/skills/portfolio-init
```

That's it. `/portfolio-init` will be available in any Claude Code session.

## Usage

```sh
cd ~/Documents       # or wherever you want the new portfolio repo to live
claude
```

Then in Claude Code:

```
/portfolio-init
```

The skill asks for a directory name, clones the template into the current directory, and prints the next steps:

```
cd <your-portfolio>
claude
/onboard
```

`/onboard` (a project-level skill that ships with the template) finishes the personalization — name, site title, tagline, GitHub handle, deployed URL.

## What it does, exactly

1. Verifies `git` is installed.
2. Asks for a directory name (default: `portfolio`).
3. Confirms the directory doesn't already exist.
4. Runs `git clone` over HTTPS.
5. Prints handoff instructions.

It does **not** run `npm install`, `cd` into the new repo, or modify files. Project-level skills are scoped to the directory Claude Code launched from, so the handoff has to be a manual `cd` + relaunch — that's a Claude Code constraint, not a design choice.

## License

MIT
