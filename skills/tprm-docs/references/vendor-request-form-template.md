<!--
Template for /tprm:tprm-docs, for clients that take requests by form or email
instead of GitHub issues. The questions match the GitHub issue form installed by
/tprm:vendor-github-sync, so both kinds of request are triaged the same way.
Replace [CLIENT], remove the entity question when no entities are configured,
and delete this comment.
-->
# Vendor Review Request

Complete this form to request approval for a new third-party vendor or service. All services handling company or client data must be approved before use.

**Requested by:**
**Date:**

## Vendor

**Vendor name:**

**Vendor website:**

**What does this vendor do for us?** *(one or two sentences)*

**Who at [CLIENT] is the internal owner for this vendor?**

**Which entity will use this vendor?** *(Remove when no entities are configured.)*

**Contract status:**
- [ ] Existing contract
- [ ] Evaluating / trial
- [ ] Free tier

## Data and Access

**What data will we share with this vendor?** *(check all that apply)*
- [ ] Client or customer data (documents, records, communications)
- [ ] Customer PII (names, emails, contact info)
- [ ] Employee data (HR, payroll, performance)
- [ ] Source code or infrastructure configs
- [ ] Internal documents (strategy, financials, contracts)
- [ ] Meeting recordings or transcripts
- [ ] None — no data shared

**Will the vendor store or process that data in their own systems?**
- [ ] Yes
- [ ] No — access only, no storage
- [ ] Not sure

**Will the vendor have access to any of our internal systems?** *(integrations, OAuth permissions, admin access, or browser extension permissions)*

## Sign-In

**How will people log in?**
- [ ] SSO (company identity provider)
- [ ] Username and password (vendor-managed)
- [ ] API key or service account
- [ ] N/A — no login required

**Does the vendor support MFA?**
- [ ] Yes
- [ ] No
- [ ] Not sure

## Assurance and Risk

**Does the vendor have a SOC 2 report, ISO 27001 certificate, or equivalent?**
- [ ] Yes — link or report: ______
- [ ] Will request
- [ ] No / not sure

**What happens if this vendor goes down?**
- [ ] Critical — operations stop without it
- [ ] Important — causes disruption but we can work around it
- [ ] Nice-to-have — minimal impact

**Does this vendor use AI/ML to process our data?**
- [ ] Yes
- [ ] No
- [ ] Not sure

## Anything Else

**Anything the security team should know?** *(urgency, special requirements, alternatives considered)*

---

*For the security team:*

**Review record:**
**Decision:** Approved / Conditional / Denied
**Recorded in the approved services list on:**
