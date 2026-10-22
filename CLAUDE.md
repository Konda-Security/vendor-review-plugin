# tprm Plugin (Third Party Risk Management)

A Claude Code plugin for third party risk management. Published as `tprm` in the Konda Security marketplace (`https://kondasecurity.com/claude/marketplace.json`, maintained in the Konda-Security/www repo).

## Layout

- `skills/<name>/SKILL.md` — one skill per step of the vendor review process (see README for the list)
- `shared/workspace.md` — the workspace specification every skill reads: `tprm.json` fields, record file names, metadata block, tracker format, PDF rules. Change behavior shared across skills here, not in each skill
- `shared/tprm.example.json` — default workspace configuration
- `scripts/make-pdf.sh` — the built-in PDF renderer; skills pre-approve this script, never pandoc itself
- `skills/vendor-review/references/scoring.md` — the 10-dimension weighted rubric, also used by vendor-rereview

## Conventions

- Skills reference shared files through `${CLAUDE_PLUGIN_ROOT}` and their own files through `${CLAUDE_SKILL_DIR}`. Both only work when the skill loads as a plugin, so develop with `claude --plugin-dir .`, not by copying skills into `.claude/skills/`.
- Those variables are substituted only in `SKILL.md` and its `allowed-tools`, never in files a skill reads (`shared/`, `references/`). Put any command Claude must run with a plugin path, such as the PDF renderer, in the `SKILL.md` itself; otherwise Claude runs the literal `${...}` text and the permission rule doesn't match.
- Keep `allowed-tools` minimal. Writes to files, git, and GitHub are never pre-approved; skills show a plan and ask first.
- Skills that write to GitHub or create workspaces set `disable-model-invocation: true`.
- No client names or client-specific details anywhere in this repo; client choices live in each client's `tprm.json`.
- Bump `version` in `.claude-plugin/plugin.json` for every change that should reach marketplace users.

## Testing

- `claude plugin validate .`
- Load from outside the repo and check the skill list: `claude -p --plugin-dir <path> --output-format stream-json --verbose --max-turns 1 "Reply with OK."` and read the `skills` field of the init event.
- `scripts/make-pdf.sh` must keep rejecting absolute paths, `..`, option-like arguments, and non-`.md` files.
