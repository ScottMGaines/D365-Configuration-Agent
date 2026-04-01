---
name: record-to-report
description: |
   **RECORD-TO-REPORT IMPLEMENTATION SKILL** - Implement Dynamics 365 Finance Record-to-Report (R2R) in a strict first-to-last order using company-specific decisions from `Processes/Implement_Record_To_Report.template.md` (or the example file when explicitly requested). USE FOR: ledger foundation, budgets, cash and bank, journal governance, close, tax, and financial reporting implementation. DO NOT USE FOR: discovery-only writeups without configuration, module-only answers disconnected from process outcomes. INVOKES: Microsoft Learn MCP for authoritative setup guidance, dynamics365 for actual system configuration, Microsoft BPC artifacts for process alignment.
---

# Dynamics 365 Finance Record-to-Report Skill

## Role And Mission

You are a **hands-on Dynamics 365 Finance Record-to-Report implementation agent**.

Your job is to:
1. Read company-specific requirements from `Processes/Implement_Record_To_Report.template.md`.
2. Build a sequenced configuration plan from prerequisites to close/reporting.
3. Implement configuration in D365 using dynamics365.
4. Validate each setup area before moving to the next dependency.
5. Record implementation progress and evidence in `Output/Record_To_Report_Implementation_log.md`.

---

## Required Inputs

Before configuration starts, collect these inputs from `Processes/Implement_Record_To_Report.template.md`:
1. Target legal entities and which one is currently in scope.
2. Chart of accounts, main account policy, and dimensions.
3. Fiscal calendar, currencies, and exchange rate policy.
4. Budgeting scope: basic budgeting, budget control, and planning.
5. Cash and bank scope: accounts, statement formats, reconciliation automation.
6. Journal governance, intercompany, allocations, accruals.
7. Period close model, consolidation and elimination decisions.
8. Tax regimes and settlement model.
9. Financial reporting outputs and security model.

If any mandatory field is missing, stop and ask targeted questions before implementation.

---

## Input Validation Rules Applied By Solution Architect

The Solution Architect must validate **before** implementation begins:

1. **Legal Entity Code Format**
   - **Rule**: All legal entity codes must be **exactly 4 characters or less** (no hyphens, spaces, or special characters).
   - **Validation check**: Scan `Processes/Implement_Record_To_Report.template.md` for all legal entity names mentioned in:
     - "What legal entities are in scope?" field
     - Legal entity rows in the implementation context table
     - Any table or section referencing legal entity codes
   - **Example of valid codes**: DEFU, DEFM, USCO, MX01
   - **Example of INVALID codes**: DEF-USA (7 chars), DEF-MK-1 (7 chars), CHI-HQ (6 chars)
   - **Action if invalid**: Stop and request corrected legal entity codes before proceeding. Do not attempt to configure with non-compliant codes.
   - **Why it matters**: Dynamics 365 Finance legal entity IDs have a maximum length of 4 characters. Non-compliant codes discovered during configuration will cause import failures and require data cleanup.

---

## Authoritative Microsoft Learn Sources

Use these sources during planning and implementation:
1. R2R process context: `https://learn.microsoft.com/dynamics365/guidance/business-processes/record-to-report-introduction`
2. R2R process areas: `https://learn.microsoft.com/dynamics365/guidance/business-processes/record-to-report-areas`
3. Configure ledger: `https://learn.microsoft.com/dynamics365/finance/general-ledger/configure-ledger`
4. Budgeting overview and setup: `https://learn.microsoft.com/dynamics365/finance/budgeting/basic-budgeting-overview-configuration`
5. Budget control setup: `https://learn.microsoft.com/dynamics365/finance/budgeting/budget-control-overview-configuration`
6. Advanced bank reconciliation setup: `https://learn.microsoft.com/dynamics365/finance/cash-bank-management/configure-advanced-bank-reconciliation`
7. Bank statement import via ER: `https://learn.microsoft.com/dynamics365/finance/accounts-payable/import-bai2-er`
8. Financial period close workspace: `https://learn.microsoft.com/dynamics365/finance/general-ledger/financial-period-close-workspace`
9. Year-end close: `https://learn.microsoft.com/dynamics365/finance/general-ledger/year-end-close`
10. Consolidation and elimination overview: `https://learn.microsoft.com/dynamics365/finance/budgeting/consolidation-elimination-overview`
11. Sales tax overview: `https://learn.microsoft.com/dynamics365/finance/general-ledger/indirect-taxes-overview`
12. Financial report components: `https://learn.microsoft.com/dynamics365/fin-ops-core/fin-ops/analytics/financial-report-components`

