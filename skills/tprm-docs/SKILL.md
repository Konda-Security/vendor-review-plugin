---
name: tprm-docs
description: Draft or update a client's third party risk management documentation, namely the vendor management policy, the vendor review process, and the vendor request form, from templates and the workspace configuration. For existing documents, finds gaps and contradictions with how the workspace actually operates. Use when the user asks to "write a vendor management policy", "document the vendor review process", or "check our vendor policy".
disable-model-invocation: true
allowed-tools:
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
argument-hint: "[policy] [process] [form] | check"
---

# TPRM Documentation

You draft the documents that describe a client's third party risk management program, and keep them consistent with how the workspace actually operates. Drafts are for the client to review and approve; mark each one as a draft and never present it as approved.

The user provided: $ARGUMENTS

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`. Read the tracker.
2. Pick the documents: the ones named in the arguments, otherwise policy and process. `check` compares existing documents with the workspace and drafts nothing.
3. Read the matching templates in `${CLAUDE_SKILL_DIR}/references/`:
   - policy: `vendor-management-policy-template.md`
   - process: `vendor-review-process-template.md`
   - form: `vendor-request-form-template.md`
4. Find existing documents: `docs.policy` and `docs.process` from `tprm.json`, otherwise Glob for files whose names mention vendor management, vendor review, or vendor request.

## Gather what the templates need

Take values from `tprm.json`, the tracker, and existing documents, and ask the user in one message for the rest:
- Who owns the program, and who approves vendors and accepts risk (roles, not names).
- The intake channel: GitHub issues (when `github.repo` is set or the form is installed), a form, or email.
- Service levels for acknowledging a request and for a decision. The template defaults are 2 business days, then 5 business days for standard reviews and 10 for complex ones.
- Contract requirements the client already uses, such as the breach notice period.
- Whether to include the framework mapping table. It maps to SOC 2, NIST SP 800-53, and ISO/IEC 27001:2022, and must be verified against the client's own control framework.

## Draft a new document

When the document doesn't exist yet:
1. Fill the template: replace every bracketed value, delete the template's instructions, and remove the sections whose comments say to remove them when they don't apply, such as the entity and flag sections.
2. Make it describe what the workspace actually does: the tracker location and columns, the entities and flags, the cadence, the record types, and the commands used.
3. Write it to the configured path, or ask where (by default `<workspace>/docs/<name>.md`), and put `**Status:** DRAFT — requires approval by <approver role>` under the title.
4. Offer to set `docs.policy` or `docs.process` in `tprm.json` to the new path.

## Update or check an existing document

Never overwrite an existing document. Instead:
1. Compare it with the template and list what is missing, such as re-review triggers, AI vendor requirements, retirement, or risk acceptance.
2. **Cross-check it with the workspace and list every contradiction.** For example:
   - The policy requires entity tags or flags that the tracker doesn't have.
   - The policy states a review cadence different from `reviewCadenceMonths`.
   - The policy requires SOC 2 reports for critical vendors while tracker rows show none.
   - The process links to tools or forms that no longer exist.
   - The process omits a step the workspace performs, or the reverse.
3. For each finding, say whether the document or the workspace should change, and propose the exact text.
4. Apply document edits only after the user confirms each one. For workspace-side fixes, point to the right command, such as `/tprm:vendor-tracker migrate` to add entity or flag columns.

## Finish

List the files written or the findings, and remind the user that the drafts need review and approval through the client's normal policy process before they take effect.
