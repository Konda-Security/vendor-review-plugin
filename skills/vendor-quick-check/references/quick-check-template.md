# Quick Check Record Template

Use this structure for every quick check. Keep it short; it is a triage record, not an assessment.

---

```markdown
# Vendor Quick Check

**Vendor:** [Name]
**Website:** [URL]
**Record type:** Quick check
**Assessment Date:** [YYYY-MM-DD HH:MM] UTC
**Assessor:** AI-assisted (Claude Code, tprm plugin)
**Client:** [client from tprm.json]
**Entities:** [only when configured]
**Request:** [issue link, "form submission", or "none"]

---

## Summary

[Two or three sentences: what the vendor is, what the client wants it for, and why it was or wasn't fast-tracked.]

**Recommendation: [Approve / Full Review Required / Do Not Approve]**

## Request

| Question | Answer | Source |
|----------|--------|--------|
| Purpose | | [issue, user] |
| Data shared | | |
| Data stored by the vendor | | |
| Access to internal systems | | |
| Login and MFA | | |
| Criticality | | |
| AI on our data | | |
| Contract | | |

## Fast-Track Criteria

| Criterion | Result | Notes |
|-----------|--------|-------|
| No client or company data shared or stored | Pass / Fail / Unsure | |
| No internal system access beyond sign-in | Pass / Fail / Unsure | |
| Nice-to-have criticality | Pass / Fail / Unsure | |
| No AI on client or company data | Pass / Fail / Unsure | |
| No red flags in the light checks | Pass / Fail / Unsure | |

## Light Checks

| Check | Finding | Source |
|-------|---------|--------|
| Identity and jurisdiction | | [URL] |
| Security or trust page, certifications | | [URL] |
| Terms, privacy, AI training, DPA | | [URL] |
| Incidents (last 3 years) | | [search terms used] |
| Extension or app details (if applicable) | | [URL] |

## Conditions

[For Approve: the conditions of use, as a list. For Full Review Required: the reasons, which become the scope of the full review. For Do Not Approve: the hard stop.]

## Limitations

This is a triage based on the intake request and a small number of public sources checked on the assessment date. It is not a security assessment. Re-check if the use of the vendor changes.
```
