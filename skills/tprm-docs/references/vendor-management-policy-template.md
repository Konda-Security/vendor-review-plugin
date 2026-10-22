<!--
Template for /tprm:tprm-docs. Replace every [BRACKETED] value, follow the
comments marked "Remove when...", and delete all comments in the finished draft.
-->
# Vendor Management Policy

**Status:** DRAFT — requires approval by [APPROVER ROLE]
**Owner:** [PROGRAM OWNER ROLE]
**Applies to:** [CLIENT] [and its entities: ENTITY LIST]
**Last updated:** [DATE]

## Purpose

This policy makes sure that third-party vendors and services that handle [CLIENT] data, or connect to [CLIENT] systems, are assessed before use, approved on documented terms, and monitored for as long as they are used.

## Scope

This policy covers every third-party product or service that stores, processes, or can access [CLIENT] data, including client and customer data, or that connects to [CLIENT] systems. That includes software-as-a-service products, cloud infrastructure, managed service providers, contractors with system access, AI tools, browser extensions, and free or trial tools.

## Roles

| Role | Responsibility |
|------|----------------|
| [PROGRAM OWNER ROLE] | Maintains this policy, the approved services list, and the review process |
| [APPROVER ROLE] | Approves, conditions, or denies vendors, and accepts residual risk |
| Internal owner | The employee responsible for each vendor relationship, named at intake |
| All personnel | Use only approved services, and request a review before using anything new |

## Approved Services List

[CLIENT] keeps a list of approved third-party services in `[TRACKER PATH]`. Only services on the list, with a status of Approved or Conditional, may be used for business operations or with [CLIENT] data. The list records, for each vendor, the service, the data it handles, its assurance evidence, the dates of its last and next review, the decision, and the intake request.

<!-- Remove when no entities are configured. -->
Each vendor is tagged with the entity that uses it: [ENTITY DEFINITIONS, e.g., "Parent — used by the parent company and in scope for its audit"]. Vendors used by more than one entity are reviewed once, and the review is referenced in each entity's scope.

<!-- Remove when no flags are configured. One sentence per flag. -->
Vendors that [FLAG MEANING] are flagged in the [FLAG NAME] column and receive the additional review described below.

## Vendor Assessment

Before a new vendor is used:

1. **Request.** The requester submits a vendor review request through [INTAKE CHANNEL], describing the purpose, the data involved, system access, and the internal owner.
2. **Triage.** [PROGRAM OWNER ROLE] triages the request. A vendor that receives no [CLIENT] data, has no access to [CLIENT] systems beyond sign-in, and is not business-critical may be fast-tracked with documented conditions of use.
3. **Assessment.** Every other vendor receives a full assessment covering security posture, privacy practices, compliance and certifications, breach history, AI use, export control and sanctions exposure, financial health, reputation, leadership stability, and transparency. Each area is scored, and the assessment is recorded.
4. **Assurance evidence.** For vendors that handle [CLIENT] data, [PROGRAM OWNER ROLE] requests and reviews the vendor's current SOC 2 Type 2 report or equivalent, including its scope, exceptions, and the complementary user entity controls [CLIENT] must operate. Vendors that can't provide independent assurance need documented risk acceptance by [APPROVER ROLE].
<!-- Remove when no flags are configured. -->
5. **Additional review for flagged vendors.** Vendors flagged as [FLAG NAME] must also show [ADDITIONAL REQUIREMENTS, e.g., data isolation, no use of the data for the vendor's own purposes, breach notification, and return or deletion at the end of the engagement].

## Decisions

Every assessed vendor receives one of these decisions, recorded on the approved services list with the date and a link to the assessment record:

| Decision | Meaning |
|----------|---------|
| Approved | Meets [CLIENT] requirements with no material concerns |
| Conditional | Approved with specific restrictions, which are recorded and must be followed |
| Denied | Unacceptable risk; the reason is recorded and the requester may propose alternatives |

The assessment's recommendation informs the decision but does not make it. When [APPROVER ROLE] decides differently from the recommendation, the reason is recorded.

## Contract Requirements

Agreements with vendors that handle [CLIENT] data must include:

- Data protection obligations appropriate to the data involved
- Breach notification within [BREACH NOTICE PERIOD, e.g., 72 hours]
- The right to review the vendor's security practices or assurance reports
- Disclosure of subprocessors and notice of changes
- Return and deletion of [CLIENT] data when the agreement ends
- A prohibition on using [CLIENT] data to train AI models without written agreement

## AI Tools

AI tools may be used with [CLIENT] data only under an agreement that prohibits training on that data and defines retention. Consumer AI tools may not be used with client, customer, or confidential company data.

## Ongoing Monitoring

- Every approved or conditional vendor is re-reviewed at least every [CADENCE] months, or sooner when its assessment sets an earlier date.
- A vendor is re-reviewed early after a security incident affecting it, a change of ownership, a material change to its terms, or an expansion of how [CLIENT] uses it.
- Re-reviews confirm that conditions are being met, that assurance evidence is current, and that the business need continues.

## Retirement

When a vendor is no longer used, its access is removed, [CLIENT] data is returned or deleted as the agreement requires, and its entry on the approved services list is marked Retired. The entry stays for the audit trail.

## Records

Assessment records are kept in `[REVIEWS PATH]`, and vendor-provided evidence in `[EVIDENCE PATH]`, for at least [RETENTION PERIOD]. Vendor evidence received under a confidentiality agreement is stored outside version control and shared only as that agreement allows.

## Exceptions

Exceptions to this policy require written approval by [APPROVER ROLE], with an expiry date and any compensating controls, recorded on the approved services list.

<!-- Remove when the user doesn't want the mapping table. -->
## Framework Mapping

Verify this mapping against [CLIENT]'s control framework before relying on it.

| Framework | Requirements |
|-----------|--------------|
| SOC 2 Trust Services Criteria | CC9.2 (vendor and business partner risk) |
| NIST SP 800-53 Rev. 5 | SA-4, SA-9, SR-1, SR-2, SR-3, SR-5, SR-6, SR-8 |
| ISO/IEC 27001:2022 Annex A | 5.19, 5.20, 5.21, 5.22, 5.23 |
| NIST CSF 2.0 | GV.SC |

## Review of This Policy

This policy is reviewed at least annually by [PROGRAM OWNER ROLE] and approved by [APPROVER ROLE].
