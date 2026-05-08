---
name: portfolio-init
description: Clone the /folio engineering portfolio template and install the journal-post skill globally. Asks for a directory name, then dispatches to ~/.claude/skills/portfolio-init/init.sh which handles the clone, the journal-post global install, and the handoff message. Invoke from the parent directory you want the new portfolio to live in.
allowed-tools: Bash(bash *), Bash(pwd)
---

# portfolio-init — spin up a new portfolio from the template

The user has installed this skill globally (`~/.claude/skills/portfolio-init/`) and wants to start a fresh portfolio site. Your job: ask for a directory name, then dispatch to the bundled `init.sh` script. The script does the work; you handle the conversation.

## Why a script

The mechanical steps — `git clone`, `mkdir`, `cp -R`, error handling — are deterministic and best executed by bash. This skill is a thin conversational front-end: collect one piece of input, run the script. The same script runs standalone via `curl | bash` for users without Claude Code, so behavior stays in lockstep across both install paths.

## Hard constraints

- **Don't run `/onboard` or `cd` and continue.** Project-level skills are scoped to the launching cwd. The new portfolio's `/onboard` is unreachable from this session. The script prints the handoff; let it stand and stop.
- **Don't redo the script's work yourself.** No manual `git clone`, no manual `cp`, no manual error checks. The script is the source of truth. If it fails, surface the error and stop — do not improvise a recovery.

## Steps

1. **Confirm cwd.** Run `pwd` and tell the user: "I'll clone into `<cwd>/<name>`. `cd` somewhere else and re-run if you want a different parent." State it; don't ask.

2. **Ask for the directory name** with AskUserQuestion. Default suggestion: `portfolio`. Encourage lowercase-with-dashes — it'll become the npm package name once `/onboard` runs.

3. **Run the script.** Invoke:

   ```bash
   bash ~/.claude/skills/portfolio-init/init.sh <directory-name>
   ```

   Surface its stdout and stderr verbatim. The script handles every check (git installed, target exists, network failures, journal-post install) and prints its own handoff at the end.

4. **Stop after the script returns.** The script's handoff message is the final output. Add nothing — no summary, no extra suggestions, no "let me know if…".

## Don't

- Don't run `npm install`. The template's `/onboard` handles guidance.
- Don't read or edit files inside the cloned repo.
- Don't extend the conversation past the script output. The next move is the user's.
