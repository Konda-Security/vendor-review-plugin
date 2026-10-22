# Vendor Reviews

Third party risk management records for [CLIENT]. Managed with the Konda Security `tprm` Claude Code plugin; `tprm.json` holds this workspace's settings.

## Contents

- **`[TRACKER]`** — Approved services list, the source of truth for vendor decisions
- **`[REVIEWS_DIR]/`** — Review records: full reviews, re-reviews, quick checks, and evidence reviews
- **`[EVIDENCE_DIR]/`** — Vendor-provided documents such as SOC 2 reports, one folder per vendor. Kept out of git; often under NDA

## How Vendors Get Reviewed

| Step | Command |
|------|---------|
| Triage a new request | `/tprm:vendor-quick-check <vendor> [issue]` |
| Full assessment | `/tprm:vendor-review <vendor> [issue]` |
| Review a SOC 2 report or other vendor evidence | `/tprm:vendor-evidence-review <vendor>` |
| Record the decision | `/tprm:vendor-tracker record <record path>` |
| See what's due | `/tprm:vendor-tracker due` |
| Periodic re-review | `/tprm:vendor-rereview <vendor>` |
| Sync with GitHub issues | `/tprm:vendor-github-sync status` |

Install the plugin with `/plugin install tprm --marketplace https://kondasecurity.com/claude/marketplace.json`.
