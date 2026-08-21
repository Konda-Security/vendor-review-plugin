# Vendor Review Plugin

A Claude Code plugin that conducts comprehensive third-party vendor security and risk assessments.

## Usage

```
/vendor-review <vendor-url-or-company-name>
```

## What It Does

Spawns parallel research agents to investigate a vendor across eight risk dimensions, scores each dimension 1–5 using a weighted rubric, and generates a timestamped markdown report suitable for PDF export.

## Research Dimensions

1. **Security Posture** (20%) — published security practices, certifications, vuln management
2. **Privacy Practices** (15%) — privacy policy, DPA, GDPR/CCPA compliance
3. **Compliance** (15%) — SOC 2/3, ISO 27001, HIPAA, PCI DSS, FedRAMP
4. **Breach History** (15%) — public breaches, incident response track record
5. **Financial Health** (10%) — revenue, funding, going-concern risk
6. **Reputational Risk** (10%) — D&B, BBB, lawsuits, regulatory actions
7. **Leadership Stability** (5%) — executive tenure, governance
8. **Transparency** (10%) — trust center, status page, audit availability

## Output

Reports are written to `reports/<vendor-slug>-<YYYY-MM-DD>.md`.

## Limitations

- Based on publicly available information only
- Point-in-time assessment — not continuous monitoring
- Does not include penetration testing or internal control review
- Private company financial data is limited to public signals
