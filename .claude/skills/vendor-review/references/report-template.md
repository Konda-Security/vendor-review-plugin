# Vendor Security & Risk Assessment Report Template

Use this template structure for all vendor review reports.

---

```markdown
# Vendor Security & Risk Assessment

**Vendor:** [Company Name]
**Website:** [URL]
**Assessment Date:** [YYYY-MM-DD HH:MM UTC]
**Assessor:** AI-Assisted (Claude Code — Vendor Review Plugin)
**Report Version:** 1.0

---

## Executive Summary

[2-3 paragraph summary of the vendor, what they do, the overall risk rating, and the key findings that drive that rating. This should be readable by a non-technical executive.]

**Overall Risk Score: [X.X] / 5.0 — [Rating Label]**
**Recommendation: [Approve / Approve with Conditions / Discourage / Do Not Approve]**

---

## Company Overview

| Field              | Detail                    |
|--------------------|---------------------------|
| Legal Name         | [if discoverable]         |
| Headquarters       | [City, State/Country]     |
| Founded            | [Year]                    |
| Company Type       | [Public / Private]        |
| Ticker Symbol      | [if public]               |
| Employee Count     | [approximate]             |
| Industry           | [primary industry]        |
| Primary Products   | [key products/services]   |
| Key Customers      | [notable customers, if public] |

---

## Scorecard

| Dimension              | Score | Weight | Weighted | Evidence Summary                     |
|------------------------|-------|--------|----------|--------------------------------------|
| Security Posture       | X/5   | 15%    | X.XX     | [one-line evidence summary]          |
| Privacy Practices      | X/5   | 12%    | X.XX     | [one-line evidence summary]          |
| Compliance             | X/5   | 12%    | X.XX     | [one-line evidence summary]          |
| Breach History         | X/5   | 12%    | X.XX     | [one-line evidence summary]          |
| AI Risk                | X/5   | 10%    | X.XX     | [one-line evidence summary]          |
| Export Control Risk    | X/5   | 8%     | X.XX     | [one-line evidence summary]          |
| Financial Health       | X/5   | 8%     | X.XX     | [one-line evidence summary]          |
| Reputational Risk      | X/5   | 8%     | X.XX     | [one-line evidence summary]          |
| Leadership Stability   | X/5   | 5%     | X.XX     | [one-line evidence summary]          |
| Transparency           | X/5   | 10%    | X.XX     | [one-line evidence summary]          |
| **Overall**            |       |        | **X.XX** |                                      |

---

## Detailed Findings

### 1. Security Posture (Score: X/5)

#### What We Found
[Detailed analysis of the vendor's security practices based on their website, trust center, security page, and any published security documentation.]

#### Key Evidence
- [bullet point evidence items with source URLs]

#### Gaps or Concerns
- [identified gaps]

---

### 2. Privacy Practices (Score: X/5)

#### What We Found
[Analysis of privacy policy, data processing agreements, cookie policies, data subject request processes, and GDPR/CCPA compliance indicators.]

#### Key Evidence
- [bullet point evidence items]

#### Gaps or Concerns
- [identified gaps]

---

### 3. Compliance & Certifications (Score: X/5)

#### What We Found
[Analysis of SOC 2 Type I/II, SOC 3, ISO 27001, HIPAA, PCI DSS, FedRAMP, GDPR adequacy, and any other relevant compliance frameworks.]

#### Certifications Identified
| Certification    | Status      | Date/Validity | Notes           |
|------------------|-------------|---------------|-----------------|
| SOC 2 Type II    | [Y/N/Unknown] | [date if known] | [notes]       |
| ISO 27001        | [Y/N/Unknown] | [date if known] | [notes]       |
| [etc.]           |             |               |                 |

#### Key Evidence
- [bullet points]

#### Gaps or Concerns
- [identified gaps]

---

### 4. Breach History (Score: X/5)

#### What We Found
[Analysis of public breach disclosures, HaveIBeenPwned entries, news coverage of security incidents, and the vendor's incident response track record.]

#### Incident Timeline
| Date       | Incident                    | Severity  | Response Quality |
|------------|-----------------------------|-----------|------------------|
| [date]     | [description]               | [H/M/L]   | [assessment]     |

*If no breaches found, note that explicitly and describe the search methodology.*

#### Key Evidence
- [bullet points]

---

### 5. AI Risk (Score: X/5)

#### What We Found
[Analysis of the vendor's use of AI/ML in their products and services. Assessment of AI governance framework, model transparency, bias controls, regulatory compliance (EU AI Act, NIST AI RMF), and any AI-related incidents or controversies.]

#### AI Usage Identified
| AI Feature/Use Case   | Risk Level | Governance | Notes           |
|-----------------------|------------|------------|-----------------|
| [feature]             | [H/M/L/N/A] | [Y/N/Unknown] | [notes]     |

#### Key Evidence
- [bullet points]

#### Gaps or Concerns
- [identified gaps]

*If the vendor does not use AI, note that explicitly and mark this dimension N/A.*

---

### 6. Export Control Risk (Score: X/5)

#### What We Found
[Analysis of the vendor's exposure to export control regulations (ITAR, EAR), sanctions compliance (OFAC), entity list screening (BIS), country-of-origin risk for technology and personnel, and any prior export control violations or investigations.]

#### Jurisdictional Presence
| Jurisdiction          | Presence Type    | Risk Level | Notes           |
|-----------------------|------------------|------------|-----------------|
| [country]             | [HQ/Office/R&D/Data Center] | [H/M/L] | [notes]  |

#### Screening Results
| Database              | Match Found | Details                                  |
|-----------------------|-------------|------------------------------------------|
| OFAC SDN List         | [Y/N]       | [details if match]                       |
| BIS Entity List       | [Y/N]       | [details if match]                       |
| BIS Denied Persons    | [Y/N]       | [details if match]                       |

#### Key Evidence
- [bullet points]

#### Gaps or Concerns
- [identified gaps]

---

### 7. Financial Health (Score: X/5)

#### What We Found
[For public companies: revenue trends, profitability, debt levels, stock performance, analyst ratings. For private companies: funding history, employee growth/contraction, customer indicators, any available financial data.]

#### Key Metrics (Public Companies)
| Metric           | Value       | Trend      |
|------------------|-------------|------------|
| Revenue (TTM)    | $X          | [up/down]  |
| Net Income       | $X          | [up/down]  |
| Market Cap       | $X          |            |
| Debt/Equity      | X.X         |            |

#### Key Evidence
- [bullet points]

#### Gaps or Concerns
- [identified gaps]

---

### 8. Reputational Risk (Score: X/5)

#### What We Found
[D&B rating if available, BBB rating, major lawsuits, regulatory actions, analyst coverage, Glassdoor ratings as a stability signal, media sentiment.]

#### Key Evidence
- [bullet points]

#### Gaps or Concerns
- [identified gaps]

---

### 9. Leadership Stability (Score: X/5)

#### What We Found
[CEO and CISO tenure, recent executive departures, board composition, governance structure, key-person dependencies.]

#### Key Leadership
| Role            | Name          | Tenure     | Notes           |
|-----------------|---------------|------------|-----------------|
| CEO             | [name]        | [since X]  |                 |
| CISO/CSO        | [name]        | [since X]  |                 |
| CTO             | [name]        | [since X]  |                 |

#### Gaps or Concerns
- [identified gaps]

---

### 10. Transparency (Score: X/5)

#### What We Found
[Availability of trust center, status page, security whitepapers, transparency reports, bug bounty program, responsible disclosure policy, third-party audit availability.]

#### Key Evidence
- [bullet points]

---

## Risk Factors & Mitigations

### Key Risk Factors
1. [Highest risk factor and its potential impact]
2. [Second risk factor]
3. [Third risk factor]

### Recommended Mitigations
1. [Contractual protections to negotiate]
2. [Technical safeguards to implement]
3. [Monitoring or review cadence to establish]

---

## Methodology

This assessment was conducted using publicly available information including:
- Vendor website and trust/security pages
- Published privacy policies and terms of service
- Public compliance certifications and audit reports
- News coverage and breach databases
- Financial filings and market data (for public companies)
- Business reputation databases
- Leadership and governance information
- AI governance disclosures and model documentation
- Export control databases (OFAC SDN, BIS Entity List, BIS Denied Persons)

**Limitations:** This assessment is based on publicly available information as of the assessment date. It does not include:
- Penetration testing or technical vulnerability assessment
- Review of internal security policies or controls
- Direct vendor questionnaire responses
- Review of SOC 2 Type II report contents (unless publicly available)
- Confidential financial information (for private companies)

---

## Appendix: Sources

[Numbered list of all URLs and sources consulted during the assessment]

1. [URL] — [what was found there]
2. [URL] — [what was found there]
...
```
