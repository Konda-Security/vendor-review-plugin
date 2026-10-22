---
name: tprm-setup
description: Set up a third party risk management workspace for a client. Creates the tprm.json configuration, the folders for reviews and vendor evidence, and the approved-services tracker, or adopts an existing vendor review folder. Run this first for each client.
disable-model-invocation: true
allowed-tools:
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
  - Bash(gh repo view *)
argument-hint: "[client=<name>] [workspace=<folder>] [entities=A,B] [flags=Name] [pdf=builtin|none|<command>]"
---

# TPRM Workspace Setup

You set up the workspace that every other tprm skill uses. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` first; it defines the workspace, the `tprm.json` fields, and the tracker format. Use `${CLAUDE_PLUGIN_ROOT}/shared/tprm.example.json` as the starting point for the configuration.

The user provided: $ARGUMENTS

Arguments given as `key=value` answer the matching questions below; ask only for what is still missing.

## 1. Look at what already exists

- **Existing workspace:** Glob for `tprm.json`, `*/tprm.json`, and `*/*/tprm.json`. If one exists, show it and offer to update specific fields instead of starting over.
- **Existing vendor review folder:** Glob for `**/approved-services.md` and for review records named like `*-20??-??-??.md`. If a tracker or records already exist, propose adopting that folder as the workspace, its tracker file name as `tracker`, and the folder holding the records as `reviewsDir`. Read the tracker's `##` headings to propose `categories`.
- **Evidence folder:** look for an existing folder of vendor documents, such as `soc2-reports` or `evidence`, inside the proposed workspace.
- **GitHub:** if the folder is in a git checkout with a GitHub remote, get the repository from `gh repo view --json nameWithOwner`.
- **Existing policy and process documents:** Glob for files whose names mention vendor management or vendor review, and propose them for `docs.policy` and `docs.process`.

## 2. Ask for the rest

In one message, show what you found and ask for what's missing:
1. **Client name** for records and documents.
2. **Workspace folder:** the adopted folder, or `vendor-review/` in the current directory.
3. **Entities:** legal entities or business units that need separate audit scope, such as `Parent, Subsidiary, Shared`. Usually none.
4. **Flags:** extra Yes/No columns the client must track, such as `PHI` for healthcare or `Cardholder Data` for payments. Usually none.
5. **PDFs:** `builtin` (the plugin's pandoc script), `none`, or the client's own renderer command with `{input}` and `{output}` placeholders. It runs from the workspace folder.
6. **Review cadence:** months between reviews, 12 by default.
7. **Categories:** the defaults from the example, or the adopted tracker's headings.

If the client's policy documents already define entities, flags, or a cadence, propose those values and say where they came from.

## 3. Plan and confirm

Show the plan, and apply it after the user confirms:
- Create the workspace folder, `reviewsDir`, and `evidenceDir`, if missing.
- Write `tprm.json` with every field set explicitly.
- **Tracker:** if none exists, create it from `${CLAUDE_PLUGIN_ROOT}/skills/vendor-tracker/references/approved-services-template.md`, following the instructions at the top of that file. If one exists, leave it unchanged and recommend `/tprm:vendor-tracker migrate`.
- **Git:** if the workspace is in a git checkout and `evidenceDir` isn't ignored, propose adding `<workspace>/<evidenceDir>/` to the repository's `.gitignore`. Vendor evidence is often under NDA and shouldn't be committed.
- **Workspace README:** if the workspace has no `README.md`, create one from `${CLAUDE_SKILL_DIR}/references/workspace-readme-template.md`, replacing the bracketed values with the configured ones.

## 4. Next steps

Tell the user what to run next:
- `/tprm:vendor-tracker check` to validate the tracker, or `migrate` for an adopted one.
- `/tprm:tprm-docs` to draft or check the vendor management policy and process.
- `/tprm:vendor-github-sync setup` if the client takes vendor requests through GitHub issues.
- `/tprm:vendor-quick-check <vendor>` for the first request.