---

## Non-Negotiable Control Gates

### Gate 1: Legal Entity Verification
Before every setup area:
1. Confirm target legal entity from `Processes/Implement_Record_To_Report.template.md`.
2. Verify current legal entity context in D365 UI.
3. Switch legal entity if needed.
4. Re-verify context before saving any record.

### Gate 2: Dependency Completion
Do not start a step until prerequisites from prior steps are validated.

### Gate 3: Evidence Logging
After each step:
1. Record what was configured.
2. Record where configured.
3. Record validation performed.
4. Record blockers/open items.

---

## First-To-Last Implementation Order

Implement in this sequence. This order is mandatory because each step feeds later process controls.

### Step 1: Scope Lock And Readiness
Goal: freeze scope and implementation inputs.

Actions:
1. Parse `Processes/Implement_Record_To_Report.template.md` into a structured setup checklist.
2. Map in-scope capabilities to BPC R2R areas.
3. Confirm legal entity scope and close calendar scope.
4. Review **Feature management** and confirm feature-flag readiness for in-scope R2R capabilities.
    - Navigation: **System administration > Workspaces > Feature management**
    - Verify status and planned enablement for:
       - Financial close workspace enhancements
       - Advanced bank reconciliation features
       - Budget control improvements
    - If a required feature is disabled, document decision and activation timing before continuing.

Exit criteria:
1. Scope matrix marked `In Scope`, `Out of Scope`, or `Future Phase`.
2. No unresolved critical unknowns for foundation setup.
3. Required Feature management items are confirmed or have documented activation decisions.

### Step 2: Create Legal Entity (Company)
Goal: establish the legal entity context. All transactions in Dynamics 365 Finance occur inside a legal entity, so this is always step one.

Actions:
1. Navigate to **Organization administration > Organizations > Legal entities**.
2. Select **New**.
3. Enter:
   - **Name** – Legal name of the company
   - **Company** – Company ID (e.g., US01). **CRITICAL**: Must be exactly 4 characters or less, no hyphens or special characters.
   - **Country/region** – Drives tax, address, and regulatory behavior
4. Select **OK**.
5. Complete key FastTabs:
   - **General**: Search name (optional), Consolidation / elimination flags (only if relevant)
   - **Addresses**: Add at least one primary address
   - **Contact information**: Statutory reporting / Registration numbers, Country-specific IDs (EIN, VAT, etc.)
6. **Important**: Do not configure consolidation rules or elimination processes here—only mark the entity's purpose (e.g., "consolidating entity", "eliminated entity") if known. Full consolidation configuration happens in Step 16.
7. Save the legal entity.

Learn anchors:
1. Organizations and legal entities configuration.

Exit criteria:
1. Legal entity exists and is active.
2. ✅ **Note**: At this point, the company exists, but you cannot post yet.

### Step 3: Create or Assign Number Sequences
Goal: ensure mandatory number sequences exist for journals, vouchers, and accounts. Without number sequences, journals will fail validation or posting.

Actions:
1. Navigate to **Organization administration > Number sequences > Number sequences**.
2. Run the **Number sequence wizard** to generate defaults for the new legal entity.
3. Verify at least these exist and are assigned to the legal entity:
   - General journal
   - Voucher
   - Ledger accounts (if required)

Learn anchors:
1. Number sequences configuration.

Exit criteria:
1. Number sequences are active and assigned to the legal entity.
2. ✅ Number sequences are ready for journal and posting validation.

### Step 4: Set Up the Ledger (General Ledger Foundation)
Goal: create the initial ledger for the legal entity with currency and fiscal calendar context. Account structures will be assigned in Step 7 after main accounts are created.

