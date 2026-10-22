---
name: vendor-github-sync
description: Keep GitHub issues and the approved-services tracker in step. Installs the vendor review issue form and labels, pulls open vendor review issues into the tracker as Pending Review rows, and pushes local results back by committing review records and posting decisions to the intake issues. Use when the user asks to "sync vendor reviews with GitHub", "pull vendor requests", or "post the vendor decision to the issue".
disable-model-invocation: true
allowed-tools:
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
  - Bash(gh auth status *)
  - Bash(gh repo view *)
  - Bash(gh label list *)
  - Bash(gh issue list *)
  - Bash(gh issue view *)
argument-hint: status | setup | pull | push
---

# Vendor GitHub Sync

You keep the client's GitHub issues and the approved-services tracker consistent. The **tracker is the source of truth for decisions**; GitHub issues are the intake and notification channel. You only read from GitHub without asking. Every write, whether to GitHub, to git, or to the tracker, is shown to the user as a plan first and done only after they confirm.

The user asked for: $ARGUMENTS (default: `status`)

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`. Read the tracker.
2. Check `gh auth status`. If gh isn't signed in, tell the user to run `! gh auth login` and stop.
3. Resolve the repository: `github.repo` from `tprm.json`, otherwise `gh repo view --json nameWithOwner,defaultBranchRef` run from the workspace folder. Pass `--repo <owner/repo>` to every gh command.
4. Labels: the base label `L` is `github.label` (default `vendor-review`). Decision labels are `L/approved`, `L/conditional`, and `L/denied`.
5. Issues are titled `Vendor Review: <Vendor>`. Read them with `gh issue list --repo <repo> --label <L> --state all --limit 500 --json number,title,state,labels,url,body,comments,createdAt,closedAt`, as one command with no redirects or pipes, so it runs without a prompt.

**Matching issues to tracker rows:** a row's Request link names its issue. Otherwise match the vendor name in the issue title to the Vendor column, using the matching rules in the specification. One issue can back several rows, such as product tiers.

## status (read-only)

Report, without changing anything:
1. Open issues with no tracker row (`pull` would add them).
2. Rows with an issue but no Request link (`pull` would link them).
3. Decided rows (Approved, Conditional, Denied) whose issue is open, has no result comment for the current record, or has decision labels that differ from the tracker (`push` would fix these). Call out label drift explicitly, for example an issue labelled approved where the tracker says Conditional.
4. Rows other than Retired with no issue (`push` can open a retroactive issue for each).
5. Uncommitted or untracked workspace files, from `git status --porcelain -- <workspace>` (`push` would commit them), and local commits not yet on GitHub that contain records an issue refers to. Links to those records don't resolve until the commits are pushed.

End with the command for each group of fixes.

## setup

1. **Issue form:** the target is `.github/ISSUE_TEMPLATE/vendor-review.yml` at the repository root (`git rev-parse --show-toplevel` from the workspace). Build it from `${CLAUDE_SKILL_DIR}/references/vendor-review-issue-form.yml` by following the instructions at the top of that file. If a form already exists, show the differences and ask whether to keep it, replace it, or merge in the missing fields. Never overwrite it silently. Keep the existing field ids when merging so earlier issues still parse.
2. **Labels:** run `gh label list --repo <repo> --json name`. Plan to create whichever of these are missing: `L` (color `1D76DB`), `L/approved` (`0E8A16`), `L/conditional` (`FBCA04`), and `L/denied` (`B60205`), using `gh label create`.
3. Show the plan, and apply it after the user confirms.
4. Remind the user that the form file needs committing; `push` offers to commit it with the workspace changes.

## pull

1. For each **open** issue with no tracker row, parse the form answers. Each answer is under a `### <label>` heading; checked boxes are `- [x]`. Propose a Pending Review row:
   - **Vendor:** the vendor name answer, otherwise the title after `Vendor Review: `.
   - **Service:** the purpose answer.
   - **Data Handled:** the checked data types.
   - **Entity:** the entity answer, when configured.
   - **Request:** `[#N](<issue url>)`.
   - **Category and flags:** ask the user. Never guess flags.
2. For rows that match an issue but have no Request link, propose adding it.
3. Show the proposed rows, and write them to the tracker after the user confirms, following the tracker format in the specification.
4. Suggest `/tprm:vendor-quick-check <vendor> <issue>` for each new request.

## push

Build the whole plan first and show it grouped by step, with the exact commands. Ask the user to confirm each step separately, and stop if a step fails.

**Step 1: open retroactive issues.** For rows other than Retired that have no issue and no Request link, propose `gh issue create --repo <repo> --title "Vendor Review: <Vendor>" --label <L> --body-file -`. The body states that the review is retroactive (the vendor was already in use), and gives the service, data handled, entity, status, and record path. Let the user drop any rows from this step. After creating the issues, write each issue's link into the row's Request column.

**Step 2: commit and push the workspace changes.**
- Stage only these, each by explicit path: the tracker, the `.md` records in `reviewsDir`, `tprm.json`, the workspace `README.md`, and the issue form if `setup` created it. Never stage `evidenceDir`, PDFs, or anything git ignores. Never use `git add -A`, `git add .`, or `git add -f`.
- Show the current branch. If it is the default branch, ask whether to commit there or on a new branch named `vendor-review/<YYYY-MM-DD>`.
- Commit with a message naming the vendors, such as `Add vendor review records: Acme Notes, Example CRM`. Push with `git push`, adding `-u origin <branch>` if the branch has no upstream. Never force-push.
- If the push is rejected because the branch is protected, report it and offer to open a pull request with `gh pr create`.

**Step 3: post results to the issues.** For each decided row's issue:
- **Which issues get a comment:** open issues, and closed issues whose decision labels this step changes. Leave closed issues alone when they already carry the right labels, even if they have no marker comment from an earlier sync; they were most likely decided before the workspace used sync. Post on others only if the user asks.
- **Comment:** unless a comment ending in this record's marker already exists, post one with `gh issue comment <N> --repo <repo> --body-file -`. Include the decision and score, the main conditions or reason, Next Review, and a permanent link to the record: `https://github.com/<repo>/blob/<commit SHA>/<path from repository root>`, using the latest commit that contains the record (`git log -1 --format=%H -- <path>`). That commit must already be on GitHub; check with `git branch -r --contains <SHA>`, and leave the link out, saying why, if it isn't. Note that the PDF isn't in git and is available from the security team. End the comment with the marker `<!-- tprm:record=<record path> -->` so a later sync can tell it was posted.
- **Labels:** make the decision labels match the statuses of every row backed by the issue, adding and removing with `gh issue edit <N> --repo <repo> --add-label ... --remove-label ...`. An issue whose rows have different decisions, such as tiers, carries each matching label.
- **Close:** propose `gh issue close <N> --repo <repo>` when every row backed by the issue is decided and its Next Review is the standard cadence. Leave the issue open, and say so in the comment, when a row is still Pending Review or has an earlier follow-up date, such as a remediation deadline.

Finish with a list of what was done, with links.
