# Re-Review Record Template

Use this structure for every re-review. The prior record remains the reference for anything carried forward, so link it rather than repeating it.

---

```markdown
# Vendor Security & Risk Re-Review

**Vendor:** [Name]
**Website:** [URL]
**Record type:** Re-review
**Assessment Date:** [YYYY-MM-DD HH:MM] UTC
**Assessor:** AI-assisted (Claude Code, tprm plugin)
**Client:** [client from tprm.json]
**Entities:** [only when configured]
**Request:** [issue link, or "none"]
**Prior review:** [relative path] ([prior assessment date], score [X.XX])
**Related reviews:** [only for vendor families]

---

## Summary

[Two or three paragraphs: what changed since the prior review, whether prior conditions were met, and how the risk moved.]

**Overall Risk Score: [X.XX] / 5.0 — [Rating]** (prior: [X.XX], [Rating])
**Recommendation: [Approve / Approve with Conditions / Discourage / Do Not Approve]**

## Scope Check

| Question | Answer |
|----------|--------|
| Change in use, data, teams, integrations, or tier | |
| Escalation triggers checked | [list, with "none met" or which one and why the re-review continued] |

## Changes Since the Prior Review

| Area | Change | Source |
|------|--------|--------|
| Compliance currency | | |
| Incidents | | |
| Terms, privacy, DPA, AI terms | | |
| Ownership and finances | | |
| Leadership | | |
| AI features | | |
| Export and sanctions | [only if checked] | |

## Scorecard

| Dimension | Prior | Current | Weight | Weighted | Basis |
|-----------|-------|---------|--------|----------|-------|
| Security Posture | X/5 | X/5 | 15% | X.XX | [new evidence, or "carried forward"] |
| Privacy Practices | X/5 | X/5 | 12% | X.XX | |
| Compliance | X/5 | X/5 | 12% | X.XX | |
| Breach History | X/5 | X/5 | 12% | X.XX | |
| AI Risk | X/5 | X/5 | 10% | X.XX | |
| Export Control Risk | X/5 | X/5 | 8% | X.XX | |
| Financial Health | X/5 | X/5 | 8% | X.XX | |
| Reputational Risk | X/5 | X/5 | 8% | X.XX | |
| Leadership Stability | X/5 | X/5 | 5% | X.XX | |
| Transparency | X/5 | X/5 | 10% | X.XX | |
| **Overall** | **X.XX** | **X.XX** | | | |

## Prior Conditions

| Condition | Status | Notes |
|-----------|--------|-------|
| | Met / Not Met / Unknown | |

## Updated Requirements

[Conditions that carry forward, change, or are new, as a list.]

## Methodology and Limitations

This re-review starts from the prior record and checks only for changes since its assessment date. Dimensions marked "carried forward" were not re-researched. Condition status comes from the client's own answers. It is a point-in-time assessment based on publicly available information.

## Appendix: Sources

[Every URL fetched or search run for this re-review.]
```