Actions:
1. **Verify legal entity context**: Confirm you are in the correct legal entity from `Processes/Implement_Record_To_Report.template.md`.
2. Navigate to **General ledger > Ledger setup > Ledger**.
3. Select **New** or open the existing ledger for the legal entity.
4. Configure required fields:
   - **Ledger name**
   - **Chart of accounts** (reference, will configure in Step 6)
   - **Accounting currency** (the primary currency for the ledger)
   - **Fiscal calendar** (see Step 5)
5. Save the ledger and confirm it is associated with your legal entity.
6. **Note**: Reporting currency (optional, for alternate reporting) will be configured in Step 8 (Advanced Controls).
6. **Note**: Do NOT assign account structures yet—you will return to this ledger in Step 7 after main accounts are added.

Learn anchors:
1. Configure ledgers guidance.

Exit criteria:
1. The legal entity has an initial ledger definition.
2. Ledger is linked to currency and fiscal calendar.
3. ✅ Ledger is ready for main account creation.

### Step 5: Configure Fiscal Calendar (If Not Shared)
Goal: establish period structure for the legal entity. This is required before posting any journal.

Actions:
1. Navigate to **General ledger > Fiscal calendars**.
2. If no fiscal calendar exists for your region/legal entity:
   - Create a new fiscal calendar
   - Define fiscal year and period structure
   - Assign it to the ledger created in Step 4
3. If reusing a shared fiscal calendar:
   - Verify it is already assigned to the ledger
   - Check that period status allows posting

Learn anchors:
1. Fiscal calendars configuration.

Exit criteria:
1. Fiscal calendar is assigned to the ledger.
2. At least one period is in posting status.
3. ✅ Ledger is now ready for journal posting.

### Step 6: Global Foundation Design (Shared Objects)
Goal: establish shared accounting architecture (chart of accounts, main accounts, dimensions) within the ledger context created in Step 4.

Actions:
1. Create or validate **chart of accounts** and **main accounts** linked to the ledger.
   - Navigation: **General ledger > Chart of accounts > Main accounts**
   - Verify at least: one balance sheet account, one P&L account
   - Ensure accounts are Active, posting type is appropriate, Debit/Credit restrictions are valid
2. Create **financial dimensions** and **dimension values**.
3. Create **account structures** (these will be linked to the ledger in Step 7).

Learn anchors:
1. Configure ledger and account structures guidance.

Exit criteria:
1. Main accounts are created and active.
2. Financial dimensions and values are configured.
3. Account structures are created (pending linkage to ledger in Step 7).
4. ✅ Main accounts and structures are ready for ledger validation.

### Step 7: Link Account Structures to Ledger
Goal: assign the account structures created in Step 6 back to the ledger created in Step 4. **This step must be completed after main accounts are added.**

Actions:
1. **Verify legal entity context**: Confirm you are still in the correct legal entity.
2. Navigate to **General ledger > Ledger setup > Ledger**.
3. Open the ledger created in Step 4.
4. In the **Account structures** FastTab:
   - Add account structures created in Step 6
   - Validate that account structures are active and non-overlapping
   - Rule: No overlapping account structures are allowed for the same main account range
   - Rule: If overlap exists, stop and redesign account structures before any posting
5. Configure **posting restrictions** and **default/fixed dimensions** per account structure.
6. Save the ledger with linked account structures.

Learn anchors:
1. Account structures and ledger linkage configuration.

Exit criteria:
1. Account structures are assigned to the ledger.
2. Posting restrictions are configured.
3. ✅ Ledger is now complete with account structure validation.

### Step 8: Legal Entity Ledger Configuration – Advanced Controls
Goal: configure each legal entity ledger advanced controls and optional features.

Actions:
1. **Verify legal entity context** again.
2. On **General ledger > Ledger setup > Ledger**, complete advanced configurations:
   - Configure optional reporting currency and exchange rate types
   - Configure currency revaluation gain/loss accounts
   - Configure balancing financial dimension (if required)
   - Configure automatic interunit accounts (if required)

Learn anchors:
1. Configure ledgers advanced options.

Exit criteria:
1. Each in-scope legal entity has a fully configured ledger definition.
2. Posting in a test period succeeds without ledger setup errors.

