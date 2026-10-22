---
name: vendor-rereview
description: Periodic re-review of a vendor that already has a full review, focused on what changed since the prior record (SOC 2 currency, new incidents, terms and AI changes, ownership and leadership) and on whether prior conditions were met. Cheaper than a full review; escalates to one when the changes warrant it. Use when the user asks for an "annual vendor review", "re-review a vendor", "vendor reassessment", or which vendor reviews are due.
allowed-tools:
  - WebFetch
  - WebSearch
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh *)
argument-hint: <vendor-name> | due
---

# Vendor Re-Review

You re-assess a vendor the client has reviewed before. A re-review starts from the prior record and looks only for what has changed, so it is much cheaper than a full review. Do the work yourself in this session: do not launch subagents, and use at most about 25 web searches and fetches. If the changes are large, escalate to a full review instead of stretching this one.

The user provided: $ARGUMENTS

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`.
2. Read the scoring rubric at `${CLAUDE_PLUGIN_ROOT}/skills/vendor-review/references/scoring.md` and the record template at `${CLAUDE_SKILL_DIR}/references/rereview-template.md`.
3. If the argument is `due` or empty, read the tracker and list the vendors whose Next Review is past or within 30 days, then ask which to re-review.
4. Find the prior record: the latest full review or re-review for the vendor in `reviewsDir`. Read it in full, along with any later evidence review and the vendor's tracker row. If there is no prior full review or re-review, stop and suggest `/tprm:vendor-review`.

## 1. Confirm scope and conditions

Ask the user in one message:
- Has the client's use of the vendor changed: new data types, new teams, new integrations, or a different tier?
- For each condition or requirement in the prior record and the tracker row, is it Met, Not Met, or Unknown?

## 2. Look for changes since the prior assessment date

Check each area, citing what you fetched:

1. **Compliance currency:** a new SOC 2 period or bridge letter, ISO certificate renewals, and trust center changes.
2. **Incidents:** breaches, security incidents, actively exploited vulnerabilities in the vendor's products, regulatory actions, and lawsuits since the prior date.
3. **Terms:** the current terms, privacy policy, DPA, and AI or data-use terms, compared with what the prior record says. Note each page's "last updated" date.
4. **Ownership and finances:** acquisitions, mergers, funding, layoffs, and going-concern signals.
5. **Leadership:** changes of CEO, CISO, or other security leadership.
6. **AI features:** new features that touch customer data, and changes to training defaults or opt-outs.
7. **Export and sanctions:** only if the prior record flagged a concern or ownership changed.

## 3. Decide whether to escalate

Recommend a full review with `/tprm:vendor-review` instead of finishing, and explain why, when any of these is true:
- A material incident affected customers.
- Ownership changed through an acquisition or merger.
- The client's use expanded to more sensitive data or new entities.
- The prior record is older than twice `reviewCadenceMonths`, or isn't in the standard format with a scorecard.
- Three or more dimensions would change by a point or more.

Tell the user that a full review uses parallel research agents and costs more. Continue with the re-review only if they prefer it.

## 4. Re-score

Start from the prior record's dimension scores. Change a score only where new evidence supports the change, and mark the rest as carried forward. Recompute the weighted overall score with the rubric's weights, and determine the rating and recommendation as the rubric describes. A condition that is Not Met is a finding in its own right; consider whether the recommendation should tighten.

## 5. Write the record

Write the record to `<reviewsDir>/<slug>-<YYYY-MM-DD>.md` using the template, with Record type `Re-review` and `Prior review` pointing to the prior record, following the metadata rules in the workspace specification. Then produce the PDF as described under "Producing PDFs". Built-in PDF renderer: `${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh`.

## 6. Hand off

Show the changes, the old and new scores, and the recommendation, then suggest `/tprm:vendor-tracker record <record path>` and, when the workspace uses GitHub, `/tprm:vendor-github-sync push`.
