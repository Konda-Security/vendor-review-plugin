---
name: vendor-quick-check
description: Fast triage of a proposed vendor or tool from the intake request plus a few targeted web checks, without research agents. Decides whether the vendor can be fast-tracked or needs a full review. Use when the user asks to "triage a vendor request", "quick check a vendor", "can we fast-track this tool", or for low-risk tools such as browser extensions and free utilities.
allowed-tools:
  - WebFetch
  - WebSearch
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh *)
  - Bash(gh issue view *)
argument-hint: <vendor-url-or-name> [issue number]
---

# Vendor Quick Check

You triage a vendor request. Your job is to decide quickly and defensibly whether the vendor can be fast-tracked, or whether it needs a full review, not to assess it in depth. Do all the work yourself in this session: do not launch subagents, and use at most about ten web searches and fetches in total.

The user provided: $ARGUMENTS

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`.
2. Read the record template at `${CLAUDE_SKILL_DIR}/references/quick-check-template.md`.
3. Glob `<reviewsDir>/<slug>-*.md`. If a full review already exists, show its date and recommendation, suggest `/tprm:vendor-rereview` if it is due, and stop unless the user wants a quick check anyway.

## 1. Gather the request

If an issue number or URL was given, read it with `gh issue view <number> --json title,body,url` (add `--repo <github.repo>` when configured). Issue forms put each answer under a `### <question>` heading; checked boxes appear as `- [x]` and unchecked ones as `- [ ]`.

You need these answers. Take them from the request, and ask the user in one message for any that are missing:

| Question | Values |
|---|---|
| Purpose | what the vendor will do for the client |
| Data shared | client data, customer PII, employee data, source code or infrastructure configs, internal documents, meeting recordings, or none |
| Data stored by the vendor | yes, no (access only), unsure |
| Access to internal systems | which systems, or none. Include OAuth scopes, admin integrations, and browser extension permissions |
| Login | SSO, vendor password, API key, none; and whether MFA is supported |
| Criticality | critical, important, nice-to-have |
| AI on our data | yes, no, unsure; and whether training can be opted out |
| Entity | when `tprm.json` configures `entities` |
| Contract | existing, evaluating or trial, free tier |

## 2. Run the light checks

Spend your web budget on these, in order, and stop early once a result forces a full review:

1. **Identity and jurisdiction:** the legal entity, headquarters country, and whether the vendor is real and active. Any connection to a sanctioned or embargoed jurisdiction forces a full review.
2. **Security and trust page:** whether one exists, and which certifications are claimed (SOC 2, ISO 27001).
3. **Terms and privacy:** whether business use is allowed, whether customer content is used for AI training or advertising, and whether a DPA is offered.
4. **Incidents:** one search for breaches, security incidents, or regulatory actions in the last three years.
5. **For browser extensions, open source tools, and apps:** the publisher, install count, permissions requested, last update, and whether the code is public.

## 3. Decide

**Fast-track (recommendation: Approve)** only when every one of these holds:
- No data is shared other than the users' own sign-in details, and the vendor stores no client or company data.
- No access to internal systems beyond basic sign-in. A browser extension that can read or change all websites has access to everything the user sees, so it does not qualify.
- Criticality is nice-to-have.
- The vendor does not run AI on client or company data.
- The light checks found no red flag: an unclear identity, a sanctioned jurisdiction, a material incident, or terms that forbid business use.

**Full Review Required** when any criterion fails, any answer is "unsure", or a red flag needs investigating. List every reason; the full review uses them as its scope.

**Do Not Approve** only for a clear hard stop, such as a sanctioned jurisdiction, terms that prohibit the intended use, or a known-malicious tool. Explain it plainly.

Fast-track approvals still carry conditions. Typical ones: no client or company data may be entered, use SSO and MFA where available, install only from the official source, and revisit if use expands.

## 4. Write the record

Write the record to `<reviewsDir>/<slug>-<YYYY-MM-DD>-quick-check.md` using the template, following the metadata rules in the workspace specification. Every check cites what you fetched or found; when a check couldn't be completed, say so. Skip the PDF unless the user asks for one; if they do, follow "Producing PDFs" in the specification. Built-in PDF renderer: `${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh`.

## 5. Hand off

Show the recommendation and the reasons, then suggest the next step:
- Approve or Do Not Approve: `/tprm:vendor-tracker record <record path>`, then `/tprm:vendor-github-sync push` when the workspace uses GitHub.
- Full Review Required: `/tprm:vendor-tracker add <vendor>` if the vendor isn't in the tracker yet, then `/tprm:vendor-review <vendor> <issue>`.
