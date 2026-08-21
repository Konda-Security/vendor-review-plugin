---
name: vendor-review
description: Conduct a comprehensive vendor security and risk assessment. Use when the user invokes "/vendor-review", or asks to "review a vendor", "assess vendor risk", "vendor due diligence", "vendor security assessment", "third-party risk assessment", or "evaluate a vendor". Requires a URL or company name as input.
allowed-tools: WebFetch, WebSearch, Agent, Write, Read, Bash
argument-hint: <vendor-url-or-name>
---

# Vendor Security & Risk Assessment

You are conducting a thorough third-party vendor security and risk assessment. Your goal is to produce a professional, evidence-based risk report with a quantified scoring system.

## Input

The user provided: $ARGUMENTS

If this is a URL, use it as the vendor's primary website. If it's a company name, search for the company and confirm the correct website before proceeding.

If no argument was provided, ask the user for the vendor URL or company name before proceeding.

## Preparation

1. Read the scoring methodology from `references/scoring.md` (relative to this skill's directory).
2. Read the report template from `references/report-template.md` (relative to this skill's directory).
3. Extract the vendor's domain name for use in research queries.

## Research Phase — Parallel Agent Deployment

Launch the following research agents in parallel. Each agent should return structured findings. Give each agent the vendor name, URL, and domain.

### Agent 1: Company Overview & Website Analysis
Prompt the agent to:
- WebFetch the vendor's homepage and key pages (About, Products, Customers, Leadership/Team)
- Identify: legal name, headquarters, founded date, public/private status, employee count, industry, primary products, key customers
- If the company is publicly traded, identify the ticker symbol and exchange
- Look for the vendor's trust center, security page, or compliance page URLs
- Return structured company profile data and any trust/security/compliance page URLs discovered

### Agent 2: Security Posture Assessment
Prompt the agent to:
- WebFetch the vendor's trust center, security page, and any security documentation pages (use URLs from Agent 1 if available, otherwise search for them: `site:<domain> security OR trust OR "trust center"`)
- WebSearch for `"<vendor name>" security practices OR security certifications OR "bug bounty" OR "responsible disclosure"`
- Look for: published security policies, encryption practices, access control descriptions, vulnerability management, penetration testing claims, bug bounty or responsible disclosure programs, security team or CISO mentions
- WebFetch any security whitepaper or documentation links found
- Return findings with source URLs

### Agent 3: Privacy Practices Assessment
Prompt the agent to:
- WebFetch the vendor's privacy policy page
- WebFetch any data processing agreement (DPA) or cookie policy pages
- WebSearch for `"<vendor name>" privacy OR GDPR OR CCPA OR "data protection" OR "data processing agreement"`
- Analyze: data collection scope, data sharing/selling practices, retention policies, user rights mechanisms (DSAR process), cookie consent implementation, GDPR/CCPA compliance indicators, international data transfer mechanisms, sub-processor lists
- Return findings with source URLs

### Agent 4: Compliance & Certifications
Prompt the agent to:
- WebSearch for `"<vendor name>" "SOC 2" OR "SOC 3" OR "ISO 27001" OR "HIPAA" OR "PCI DSS" OR "FedRAMP" OR "HITRUST" OR "SOC2" OR "SOC3"`
- WebFetch any compliance or certification pages found on the vendor's site
- WebSearch for `"<vendor name>" compliance OR audit OR certification site:<domain>`
- Look for: SOC 2 Type I and Type II reports, SOC 3 reports, ISO 27001 certificates, HIPAA BAA availability, PCI DSS attestation, FedRAMP authorization, HITRUST certification, CSA STAR listing, any other compliance frameworks
- Note whether certifications are current, expired, or self-claimed vs. independently audited
- If SOC 3 reports or compliance summaries are publicly downloadable, fetch and analyze them
- Return structured compliance data with evidence

### Agent 5: Breach History & Incident Research
Prompt the agent to:
- WebSearch for `"<vendor name>" breach OR hack OR "data leak" OR "security incident" OR "data exposure" OR vulnerability OR CVE`
- WebSearch for `"<vendor name>" site:haveibeenpwned.com OR site:databreaches.net`
- WebSearch for `"<vendor name>" "incident response" OR "security advisory" OR "security notification"`
- Look for: confirmed data breaches, security incidents, vulnerability disclosures, regulatory enforcement actions related to security, the vendor's incident response quality and communication
- For each incident found: date, description, severity, number affected, response quality
- If no breaches found, document the search methodology for the report
- Return incident timeline and assessment

### Agent 6: Financial Health & Leadership
Prompt the agent to:
- Determine if the company is public or private
- **If public:**
  - WebSearch for `"<vendor name>" SEC filing OR 10-K OR annual report OR earnings`
  - WebSearch for `"<vendor name>" stock price OR market cap OR revenue`
  - WebSearch for `"<vendor name>" analyst rating OR financial outlook`
  - Look for: revenue trends, profitability, debt levels, market cap, analyst consensus, any going-concern warnings
- **If private:**
  - WebSearch for `"<vendor name>" funding OR series OR valuation OR acquisition`
  - WebSearch for `"<vendor name>" site:crunchbase.com OR site:pitchbook.com`
  - Look for: funding rounds, total raised, last valuation, investor quality, employee count trends (LinkedIn), customer growth signals
- **Leadership for all companies:**
  - WebSearch for `"<vendor name>" CEO OR CISO OR CTO OR "chief security" OR "head of security" leadership`
  - WebSearch for `"<vendor name>" executive departure OR leadership change OR "steps down" OR resignation`
  - Look for: CEO tenure, CISO/CSO presence and tenure, recent C-suite departures, board composition, governance structure
- Return structured financial and leadership data

### Agent 7: Reputational Risk
Prompt the agent to:
- WebSearch for `"<vendor name>" "dun and bradstreet" OR "D&B" OR DUNS`
- WebSearch for `"<vendor name>" BBB OR "better business bureau" rating`
- WebSearch for `"<vendor name>" lawsuit OR litigation OR "class action" OR sued OR regulatory action OR fine`
- WebSearch for `"<vendor name>" review OR complaint OR controversy OR scandal`
- WebSearch for `"<vendor name>" Gartner OR Forrester OR "magic quadrant" OR "wave report"`
- Look for: D&B risk rating, BBB rating and complaint history, active or recent lawsuits, regulatory fines or enforcement actions, analyst coverage and positioning, general media sentiment, Glassdoor rating (as a stability signal)
- Return structured reputational data with sources

### Agent 8: AI Risk Assessment
Prompt the agent to:
- WebFetch the vendor's website looking for AI/ML product features, AI-related pages, or AI governance documentation
- WebSearch for `"<vendor name>" "artificial intelligence" OR "machine learning" OR "AI" OR "ML model" OR "generative AI" OR "LLM"`
- WebSearch for `"<vendor name>" "AI governance" OR "responsible AI" OR "AI ethics" OR "model card" OR "AI transparency" OR "algorithmic bias"`
- WebSearch for `"<vendor name>" "EU AI Act" OR "NIST AI" OR "AI risk management" OR "AI audit"`
- WebSearch for `"<vendor name>" AI bias OR AI controversy OR AI discrimination OR AI hallucination OR "AI incident"`
- Determine: does the vendor use AI in its products/services? If so, in what capacity (core product, feature enhancement, internal tooling)?
- Look for: published AI governance framework, model cards or documentation, bias testing disclosures, human oversight mechanisms, AI-related certifications or assessments, EU AI Act compliance posture, NIST AI RMF alignment
- If the vendor does not appear to use AI, note that clearly so this dimension can be marked N/A
- Return structured AI risk data with evidence

### Agent 9: Export Control & Sanctions Risk
Prompt the agent to:
- WebSearch for `"<vendor name>" ITAR OR EAR OR "export control" OR "export compliance" OR "dual use"`
- WebSearch for `"<vendor name>" OFAC OR sanctions OR "denied parties" OR "entity list" OR "SDN list"`
- WebSearch for `"<vendor name>" headquarters OR offices OR locations OR operations` to map jurisdictional presence
- WebSearch for `"<vendor name>" Russia OR China OR Iran OR "North Korea" OR Cuba OR Syria OR Belarus` (sanctioned/high-risk jurisdictions)
- WebSearch for `"<vendor name>" "export violation" OR "sanctions violation" OR "BIS" OR "bureau of industry"`
- WebFetch any export compliance or trade compliance pages on the vendor's site
- Look for: country of incorporation and headquarters, office locations (especially in sanctioned or high-risk countries), published export compliance program, any OFAC SDN or BIS Entity List matches for the company name or key executives, technology classification under EAR/ITAR, history of export control violations or investigations, supply chain country-of-origin concerns
- Note: common-name matches on sanctions lists require careful evaluation — flag but do not auto-score as a match
- Return structured export control risk data with evidence

## Synthesis Phase

After all agents return, synthesize their findings:

1. **Cross-reference and validate.** Check for contradictions between agents' findings. If Agent 2 found certifications but Agent 4 didn't, or vice versa, reconcile.

2. **Score each dimension** using the rubric from `references/scoring.md`:
   - Security Posture (1–5)
   - Privacy Practices (1–5)
   - Compliance (1–5)
   - Breach History (1–5)
   - AI Risk (1–5, or N/A if vendor does not use AI)
   - Export Control Risk (1–5)
   - Financial Health (1–5)
   - Reputational Risk (1–5)
   - Leadership Stability (1–5)
   - Transparency (1–5)

   For each score, cite the specific evidence. If a dimension cannot be assessed, mark it "Unable to Assess" and exclude from the weighted average.

3. **Calculate the weighted overall score** per the weights in `references/scoring.md`.

4. **Determine the risk rating and recommendation:**
   - 4.5–5.0: Minimal Risk → Approve
   - 3.5–4.4: Low Risk → Approve with standard terms
   - 2.5–3.4: Moderate Risk → Conditional approval
   - 1.5–2.4: High Risk → Discourage
   - 1.0–1.4: Critical Risk → Do Not Approve

5. **Identify the top 3 risk factors** and propose specific mitigations.

## Report Generation

Generate the report using the template from `references/report-template.md`. Write the report to:

```
./reports/<vendor-slug>-<YYYY-MM-DD>.md
```

Where `<vendor-slug>` is the vendor name in lowercase kebab-case and `<YYYY-MM-DD>` is today's date.

Ensure the `reports/` directory exists (create it if not).

### Report Requirements

- Every score MUST have cited evidence. No bare numbers.
- Include source URLs in the Appendix for every claim.
- The Executive Summary must be readable by a non-technical executive.
- Use the exact scorecard table format from the template.
- Include the methodology and limitations section — this is critical for the report's credibility.
- All dates should use ISO 8601 format (YYYY-MM-DD).
- Note the current date and time prominently — this is a point-in-time assessment.

## Post-Report

After writing the report:

1. Display the **Executive Summary** and **Scorecard** in the conversation.
2. Tell the user the full report path.
3. Inform the user they can convert to PDF using:
   - `pandoc <report-path> -o <report-path>.pdf` (if pandoc is installed)
   - Or by opening the markdown in a viewer that supports PDF export
4. Ask if the user wants to drill deeper into any specific dimension or if any findings need correction.

## Important Guidelines

- **Evidence over inference.** Only score what you can support with evidence. When you infer, label it clearly as inference.
- **Conservative scoring.** When evidence is ambiguous, score conservatively (lower). False confidence is worse than acknowledged uncertainty.
- **No hallucinated sources.** Only cite URLs you actually fetched or search results you actually found. If a search returned no results, say so.
- **Current data.** Always note that this is a point-in-time assessment based on publicly available information. Do not claim completeness.
- **Professional tone.** This report may be shared with executives, legal teams, or compliance officers. Write accordingly.
