# Evidence Review Record Template

Use this structure for every evidence review. Leave out sections for document types that weren't provided.

---

```markdown
# Vendor Evidence Review

**Vendor:** [Name]
**Record type:** Evidence review
**Assessment Date:** [YYYY-MM-DD HH:MM] UTC
**Assessor:** AI-assisted (Claude Code, tprm plugin)
**Client:** [client from tprm.json]
**Entities:** [only when configured]
**Request:** [issue link, or "none"]
**Prior review:** [latest full review or re-review, if any]

> [Only when a document limits sharing: "Contains a summary of material provided under NDA. Share only with ..."]

---

## Summary

[Two or three paragraphs: what was provided, how current and complete it is, what it covers compared with the client's use, and the most important gaps or exceptions.]

**Assurance: [Sufficient / Sufficient with Gaps / Insufficient]**

## Documents Reviewed

| Document | Date or Period | What It Is | Assessment |
|----------|----------------|------------|------------|
| `[file name]` | | | |

## SOC Report Analysis

| Item | Finding |
|------|---------|
| Report type | |
| Period | |
| Report date | |
| Auditor | |
| Trust Services Criteria | |
| Opinion | |
| Bridge letter | |

### Scope

[What the report covers, in plain language, and what the client uses that it does not cover.]

### Subservice Organizations

| Organization | Carve-out or Inclusive | Controls expected of it (CSOCs) |
|--------------|------------------------|--------------------------------|
| | | |

### Exceptions and Deviations

| Control | Exception | Material? | Management Response | Assessment |
|---------|-----------|-----------|---------------------|------------|
| | | | | |

[Or: "No exceptions were reported in the testing section." Say so only if the testing section was provided.]

### Complementary User Entity Controls (CUECs)

| CUEC | What the client must do | Suggested owner | Status |
|------|-------------------------|-----------------|--------|
| | | | To confirm |

## Other Evidence

[ISO certificates, penetration tests, questionnaires, and whitepapers, using the fields in the skill.]

## Inconsistencies

| Claim | Source | Conflict |
|-------|--------|----------|
| | | |

## Requests and Next Steps

- [What to request from the vendor]
- [Re-assessment date, if the evidence expires sooner than the next scheduled review]

## Open Questions

[Anything that needs checking outside these documents, such as an auditor's standing.]
```