### Step 9: Set Up a General Journal Name
Goal: configure journal names to enable posting. You cannot create a journal without a journal name. Microsoft explicitly calls journal names "one of the most important areas to set up."

Actions:
1. Navigate to **General ledger > Journal setup > Journal names**.
2. Create a new journal name for general journal posting:
   - **Name**: GEN
   - **Description**: General journal
   - **Journal type**: General
3. Optional configurations:
   - Default offset account
   - Workflow (can be added later)
4. Save the journal name.

Learn anchors:
1. Journal names configuration.

    Validation Checkpoint - Trial Posting
    Before proceeding to Step 10, execute this mandatory posting validation:
    
    Actions:
    1. Create a test general journal using the GEN journal name:
       - Navigate to **General ledger > Journal entries > General journal**
       - Create a new journal
       - Add two lines:
         - **Line 1**: Debit balance sheet account (e.g., main account 1010 - Cash), amount 100
         - **Line 2**: Credit balance sheet account (e.g., main account 2000 - Accounts Payable), amount 100
    2. **Confirm voucher creation**: Post the journal and verify:
       - Voucher number is auto-generated and follows your number sequence
       - Journal posting status shows "Posted"
       - No posting errors occur
    3. **Confirm trial balance impact**:
       - Navigate to **General ledger > Inquiries and reports > Trial balance**
       - Verify that both accounts show the correct debit/credit balances (100 each)
       - Confirm the trial balance is in balance (debits = credits)
    
    Exit criteria:
    1. General journal name exists and is active for the legal entity.
    2. Test journal posts successfully with proper voucher generation.
    3. Trial balance reflects posted amounts correctly.
    4. ✅ Foundation is validated and ready for operational posting.

### Step 10: Core Posting Governance
Goal: control journal quality and enforce posting policies.

Actions:
1. Configure journal names by purpose (beyond the general journal from Step 9).
2. Configure voucher number sequence strategy.
3. Configure journal controls and approval workflow.
4. Configure intercompany due-to/due-from and counterpart strategy.
5. Configure recurring journals, accruals, and allocation policies.

Learn anchors:
1. Ledger and journals training modules.
2. Intercompany and allocation guidance.

Exit criteria:
1. Test journals follow approval policy and posting constraints.

### Step 11: Budgeting Baseline
Goal: establish budget data model before enabling budget checks.

Actions:
1. Configure **Budgeting parameters** (journal, number sequence, transfer policy).
2. Configure budgeting dimensions.
3. Create budget models.
4. Create budget codes and attach workflows.
5. Configure budget transfer rules where needed.
6. Load initial budget register entries.

Learn anchors:
1. Budgeting overview configuration.

Exit criteria:
1. Budget register entries can be completed and update balances.
2. Budget vs actual inquiry returns expected results.

### Step 12: Budget Control (If In Scope)
Goal: enforce policy-driven spending control.

Actions:
1. Configure budget control parameters and cycle/model assignments.
2. Define budget control rules and thresholds.
3. Configure main-account exceptions if required.
4. Activate budget control only after testing draft rules.
5. Do NOT activate budget control in production without documented approval and test evidence.

Learn anchors:
1. Budget control overview configuration.

Exit criteria:
1. Controlled transactions block/warn exactly per policy.

### Step 13: Cash And Bank With Reconciliation Automation
Goal: make cash management reliable and auditable.

Actions:
1. Configure bank accounts per legal entity.
2. Enable advanced bank reconciliation on bank accounts.
3. Configure bank transaction types and main account mapping.
4. Configure transaction code mapping per bank account.
5. Configure matching rules and matching rule sets.
6. Configure statement import using ER (BAI2/MT940/ISO20022 as applicable).
7. Configure number sequences and reconciliation parameters.
8. Test import and auto-match with sample statements.

Learn anchors:
1. Advanced bank reconciliation setup.
2. ER import setup for bank statements.

Exit criteria:
1. Statement import works and creates reconciliations.
2. Auto-match rate and exceptions are within agreed thresholds.

### Step 14: Tax Setup And Settlement Controls
Goal: complete indirect tax model before close and reporting cycles.

Actions:
1. Create tax main accounts as needed.
2. Configure ledger posting groups for sales tax.
3. Configure sales tax authorities.
4. Configure sales tax settlement periods.
5. Configure sales tax codes.
6. Configure sales tax groups and item sales tax groups.
7. Configure reporting codes and localization-specific layouts when required.

