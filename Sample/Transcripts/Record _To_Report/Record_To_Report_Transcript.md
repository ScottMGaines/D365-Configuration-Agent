# Record-to-Report Discovery Session Transcript
**Client:** Fabrikam Industrial Services (Fictional)  
**Process:** Record-to-Report (R2R)  
**Session Type:** Detailed Finance Solution Design Workshop  
**Date:** 2026-02-18  
**Duration:** 3 hours  

## Participants

- **Sarah Thompson** — VP Finance (Client)
- **Michael O’Neil** — Corporate Controller (Client)
- **Priya Desai** — Accounting Operations Manager (Client)
- **Daniel Wu** — D365 Finance Solution Architect (Consultant)
- **Emma Rodriguez** — Senior Functional Consultant (Consultant)

---

## Session Introduction

**Daniel (Consultant):**  
Today we’re going to finalize Record‑to‑Report design decisions so we can directly drive Dynamics 365 Finance configuration. We’ll be specific — codes, rules, and behaviors — not just policies.

**Sarah (VP Finance):**  
That’s exactly what we want. We’re trying to avoid reopening these decisions later.

---

## Legal Entities and Global Structure

**Daniel:**  
Let’s confirm legal entities in scope.

**Michael (Controller):**  
We have four legal entities:
- USMF — United States
- USSE — United States (Services)
- DEMF — Germany
- GBMF — United Kingdom

All four will be live on day one.

**Emma:**  
Is there a designated master company?

**Michael:**  
Yes, USMF is the master legal entity.

---

## Chart of Accounts Design

**Emma:**  
Can you walk us through the chart of accounts?

**Michael:**  
We’re using a **single global chart of accounts** shared by all four entities.

- Main accounts are **7 digits**
- Range structure:
  - 1000000–1999999 Assets  
  - 2000000–2999999 Liabilities  
  - 3000000–3999999 Equity  
  - 4000000–4999999 Revenue  
  - 5000000–5999999 Cost of Sales  
  - 6000000–6999999 Operating Expenses  

**Daniel:**  
No segmented account string?

**Michael:**  
Correct. We rely entirely on financial dimensions.

---

## Financial Dimensions

**Emma:**  
Please confirm the financial dimensions and how they’re used.

**Priya (Accounting Ops):**  
We will use **four financial dimensions**:

1. Department  
2. Cost Center  
3. Business Unit  
4. Project (for internal capital tracking only)

**Emma:**  
Mandatory rules?

**Priya:**  
- Department and Cost Center are **mandatory for all P&L accounts**
- Optional for balance sheet accounts
- Business Unit is optional everywhere
- Project is optional and only used for specific journal types

**Daniel:**  
Rough volumes?

**Priya:**  
- Departments: 32  
- Cost Centers: 78  
- Business Units: 6  

---

## Fiscal Calendar and Period Management

**Emma:**  
Fiscal calendar details?

**Michael:**  
Calendar fiscal year, January to December.  
Monthly periods — 12 periods plus period 13 for audit adjustments.

**Daniel:**  
Period reopen behavior?

**Michael:**  
Closed periods can only be reopened by users in the “Finance Manager” role.

---

## Posting Profiles and Subledger Integration

**Emma:**  
AP and AR posting setup?

**Priya:**  
- Separate posting profiles by **Vendor Group** and **Customer Group**
- One control account per group
- All subledgers post to summary accounts, not detail

**Daniel:**  
Any reason not to use summary posting?

**Michael:**  
No — that’s our standard.

---

## Currencies and Exchange Rates

**Emma:**  
Currencies in scope?

**Michael:**  
- USMF and USSE: USD  
- DEMF: EUR  
- GBMF: GBP  

**Priya:**  
We revalue foreign currency balances **monthly at month‑end** using closing rates.

**Daniel:**  
Exchange rate providers?

**Michael:**  
ECB rates, manually imported monthly.

---

## Intercompany Accounting

**Emma:**  
Intercompany setup?

**Michael:**  
We want **full intercompany accounting enabled** in D365.

- Automated intercompany AP/AR
- Due‑to / Due‑from accounts per entity pair
- Elimination handled outside of D365 (in consolidation tool)

---

## General Ledger Journals

**Emma:**  
Journal framework?

**Priya:**  
We will use:
- General journals
- Accrual journals
- Allocation journals
- Intercompany journals

**Daniel:**  
Automated allocations?

**Priya:**  
Yes. Monthly overhead allocation based on headcount percentages stored externally and loaded as allocation bases.

---

## Financial Period Close

**Emma:**  
Close process expectations?

**Sarah (VP Finance):**  
- Target close: **4 business days**
- Use **D365 Financial Period Close Workspace**
- Formal checklist with task ownership and dependencies

**Michael:**  
AP closes first, then AR, then GL.

---

## Financial Reporting

**Emma:**  
Reporting tool?

**Michael:**  
Dynamics 365 Financial Reporting only.

**Sarah:**  
Required reports at go‑live:
- Balance Sheet
- Income Statement
- Department P&L
- Cash Flow Statement

---

## Audit, Compliance, and Controls

**Emma:**  
Audit requirements?

**Michael:**  
- Annual external audit
- SOX‑aligned internal controls (even though we’re private)

**Priya:**  
Segregation of duties will be enforced using D365 security roles — no custom approach.

---

## Data Migration (R2R Scope)

**Daniel:**  
GL data migration expectations?

**Michael:**  
- Opening balances only
- No historical transactions
- Dimensions must be fully validated before load

---

## Final Confirmation

**Daniel:**  
Anything intentionally deferred to a later phase?

**Sarah:**  
No. Everything we discussed today is in scope for phase one.

**Emma:**  
Great — this gives us everything we need to complete the R2R implementation workbook without open questions.

---

## Session Close

**Daniel:**  
We’ll generate the Record‑to‑Report implementation workbook directly from this session and proceed to configuration.

**Sarah:**  
Perfect. Let’s move forward.

---
``