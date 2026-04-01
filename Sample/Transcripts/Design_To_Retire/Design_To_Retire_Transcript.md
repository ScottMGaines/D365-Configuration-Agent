# Design-to-Retire Discovery Session Transcript
**Client:** Northwind Equipment Manufacturing (Fictional)  
**Process:** Design-to-Retire (D2R)  
**Session Type:** End-to-End Product & Manufacturing Design Workshop  
**Date:** 2026-02-25  
**Duration:** 4 hours  

## Participants

- **Laura Bennett** — VP Operations (Client)
- **Chris Anderson** — Director of Manufacturing Engineering (Client)
- **Nina Patel** — Product Lifecycle Manager (Client)
- **Tom Fischer** — Cost Accounting Manager (Client)
- **Ryan Lee** — D365 Supply Chain Solution Architect (Consultant)
- **Megan Alvarez** — Senior Manufacturing Functional Consultant (Consultant)

---

## Session Introduction

**Ryan (Consultant):**  
Today we’re finalizing Design‑to‑Retire decisions — product structure, engineering change control, manufacturing models, costing, and quality. The goal is to define everything needed to configure D365 Supply Chain without open questions.

**Laura (VP Ops):**  
Yes, we want this locked down so the build team can proceed without revisiting design choices.

---

## Product Information Management (PIM)

### Product Structure

**Megan (Consultant):**  
Let’s start with product structure. What types of products do you manufacture?

**Chris (Manufacturing Eng):**  
We manufacture **configured industrial equipment** using **discrete manufacturing**.

**Nina (PLM):**  
All finished goods are **released products** with:
- Bills of Materials
- Routes
- Product versions

No product variants or configurators in phase one.

---

### Product Dimensions

**Megan:**  
Which product dimensions are required?

**Nina:**  
We use:
- Site
- Warehouse
- Serial number

No batch tracking.

**Ryan:**  
Serial tracking at what level?

**Chris:**  
Serial numbers are tracked **at receipt and issue** for finished goods only.  
Components are not serial‑tracked.

---

### Product Lifecycle State

**Megan:**  
Do you use product lifecycle states?

**Nina:**  
Yes, we will use:
- Pre‑production
- Active
- End‑of‑Life

Lifecycle state controls whether the product can be purchased or produced.

---

## Engineering Change Management (ECM)

**Ryan:**  
Are you using Engineering Change Management?

**Chris:**  
Yes, ECM is **in scope and mandatory**.

**Megan:**  
Change process?

**Chris:**  
- Engineering Change Requests (ECR)
- Engineering Change Orders (ECO)
- Effective dates are used
- No retroactive changes allowed

**Nina:**  
Only released products can be changed via ECO.

---

## Bills of Materials (BOMs)

**Megan:**  
BOM structure?

**Chris:**  
- Multi‑level BOMs
- Phantom BOMs for sub‑assemblies
- Approved vendor list enforced for purchased components

**Ryan:**  
Any co‑products or by‑products?

**Chris:**  
No.

---

## Routes and Operations

**Megan:**  
Routing details?

**Chris:**  
- Standard routes per finished good
- Operations include:
  - Cutting
  - Assembly
  - Testing
- Setup time and run time maintained per operation

**Ryan:**  
Resource model?

**Chris:**  
Resource **groups**, not individual machines, for capacity planning.

---

## Manufacturing Execution and Capacity

**Megan:**  
Manufacturing execution approach?

**Laura:**  
We will **not** use MES in phase one.

**Chris:**  
Capacity is planned at the **resource group** level using finite capacity.

---

## Production Control

**Megan:**  
Production order types?

**Chris:**  
- Production orders only
- No batch orders
- No process manufacturing

**Ryan:**  
Reservation strategy?

**Chris:**  
Components are reserved **at production release**.

---

## Costing and Inventory Valuation

**Tom (Cost Accounting):**  
Costing method is **Standard Cost** for all manufactured items.

**Megan:**  
Cost rollup frequency?

**Tom:**  
Quarterly standard cost rollup with formal approval.

**Ryan:**  
Inventory model group rules?

**Tom:**  
- Physical negative inventory allowed
- Financial negative inventory not allowed

---

## Quality Management

**Megan:**  
Quality management?

**Laura:**  
Yes, fully in scope.

**Chris:**  
- Quality orders at:
  - Purchase receipt
  - Production completion
- Test instruments tracked externally, not in D365

---

## Inventory and Warehouse Integration

**Ryan:**  
Warehouse management?

**Chris:**  
Advanced WMS is **not** in scope.

**Nina:**  
We use basic warehousing only.

---

## Product Retirement

**Megan:**  
How do products get retired?

**Nina:**  
When a product reaches End‑of‑Life:
- No new production orders allowed
- No purchasing allowed
- Inventory can be sold or scrapped

---

## Data Migration (D2R Scope)

**Ryan:**  
What data migrates at go‑live?

**Nina:**  
- Released products
- Active BOMs and routes
- Current standard costs
- Open engineering change orders (if any)

**Chris:**  
No historical production orders migrate.

---

## Cross‑Process Dependencies

**Ryan:**  
Any dependencies on other processes?

**Tom:**  
Chart of accounts and cost accounting structures must be finalized first.

**Laura:**  
Procure‑to‑Pay must support approved vendor lists.

---

## Final Scope Confirmation

**Ryan:**  
Any D2R functionality intentionally deferred?

**Laura:**  
No. Everything discussed is **in scope for phase one**.

**Megan:**  
Great — this is sufficient to fully generate the Design‑to‑Retire implementation workbook.

---

## Session Close

**Ryan:**  
We’ll generate the Design‑to‑Retire implementation plan directly from this session and move into build.

**Laura:**  
Perfect. Let’s proceed.

---
``