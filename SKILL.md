---
name: portfolio-init
description: Clone the portfolio template into a new directory and hand off to its /onboard flow. Asks for a directory name, runs git clone over HTTPS, then prints the next steps. Invoke with /portfolio-init from the parent directory you want the new portfolio to live in.
allowed-tools: Bash(git clone *), Bash(ls *), Bash(pwd), Bash(test *), Bash(which git)
---

# portfolio-init — spin up a new portfolio from the template

The user has installed this skill globally (it lives at `~/.claude/skills/portfolio-init/`) and wants to start a fresh portfolio site without manually cloning. Your job: confirm where they want it, clone the template, and hand off to the cloned repo's `/onboard` flow with a clean message.

## Site config

Fill these in once when you set up this skill, then commit. The skill refuses to run while the placeholder is present — fail loudly with a clear message telling the maintainer to edit `SKILL.md`.

```
TEMPLATE_REPO_URL: https://github.com/waream2/portfolio-template.git
```

## Hard constraints

- **You cannot run `/onboard` yourself.** Project-level skills are scoped to the directory Claude Code launched from. `/onboard` lives inside the cloned repo and is not available in this session. Your job ends at the handoff message.
- **Do not `cd` and try to keep working in the cloned repo.** The session is in the wrong directory. Print the handoff and stop.
- **Use HTTPS, not SSH.** Public template, no auth needed; SSH breaks for users without GitHub keys.
- **Never overwrite an existing directory.** If the target name is taken, ask for a different one.

## Steps

1. **Pre-flight.** Verify `git` is installed (`which git`). If not, tell the user to install git and stop. Verify `TEMPLATE_REPO_URL` above is filled in (not a placeholder); if it still contains `<fill in...>`, stop and tell the user this skill hasn't been configured yet.

2. **Confirm the parent directory.** Run `pwd`. Tell the user: "I'll clone into `<cwd>/<name>`. Want it somewhere else? `cd` there and re-run `/portfolio-init`." Don't ask — just state it. The user can interrupt if cwd is wrong.

3. **Ask for a directory name.** Use AskUserQuestion. Default suggestion: `portfolio`. Encourage lowercase-with-dashes — the directory name becomes the npm package name once `/onboard` runs.

4. **Check it doesn't already exist.** `test -e <name> && echo exists`. If it exists, ask for a different name (or to abort). Do not clone over it.

5. **Clone.** Run `git clone <TEMPLATE_REPO_URL> <name>`. If clone fails — network, bad URL, anything — surface the stderr verbatim and stop. Don't try to recover.

6. **Hand off.** Print exactly this, with `<name>` substituted:

   ```
   Cloned to <cwd>/<name>.

   Next steps:
     cd <name>
     claude

   Then in the new session, run /onboard to personalize the template.
   ```

   That's the whole output. Don't add summary, don't recommend `npm install` (onboard handles guidance), don't suggest opening files. The user just wants to get into their new repo.

## Don't

- Don't run `npm install`.
- Don't read or edit files inside the cloned repo.
- Don't extend the conversation past the handoff. The next move is the user's.