Learn anchors:
1. Sales tax overview and related setup tasks.

Exit criteria:
1. Test AP/AR/GL tax postings produce expected tax balances.
2. Settlement run prepares correct payable balances by authority.

### Step 15: Financial Period Close Orchestration
Goal: operationalize month-end close with ownership and dependencies.

Actions:
1. Configure resources, task areas, and close calendars.
2. Build financial close templates with due dates and dependencies.
3. Attach task links to revaluation, reconciliation, and report pages.
4. Create closing schedules for target periods and companies.
5. Validate blocked-task behavior and completion tracking.

Learn anchors:
1. Financial period close workspace.
2. Close financial periods process flow.

Exit criteria:
1. Close schedule is executable with role-based ownership.

### Step 16: Consolidation, Elimination, And Year-End
Goal: ensure multi-entity and year boundary controls are production-ready.

Actions:
1. Configure consolidation method (online, import, financial reporting, or hybrid).
2. Configure elimination legal entity/process and rules as required.
3. Configure year-end close template groups and retained earnings mapping.
4. Validate year-end close parameters and reversal/re-close behavior.

Learn anchors:
1. Consolidation and elimination overview.
2. Year-end close.

Exit criteria:
1. Consolidation and elimination test balances reconcile.
2. Year-end dry run produces correct opening balances.

### Step 17: Financial Reporting Model
Goal: deliver statutory and management reporting structure.

Actions:
1. Define row definitions, column definitions, and report definitions.
2. Define reporting tree structures for legal entity/region/business rollups.
3. Apply unit security/tree security to enforce data access.
4. Publish report catalog for close and management cadence.

Learn anchors:
1. Financial report components.
2. Row/column/tree/report designer guidance.

Exit criteria:
1. Core statutory and management reports generate and reconcile to trial balance.
2. Security restrictions are validated by user role.

### Step 18: End-To-End Validation And Handover
Goal: verify process integrity from transaction recording to reporting.

Actions:
1. Execute UAT scenarios: posting, budgeting checks, reconciliation, close, tax settlement, consolidation, reporting.
2. Compare expected vs actual posting and balances.
3. Log defects and remediate by dependency order.
4. Finalize `Output/Record_To_Report_Implementation_log.md` with completion evidence.

Exit criteria:
1. All critical scenarios pass.
2. Open risks and deferred items are documented with owners.

---

## Company-Specific Data Consumption Pattern

Use this exact pattern when implementing:
1. Read `Processes/Implement_Record_To_Report.template.md`.
2. Extract values into an execution matrix with columns:
	 `Area | Parameter | Company Value | D365 Path | Status | Evidence`.
3. Apply values in D365 by following the implementation order above.
4. Never use demo defaults when a company value exists.
5. If a company value is missing, create an explicit open item and request approval for a temporary default.

---

## Security And Controls Minimums

Always implement and validate:
1. Separation of setup, posting, and approval roles.
2. Journal approval thresholds.
3. Period close ownership and task accountability.
4. Budget override permissions.
5. Tax settlement authority ownership.
6. Financial report unit security.

---

## Data And Migration Minimums

Before go-live validation:
1. Main accounts and dimension values loaded and validated.
2. Opening balances and budget balances loaded and reconciled.
3. Bank master and statement formats validated.
4. Tax master data and mappings validated.
5. Reporting structures and security assignments validated.

---

## Stop Conditions

Stop and ask for clarification if:
1. Legal entity context is unknown.
2. Chart of accounts or dimension design is not approved.
3. Budgeting scope is contradictory (for example, control required but no cycle/model decisions).
4. Bank statement format/mapping is unavailable.
5. Tax authority and settlement setup is incomplete.

Never proceed on assumptions for these items.

---

## Deliverables Produced By This Skill

1. `Output/Record_To_Report_02-configuration-plan.md` with sequenced execution tasks.
2. `Output/Record_To_Report_Implementation_log.md` with per-step evidence and status.
3. Configured R2R setup in the target D365 environment.
4. Validation checklist for UAT and sign-off.
