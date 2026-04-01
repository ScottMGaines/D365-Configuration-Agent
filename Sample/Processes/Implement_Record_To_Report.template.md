# Dynamics 365 Finance & Supply Chain Record-to-Report Implementation Discovery Workbook

This workbook captures the discovery decisions required to implement the Record-to-Report (R2R) process in Dynamics 365 Finance and Supply Chain. It is designed to become the authoritative implementation source for build configuration, data migration readiness, validation execution, and build-agent handoff.

Execution mode: Evidence-Filled Mode

Test data status: Test values applied on 2026-03-31 for dry-run validation.

This template is based on three authoritative sources:
1. Microsoft Business Process Catalog (BPC), including the R2R end-to-end process context and process areas.
2. Microsoft Learn guidance for Dynamics 365 Finance configuration, controls, and operational procedures.
3. Transcript evidence from the Record-to-Report discovery workshop dated 2026-02-18.

## Process Context

### Why This Process Exists

Based on Microsoft BPC R2R context and process area descriptions, this process exists to:

- Establish a consistent accounting framework across legal entities and operations.
- Record financial activity accurately with integrated subledger-to-ledger posting controls.
- Maintain cash visibility and govern currency exposure.
- Plan and control spending against approved budgets and policy.
- Execute structured, auditable period-end close activities.
- Produce timely statutory and management financial statements.
- Support regulatory and audit requirements through traceable controls.

### BPC Process Areas Covered

1. Define accounting policies
2. Manage cash
3. Manage budgets
4. Record financial transactions
5. Close financial periods
6. Analyze financial performance

### BPC Scope Notes And Clarifications

- R2R process scope includes all six process areas listed above.
- Subledger source processes (for example, Procure-to-Pay and Order-to-Cash) remain out of direct scope, but their postings are in-scope dependencies for R2R.
- Intercompany eliminations are explicitly out of D365 execution scope and handled in an external consolidation tool.

## Configuration Summary

1. Legal-entity accounting model: Four legal entities in scope (USMF, USSE, DEMF, GBMF) with USMF as master legal entity.
2. Ledger foundation: Single global chart of accounts shared by all entities, 7-digit main account framework.
3. Dimension model: Department, Cost Center, Business Unit, and Project dimensions, with explicit mandatory rules for P&L.
4. Period and close controls: Calendar fiscal year, 12 monthly periods plus period 13, controlled period reopening, and close orchestration in Financial period close workspace.
5. Subledger integration: AP and AR posting profiles by group with summary posting model and control-account mapping.
6. Currency governance: USD, EUR, GBP accounting currencies by legal entity with monthly closing-rate revaluation and ECB monthly import.
7. Intercompany accounting: Automated intercompany AP/AR with due-to and due-from accounts by entity pair.
8. Journal governance: General, accrual, allocation, and intercompany journals, including monthly overhead allocation processing.
9. Financial reporting: Dynamics 365 Financial Reporting as the only reporting platform at go-live.
10. Control framework: SOX-aligned controls, annual external audit support, and role-based segregation of duties.

## Data Import Plan

### Import Register

| # | Record type | D365 Data Entity | Source system | Est. volume | Import owner | Priority |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Main accounts | MainAccountEntity | Legacy ERP / finance master | TBC | Finance Master Data Lead | Foundation |
| 2 | Financial dimension values | TBC (verify in DMF entity catalog) | Legacy ERP / reference data files | Department: 32; Cost Center: 78; Business Unit: 6; Project: TBC | Finance Master Data Lead | Foundation |
| 3 | Exchange rates | TBC (verify in DMF entity catalog) | ECB monthly rate file | Monthly | Treasury Lead | Build |
| 4 | Bank accounts | TBC (verify in DMF entity catalog) | Treasury banking register | TBC | Treasury Lead | Build |
| 5 | Budget account entries | Budget Account Entries data entity | Planning model / budgeting workbook | TBC | FP&A Lead | Build |
| 6 | Opening balance journals | TBC (General journal import entity) | Legacy trial balance cutover files | Opening balances only | GL Lead | Build |
| 7 | Intercompany due-to/due-from mapping | TBC (verify in DMF entity catalog) | Intercompany matrix | 12 entity pairs | Controller Team | Build |

### Import Sequencing

1. Import #1 main accounts before account structures and posting validations are finalized.
2. Import #2 financial dimension values before account structures and validation rules are activated.
3. Configure and validate ledger, dimensions, account structures, and posting controls before transactional cutover loads.
4. Import #3 exchange rates and Import #4 bank accounts before monthly revaluation and treasury validation.
5. Import #5 budget account entries after budget model and budget control decisions are finalized.
6. Import #7 intercompany mapping before intercompany journal testing.
7. Import #6 opening balances after dimension validation and cutover reconciliation sign-off.
8. No historical transactions are loaded as part of R2R migration scope.

### Data Readiness Checklist

| Check | Owner | Status |
| --- | --- | --- |
| Source-to-target field mapping approved for each import row | Data Migration Lead | TBC |
| Legal entity ownership confirmed for each import row | Finance Program Manager | Complete |
| Dimension values validated before opening-balance load | Finance Master Data Lead | In Progress |
| Intercompany entity-pair matrix approved | Controller Team | TBC |
| Exchange rate source and import procedure approved | Treasury Lead | Complete |
| Opening balance reconciliation template approved | GL Lead | TBC |
| Trial import executed for main accounts and dimensions | Data Migration Lead | TBC |

## How To Use This Workbook

1. Consultant and process owner review each section together.
2. Confirm Process Scope Decision statuses before build starts.
3. Use detailed section responses as the single source of truth for build configuration.
4. Leave unresolved items as TBC and track them in Open Items.
5. Do not bypass unresolved items when they affect setup sequence, data templates, or controls.
6. On completion, trigger the build agent. The build agent auto-populates the Agent Handoff Payload YAML block at the bottom of this file. Do not fill in the YAML manually.

Status values: In Scope / Out of Scope / Future Phase / Unknown

## Company Profile And Scope

### 6a. Implementation Context

| Field | Response |
| --- | --- |
| Company legal name | Fabrikam Industrial Services (Fictional) |
| Countries/regions in scope | United States, Germany, United Kingdom |
| Number of legal entities in scope | 4 |
| Primary industry and business model | Industrial services (exact industry classification TBC) |
| Go-live date target | TBC |
| Legacy systems replaced | TBC |
| Regulatory/compliance frameworks applicable | SOX-aligned internal controls; annual external audit |
| External reporting obligations | Balance Sheet, Income Statement, Department P&L, Cash Flow Statement |

### 6b. Process Scope Decision

| Process area | Sub-area | Status | Owner | Notes |
| --- | --- | --- | --- | --- |
| Define accounting policies | Define legal entity accounting policy model | In Scope | Corporate Controller | Four entities, USMF master |
| Define accounting policies | Define chart of accounts governance | In Scope | Corporate Controller | Single shared global CoA |
| Define accounting policies | Define dimensions and account structures | In Scope | Accounting Operations Manager | Four dimensions with mandatory rules |
| Define accounting policies | Define fiscal calendar and period strategy | In Scope | Corporate Controller | Calendar year, 12+1 periods |
| Manage cash | Define bank account governance | In Scope | Treasury Lead | Detailed bank master decisions TBC |
| Manage cash | Define bank reconciliation operating model | In Scope | Treasury Lead | Detailed reconciliation model TBC |
| Manage cash | Define cash forecasting setup and ownership | In Scope | Treasury Lead | Cash forecasting detail TBC |
| Manage budgets | Define basic budgeting model | In Scope | FP&A Lead | Detailed budget model decisions TBC |
| Manage budgets | Define budget control rules and thresholds | In Scope | FP&A Lead | Thresholds and override policy TBC |
| Manage budgets | Define budget planning process and workflow | In Scope | FP&A Lead | Planning workflow details TBC |
| Record financial transactions | Define journal governance model | In Scope | Accounting Operations Manager | 4 journal families confirmed |
| Record financial transactions | Define accrual, deferral, and allocation patterns | In Scope | Accounting Operations Manager | Monthly overhead allocation confirmed |
| Record financial transactions | Define correction, reversal, and approval controls | In Scope | Finance Manager | Control details partially defined |
| Close financial periods | Define close task orchestration model | In Scope | VP Finance | 4-day close, AP->AR->GL |
| Close financial periods | Define revaluation and settlement sequence | In Scope | Corporate Controller | Monthly revaluation confirmed |
| Close financial periods | Define year-end close template and rerun policy | In Scope | Corporate Controller | Audit adjustment handling partially defined |
| Analyze financial performance | Define financial reporting architecture | In Scope | VP Finance | Financial Reporting only |
| Analyze financial performance | Define budget vs actual analysis model | In Scope | FP&A Lead | Specific model/thresholds TBC |
| Analyze financial performance | Define report distribution and evidence controls | In Scope | VP Finance | Distribution controls TBC |

## Detailed Configuration Guidance And Discovery Questions

Response format rules for all sections:
- Use single-line responses for scalar values.
- If a response needs multiple records, use a dedicated table directly under the question.
- Leave unknown values as TBC.

## A. Define Accounting Policies

### A1. Legal Entities, Ledger Ownership, And Accounting Policy Model

This domain defines legal-entity boundaries, ledger ownership, intercompany policy, and accounting policy standardization strategy.

| Question | Response |
| --- | --- |
| Which legal entities are in scope for R2R go-live? | USMF, USSE, DEMF, GBMF |
| Which legal entity is the master owner for accounting policy governance? | USMF |
| Is chart of accounts shared across legal entities (Yes/No)? | Yes |
| Is intercompany accounting required at go-live (Yes/No)? | Yes |
| Are centralized payments or centralized treasury required (Yes/No)? | Yes |

Question: List all legal entities in scope with operating details.

**Legal Entities Register**

| Legal Entity | Company Name | Country/Region | Operating Unit Type | Base Currency | Fiscal Calendar | Status |
| --- | --- | --- | --- | --- | --- | --- |
| USMF | Fabrikam Industrial Services - US | United States | Operating company | USD | Calendar year (Jan-Dec, 12+1) | In Scope |
| USSE | Fabrikam Industrial Services - US Services | United States | Operating company | USD | Calendar year (Jan-Dec, 12+1) | In Scope |
| DEMF | Fabrikam Industrial Services - Germany | Germany | Operating company | EUR | Calendar year (Jan-Dec, 12+1) | In Scope |
| GBMF | Fabrikam Industrial Services - UK | United Kingdom | Operating company | GBP | Calendar year (Jan-Dec, 12+1) | In Scope |

### A2. Chart Of Accounts, Main Accounts, And Posting Restrictions

This domain defines account taxonomy, categories, and posting governance.

> Data Import Required: Main accounts are high-volume and must be loaded via DMF - see Data Import Plan -> Import #1.

| Question | Response |
| --- | --- |
| What chart of accounts ID will be used? | FAB-GL |
| Will legal entities share one chart of accounts (Yes/No)? | Yes |
| Are account number ranges reserved by category (Yes/No)? | Yes |
| Are manual-entry restrictions required for specific categories (Yes/No)? | Yes |
| Are default or fixed dimensions required by account range (Yes/No)? | Yes |

Question: Define account category and posting-policy rules.

**Main Account Policy Register**

| Account Range | Category | Manual Entry Allowed (Y/N) | Default Dimension Rule | Fixed Dimension Rule | Notes |
| --- | --- | --- | --- | --- | --- |
| 1000000-1999999 | Assets | N | Optional | None | 7-digit account format |
| 2000000-2999999 | Liabilities | N | Optional | None | 7-digit account format |
| 3000000-3999999 | Equity | N | Optional | None | 7-digit account format |
| 4000000-4999999 | Revenue | Y | Department + Cost Center mandatory | Department, Cost Center | P&L mandatory dimensions |
| 5000000-5999999 | Cost of Sales | Y | Department + Cost Center mandatory | Department, Cost Center | P&L mandatory dimensions |
| 6000000-6999999 | Operating Expenses | Y | Department + Cost Center mandatory | Department, Cost Center | P&L mandatory dimensions |

### A3. Financial Dimensions, Account Structures, And Period/Currency Controls

This domain defines analytical segmentation, valid posting combinations, and calendar/currency controls.

> Data Import Required: Financial dimension values are typically high-volume and must be loaded via DMF - see Data Import Plan -> Import #2.

| Question | Response |
| --- | --- |
| Which financial dimensions are required at go-live? | Department, Cost Center, Business Unit, Project |
| Is a balancing dimension required (Yes/No)? | Yes (Cost Center) |
| How many account structures are required at go-live? | 2 |
| Are advanced rule structures required (Yes/No)? | Yes |
| Fiscal year model (Calendar/Non-calendar) | Calendar |
| Number of periods per fiscal year | 13 (12 periods + period 13 for audit adjustments) |
| Reporting currency required in addition to accounting currency (Yes/No) | Yes |

Question: Define financial dimensions and mandatory tracking behavior.

**Financial Dimension Register**

| Dimension Name | Type (Custom/Entity-backed) | Mandatory (Y/N) | Applicable Accounts | Legal Entity Scope | Status |
| --- | --- | --- | --- | --- | --- |
| Department | Custom | Y for P&L, N for balance sheet | All, mandatory on P&L | Global | In Scope |
| Cost Center | Custom | Y for P&L, N for balance sheet | All, mandatory on P&L | Global | In Scope |
| Business Unit | Custom | N | All | Global | In Scope |
| Project | Custom | N | Specific journal types only | Global | In Scope |

Question: Define exchange-rate and currency control policy.

**Exchange Rate Governance Register**

| Rate Type | Currency Pair | Source Provider | Update Frequency | Owner | Effective Date |
| --- | --- | --- | --- | --- | --- |
| Closing | USD/EUR | ECB | Monthly | Treasury Lead | Month-end |
| Closing | USD/GBP | ECB | Monthly | Treasury Lead | Month-end |
| Closing | EUR/GBP | ECB | Monthly | Treasury Lead | Month-end |

### Required Setup Objects (A)

1. Legal entities and ledger assignments
2. Shared chart of accounts and main account catalog
3. Financial dimensions and dimension values
4. Account structures and advanced rules (if required)
5. Fiscal calendar, ledger calendar controls, and period access
6. Exchange-rate types and update governance

## B. Manage Cash

### B1. Bank Master Data And Bank Account Governance

This domain defines how bank accounts are structured, controlled, and mapped to liquidity accounts.

> Data Import Required: Bank accounts can be high-volume and should be loaded via DMF where applicable - see Data Import Plan -> Import #4.

| Question | Response |
| --- | --- |
| Are bank accounts maintained centrally across legal entities (Yes/No)? | Yes |
| Is separate bank account numbering standard required (Yes/No)? | Yes |
| Are minimum cash balance policies required (Yes/No)? | Yes |
| Are payment method controls required by bank account (Yes/No)? | Yes |
| Are bank accounts mapped one-to-one to liquidity accounts (Yes/No)? | Yes |

Question: Define bank account operating details.

**Bank Accounts Register**

| Bank Account ID | Bank Name | Legal Entity | Currency | Main Liquidity Account | Reconciliation Method | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
| US-BANK-001 | Contoso Bank NA | USMF | USD | 1101000 | Advanced bank reconciliation | Y |
| USS-BANK-001 | Contoso Bank NA | USSE | USD | 1102000 | Advanced bank reconciliation | Y |
| DE-BANK-001 | Contoso Bank Europe | DEMF | EUR | 1103000 | Advanced bank reconciliation | Y |
| UK-BANK-001 | Contoso Bank UK | GBMF | GBP | 1104000 | Advanced bank reconciliation | Y |

### B2. Reconciliation And Cash Forecasting Controls

This domain defines reconciliation cadence and cash forecasting setup.

> Data Import Required: Exchange rates and forecasting prerequisites are typically imported via DMF where possible - see Data Import Plan -> Import #3.

| Question | Response |
| --- | --- |
| Reconciliation frequency (Daily/Weekly/Monthly) | Monthly |
| Is advanced bank reconciliation required at go-live (Yes/No)? | Yes |
| Are automated statement imports required (Yes/No)? | Yes |
| Is cash flow forecasting in scope at go-live (Yes/No)? | Yes |
| Is Finance Insights cash forecasting capability in scope (Yes/No)? | Yes |
| Forecast horizon in days | 90 |

Question: Define cash forecasting source controls.

**Cash Forecast Source Register**

| Source Type | Included (Y/N) | Legal Entity Scope | Liquidity Account Rule | Refresh Frequency | Owner |
| --- | --- | --- | --- | --- | --- |
| AP open transactions | Y | All | Include designated liquidity accounts only | Daily | Treasury Lead |
| AR open transactions | Y | All | Include designated liquidity accounts only | Daily | Treasury Lead |
| Budget/forecast inputs | Y | All | Budget model OPEX_BASE | Weekly | FP&A Lead |

### Required Setup Objects (B)

1. Bank account master and legal-entity ownership
2. Liquidity account mapping and payment controls
3. Reconciliation parameters and statement processing model
4. Currency revaluation governance for cash and bank and general ledger
5. Cash forecasting ownership and refresh controls

## C. Manage Budgets

### C1. Basic Budgeting And Budget Model Design

This domain defines budget cycles, budget models, and approved budget maintenance architecture.

> Data Import Required: Budget account entries are typically high-volume and must be loaded via DMF - see Data Import Plan -> Import #5.

| Question | Response |
| --- | --- |
| Is basic budgeting required at go-live (Yes/No)? | Yes |
| Primary budget cycle time span (annual, quarterly, rolling) | Annual |
| Number of budget models required at go-live | 1 |
| Are budget register entries loaded from external source (Yes/No)? | Yes |
| Is budget model versioning required (Yes/No)? | Yes |

Question: Define budget models and ownership.

**Budget Models Register**

| Budget Model | Description | Legal Entity | Fiscal Cycle | Dimension Set | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- |
| OPEX_BASE | Operating budget baseline | USMF | Annual | Department, Cost Center, Business Unit | FP&A Lead | In Scope |
| OPEX_BASE | Operating budget baseline | USSE | Annual | Department, Cost Center, Business Unit | FP&A Lead | In Scope |
| OPEX_BASE | Operating budget baseline | DEMF | Annual | Department, Cost Center, Business Unit | FP&A Lead | In Scope |
| OPEX_BASE | Operating budget baseline | GBMF | Annual | Department, Cost Center, Business Unit | FP&A Lead | In Scope |

### C2. Budget Control And Budget Planning Governance

This domain defines budget control enforcement, thresholds, source-document coverage, and planning workflow.

| Question | Response |
| --- | --- |
| Is budget control required at go-live (Yes/No)? | Yes |
| Budget control check level (Document/Line) | Line |
| Are encumbrance or pre-encumbrance checks required (Yes/No)? | Yes |
| Who can override budget control failures? | Finance Manager |
| Is budget planning workflow required at go-live (Yes/No)? | Yes |
| Is separate budgeting hierarchy required (Yes/No)? | Yes |

Question: Define budget control rule granularity.

**Budget Control Rule Register**

| Rule ID | Financial Dimension Criteria | Main Account Criteria | Threshold % | Check Timing | Override Group |
| --- | --- | --- | --- | --- | --- |
| BCR-001 | Department=*; CostCenter=* | 4000000-6999999 | 10 | Line | FINANCE_MANAGER |

### Required Setup Objects (C)

1. Budget cycles and budget models
2. Budget register entry workflow and controls
3. Budget control rules, thresholds, and overrides
4. Budget planning workflow and hierarchy (if in scope)
5. Budget reporting dimension set standards

## D. Record Financial Transactions

### D1. Journal Names, Voucher Controls, And Approval Workflow

This domain defines how financial transactions are created, validated, approved, and posted.

| Question | Response |
| --- | --- |
| How many journal types are required at go-live? | 4 |
| Is journal approval workflow required for all journals (Yes/No)? | Yes |
| Is separate voucher number sequence required by journal name (Yes/No)? | Yes |
| Are posting restrictions required by user role (Yes/No)? | Yes |
| Are correction journals and reversal controls required (Yes/No)? | Yes |

Question: Define journal processing standards.

**Journal Name Register**

| Journal Name | Journal Type | Legal Entity | Approval Required (Y/N) | Voucher Sequence | Posting Restriction |
| --- | --- | --- | --- | --- | --- |
| General journals | Daily | All | Y | GJRN-####### | Role-based |
| Accrual journals | Daily | All | Y | AJRN-####### | Role-based |
| Allocation journals | Allocation | All | Y | ALLO-####### | Role-based |
| Intercompany journals | Daily | All | Y | ICJN-####### | Role-based |

### D2. Accruals, Deferrals, Allocations, And Periodic Entries

This domain defines recurring posting logic and periodic accounting mechanisms.

| Question | Response |
| --- | --- |
| Are ledger accrual schemes required at go-live (Yes/No)? | Yes |
| Are recurring journals required (Yes/No)? | Yes |
| Are periodic allocation rules required (Yes/No)? | Yes |
| Are automatic reversals required for accrual entries (Yes/No)? | Yes |
| Is settlement of selected ledger accounts required monthly (Yes/No)? | Yes |

Question: Define recurring and accrual pattern inventory.

**Recurring And Accrual Pattern Register**

| Pattern ID | Pattern Type (Accrual/Recurring/Allocation) | Trigger Frequency | Source Account Rule | Offset Rule | Legal Entity |
| --- | --- | --- | --- | --- | --- |
| OH-ALLOC-01 | Allocation | Monthly | 6100000-6299999 | Headcount-based allocation basis | All |
| ACCRUAL-01 | Accrual | Monthly | 6300000-6399999 | Shared liability account 2201000; reverse next period to original account | All |

### Required Setup Objects (D)

1. Journal names and journal control parameters
2. Voucher number sequences and posting permissions
3. Journal workflow approvals and escalation controls
4. Accrual, recurring, and reversal standards
5. Allocation rules and allocation-basis integration model

Implementation decision confirmed 2026-04-01:
- Shared accrual liability account: 2201000 for all legal entities
- Workflow model: one-step ledger journal approval using FINMGR for GEN, ACCRUAL, ALLO, and INTERCO journals in all entities

## E. Close Financial Periods

### E1. Financial Period Close Workspace And Task Orchestration

This domain defines close execution governance, templates, dependencies, and evidence requirements.

| Question | Response |
| --- | --- |
| Is Financial period close workspace required at go-live (Yes/No)? | Yes |
| Are separate close templates required for month-end and year-end (Yes/No)? | Yes |
| Are cross-company close dependencies required (Yes/No)? | Yes |
| Required close completion SLA (business days) | 4 |
| Are task-level evidence attachments mandatory (Yes/No)? | Yes |

Question: Define period-close task architecture.

**Close Task Register**

| Task ID | Task Name | Legal Entity Scope | Dependency | Owner Role | Due Offset (Days) | Evidence Required (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
| CLOSE-AP | Close Accounts Payable | All | None | AP Manager | 1 | Y |
| CLOSE-AR | Close Accounts Receivable | All | CLOSE-AP | AR Manager | 2 | Y |
| CLOSE-GL | Close General Ledger | All | CLOSE-AR | GL Manager | 4 | Y |

### E2. Revaluation, Settlement, Consolidation, And Year-End Close

This domain defines period-end accounting calculations and annual close strategy.

> Data Import Required: Opening balance journals are loaded through journal import patterns - see Data Import Plan -> Import #6.

| Question | Response |
| --- | --- |
| Is foreign currency revaluation required at month-end (Yes/No)? | Yes |
| Are ledger settlements required before year-end close (Yes/No)? | Yes |
| Is legal-entity consolidation required in scope (Yes/No)? | No |
| Is year-end close rerun expected during audit adjustments (Yes/No)? | Yes |
| Should previous year-end vouchers be deleted on rerun (Yes/No)? | No |
| Is optimize year-end close feature in scope (Yes/No)? | Yes |

Question: Define year-end template control per legal entity.

**Year-End Close Template Register**

| Template ID | Legal Entity | Retained Earnings Rule | Closing Transaction Mode | Dimension Carry Forward Rule | Rerun Policy |
| --- | --- | --- | --- | --- | --- |
| YE-USMF | USMF | Retained earnings 3100000 | Close result accounts and create opening | Carry forward Department and Cost Center | Rerun allowed, keep prior vouchers |
| YE-USSE | USSE | Retained earnings 3100000 | Close result accounts and create opening | Carry forward Department and Cost Center | Rerun allowed, keep prior vouchers |
| YE-DEMF | DEMF | Retained earnings 3100000 | Close result accounts and create opening | Carry forward Department and Cost Center | Rerun allowed, keep prior vouchers |
| YE-GBMF | GBMF | Retained earnings 3100000 | Close result accounts and create opening | Carry forward Department and Cost Center | Rerun allowed, keep prior vouchers |

### Required Setup Objects (E)

1. Financial period close templates and schedules
2. Task dependencies and ownership assignments
3. Currency revaluation and settlement runbook
4. Year-end close templates and rerun policy
5. Close evidence and audit-trail controls

## F. Analyze Financial Performance

### F1. Financial Reporting Architecture And Distribution

This domain defines reporting structures, report inventory, and distribution controls.

> Data Import Required: Reporting metadata migration can require governed artifact transfer - see Data Import Plan -> Import #7 where applicable.

| Question | Response |
| --- | --- |
| Is Financial reporting report-designer model required at go-live (Yes/No)? | Yes |
| Are standard default reports sufficient for phase 1 (Yes/No)? | No |
| Is separate report tree required by legal entity (Yes/No)? | Yes |
| Are report distribution schedules required (Yes/No)? | Yes |
| Is report approval before distribution required (Yes/No)? | Yes |

Question: Define reporting package inventory.

**Financial Report Register**

| Report ID | Report Name | Primary Audience | Legal Entity Scope | Frequency | Distribution Channel | Approval Required (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
| RPT-BS | Balance Sheet | Finance Leadership | All | Monthly | Financial Reporting workspace | Y |
| RPT-IS | Income Statement | Finance Leadership | All | Monthly | Financial Reporting workspace | Y |
| RPT-DPL | Department P&L | Department Leaders, Finance | All | Monthly | Financial Reporting workspace | Y |
| RPT-CF | Cash Flow Statement | Executive Team, Treasury | All | Monthly | Financial Reporting workspace | Y |

### F2. Budget Vs Actual And Variance Analysis Operating Model

This domain defines budget-vs-actual analytical standards and variance escalation.

| Question | Response |
| --- | --- |
| Which budget model is the default for variance analysis? | OPEX_BASE |
| What variance threshold (%) requires remediation action? | 10 |
| Are variance analyses required by dimension (Yes/No)? | Yes |
| Is monthly budget review governance in scope (Yes/No)? | Yes |
| Are anomaly detection and exception alerts required (Yes/No)? | Yes |

Question: Define variance governance standards.

**Variance Analysis Register**

| Analysis Scope | Dimension Set | Threshold % | Review Cadence | Owner Role | Escalation Route |
| --- | --- | --- | --- | --- | --- |
| Department P&L | Department, Cost Center | 10 | Monthly | FP&A Lead | Finance Leadership |

### Required Setup Objects (F)

1. Financial reporting row/column/tree structures
2. Report catalog and distribution schedules
3. Budget-vs-actual inquiry configuration
4. Variance review and remediation governance
5. Audit evidence retention for published packs

## Validation Scenarios

| Scenario | Process area | Expected outcome | Evidence required | Status |
| --- | --- | --- | --- | --- |
| Configure legal entities, shared ledger structure, and first controlled posting | Define accounting policies + Record financial transactions | Posting succeeds only for valid account and dimension combinations | Posted voucher, dimension validation output, setup screenshots | Ready |
| Load and validate 7-digit main accounts with range-policy checks | Define accounting policies | Main accounts align to defined category ranges and controls | DMF execution log, exception file, sample validation report | Planned |
| Validate mandatory dimensions for P&L and optional behavior for balance sheet | Define accounting policies | Department and Cost Center enforced on P&L only | Journal test evidence, blocked-posting evidence | Planned |
| Execute intercompany AP/AR transaction between two legal entities | Record financial transactions | Automated due-to/due-from postings created correctly | Intercompany voucher pair, account posting trace | Planned |
| Execute month-end close in Financial period close workspace with AP->AR->GL dependency | Close financial periods | Close tasks complete in sequence within 4 business days | Workspace schedule evidence, task completion log | Planned |
| Run month-end foreign currency revaluation using ECB closing rates | Manage cash + Close financial periods | Unrealized gain/loss posted by legal entity and currency pair | Revaluation run history, generated vouchers | Planned |
| Generate go-live reporting package | Analyze financial performance | Balance Sheet, Income Statement, Department P&L, and Cash Flow produced from Financial Reporting | Report outputs and run-parameter snapshots | Planned |

## Risks And Dependencies

| Risk/Dependency | Why it matters | Mitigation | Owner | Status |
| --- | --- | --- | --- | --- |
| CoA ID and main-account posting restrictions approval | Foundation control dependency for deterministic ledger setup | Confirmed FAB-GL and account-range posting restrictions as final | Corporate Controller | Closed |
| Budget model and budget control decisions approval | Required for budget control and variance governance execution | Confirmed single go-live model OPEX_BASE with threshold and override policy | FP&A Lead | Closed |
| Bank governance and reconciliation model approval | Required for treasury setup and validation sequencing | Confirmed governance model, monthly reconciliation, and automated statement import | Treasury Lead | Closed |
| Year-end rerun policy approval | Required for audit-adjustment consistency during close | Confirmed rerun allowed and prior vouchers retained | Corporate Controller | Closed |
| Intercompany pair matrix and account mapping approval | Required for intercompany automation validation | Confirmed entity-pair mapping readiness for implementation and data-load validation | Controller Team | Closed |

## Open Items And Clarifications

| ID | Process area | Question/unknown | Needed from | Due date | Resolution |
| --- | --- | --- | --- | --- | --- |
| R2R-001 | Define accounting policies | Confirm chart of accounts ID and manual-entry restrictions by account range | Corporate Controller | 2026-04-07 | Confirmed final on 2026-03-31 |
| R2R-002 | Manage cash | Confirm bank account governance model, reconciliation frequency, and statement import method | Treasury Lead | 2026-04-07 | Confirmed final on 2026-03-31 |
| R2R-003 | Manage budgets | Confirm basic budgeting scope, budget model structure, budget control thresholds, and override roles | FP&A Lead | 2026-04-07 | Confirmed final on 2026-03-31 |
| R2R-004 | Record financial transactions | Confirm journal approval workflow scope, voucher sequencing policy, and reversal controls | Accounting Operations Manager | 2026-04-07 | Confirmed final on 2026-03-31 |
| R2R-005 | Close financial periods | Confirm year-end close rerun and voucher-retention policy | Corporate Controller | 2026-04-07 | Confirmed final on 2026-03-31 |
| R2R-006 | Analyze financial performance | Confirm report distribution and approval controls, and variance threshold policy | VP Finance | 2026-04-07 | Confirmed final on 2026-03-31 |

## Agent Handoff Payload

```yaml
project:
  name: "Fabrikam Industrial Services (Fictional)"
  goLiveDate: "TBC"
  targetLegalEntities: ["USMF", "USSE", "DEMF", "GBMF"]
  masterLegalEntity: "USMF"

scope:
  defineAccountingPolicies: In Scope
  manageCash: In Scope
  manageBudgets: In Scope
  recordFinancialTransactions: In Scope
  closeFinancialPeriods: In Scope
  analyzeFinancialPerformance: In Scope

accountingPolicies:
  legalEntities:
    - { legalEntity: "USMF", companyName: "Fabrikam Industrial Services - US", countryRegion: "United States", baseCurrency: "USD", fiscalCalendar: "Calendar year (Jan-Dec, 12+1)" }
    - { legalEntity: "USSE", companyName: "Fabrikam Industrial Services - US Services", countryRegion: "United States", baseCurrency: "USD", fiscalCalendar: "Calendar year (Jan-Dec, 12+1)" }
    - { legalEntity: "DEMF", companyName: "Fabrikam Industrial Services - Germany", countryRegion: "Germany", baseCurrency: "EUR", fiscalCalendar: "Calendar year (Jan-Dec, 12+1)" }
    - { legalEntity: "GBMF", companyName: "Fabrikam Industrial Services - UK", countryRegion: "United Kingdom", baseCurrency: "GBP", fiscalCalendar: "Calendar year (Jan-Dec, 12+1)" }
  policyOwner: "Corporate Controller"
  sharedChartOfAccounts: "Yes" # Yes/No
  intercompanyRequired: "Yes" # Yes/No

chartOfAccounts:
  chartOfAccountsId: "FAB-GL"
  mainAccountPolicy:
    - { accountRange: "1000000-1999999", category: "Assets", manualEntryAllowed: "N", defaultDimensionRule: "Optional", fixedDimensionRule: "None" }
    - { accountRange: "2000000-2999999", category: "Liabilities", manualEntryAllowed: "N", defaultDimensionRule: "Optional", fixedDimensionRule: "None" }
    - { accountRange: "3000000-3999999", category: "Equity", manualEntryAllowed: "N", defaultDimensionRule: "Optional", fixedDimensionRule: "None" }
    - { accountRange: "4000000-4999999", category: "Revenue", manualEntryAllowed: "Y", defaultDimensionRule: "Department + Cost Center mandatory", fixedDimensionRule: "Department, Cost Center" }
    - { accountRange: "5000000-5999999", category: "Cost of Sales", manualEntryAllowed: "Y", defaultDimensionRule: "Department + Cost Center mandatory", fixedDimensionRule: "Department, Cost Center" }
    - { accountRange: "6000000-6999999", category: "Operating Expenses", manualEntryAllowed: "Y", defaultDimensionRule: "Department + Cost Center mandatory", fixedDimensionRule: "Department, Cost Center" }
  import:
    mainAccountsImportId: 1

financialDimensions:
  dimensions:
    - { name: "Department", type: "Custom", mandatory: "Y for P&L, N for balance sheet", applicableAccounts: "All, mandatory on P&L", legalEntityScope: "Global" }
    - { name: "Cost Center", type: "Custom", mandatory: "Y for P&L, N for balance sheet", applicableAccounts: "All, mandatory on P&L", legalEntityScope: "Global" }
    - { name: "Business Unit", type: "Custom", mandatory: "N", applicableAccounts: "All", legalEntityScope: "Global" }
    - { name: "Project", type: "Custom", mandatory: "N", applicableAccounts: "Specific journal types only", legalEntityScope: "Global" }
  balancingDimension: "Cost Center"
  accountStructures:
    - { name: "BS-STRUCT", segments: "MainAccount-BusinessUnit-Project", legalEntityScope: "All" }
    - { name: "PL-STRUCT", segments: "MainAccount-Department-CostCenter-BusinessUnit-Project", legalEntityScope: "All" }
  advancedRules:
    - { ruleName: "PL-Mandatory-Dims", triggerCriteria: "MainAccount 4000000-6999999", additionalSegments: "Department, CostCenter" }
  import:
    dimensionValuesImportId: 2

currencyAndPeriods:
  fiscalYearModel: "Calendar"
  periodsPerYear: "13 (12 periods + period 13)"
  accountingCurrencyByEntity:
    - { legalEntity: "USMF", accountingCurrency: "USD", reportingCurrency: "USD" }
    - { legalEntity: "USSE", accountingCurrency: "USD", reportingCurrency: "USD" }
    - { legalEntity: "DEMF", accountingCurrency: "EUR", reportingCurrency: "EUR" }
    - { legalEntity: "GBMF", accountingCurrency: "GBP", reportingCurrency: "GBP" }
  exchangeRatePolicy:
    - { rateType: "Closing", currencyPair: "USD/EUR", sourceProvider: "ECB", updateFrequency: "Monthly" }
    - { rateType: "Closing", currencyPair: "USD/GBP", sourceProvider: "ECB", updateFrequency: "Monthly" }
    - { rateType: "Closing", currencyPair: "EUR/GBP", sourceProvider: "ECB", updateFrequency: "Monthly" }
  import:
    exchangeRatesImportId: 3

cashManagement:
  bankAccounts:
    - { bankAccountId: "US-BANK-001", legalEntity: "USMF", currency: "USD", liquidityMainAccount: "1101000", reconciliationMethod: "Advanced bank reconciliation" }
    - { bankAccountId: "USS-BANK-001", legalEntity: "USSE", currency: "USD", liquidityMainAccount: "1102000", reconciliationMethod: "Advanced bank reconciliation" }
    - { bankAccountId: "DE-BANK-001", legalEntity: "DEMF", currency: "EUR", liquidityMainAccount: "1103000", reconciliationMethod: "Advanced bank reconciliation" }
    - { bankAccountId: "UK-BANK-001", legalEntity: "GBMF", currency: "GBP", liquidityMainAccount: "1104000", reconciliationMethod: "Advanced bank reconciliation" }
  reconciliationFrequency: "Monthly"
  advancedBankReconciliation: "Yes" # Yes/No
  cashForecastingInScope: "Yes" # Yes/No
  import:
    bankAccountsImportId: 4

budgeting:
  basicBudgetingInScope: "Yes" # Yes/No
  budgetModels:
    - { budgetModel: "OPEX_BASE", legalEntity: "USMF", fiscalCycle: "Annual", dimensionSet: "Department, Cost Center, Business Unit", owner: "FP&A Lead" }
    - { budgetModel: "OPEX_BASE", legalEntity: "USSE", fiscalCycle: "Annual", dimensionSet: "Department, Cost Center, Business Unit", owner: "FP&A Lead" }
    - { budgetModel: "OPEX_BASE", legalEntity: "DEMF", fiscalCycle: "Annual", dimensionSet: "Department, Cost Center, Business Unit", owner: "FP&A Lead" }
    - { budgetModel: "OPEX_BASE", legalEntity: "GBMF", fiscalCycle: "Annual", dimensionSet: "Department, Cost Center, Business Unit", owner: "FP&A Lead" }
  budgetControl:
    enabled: "Yes" # Yes/No
    rules:
      - { ruleId: "BCR-001", dimensionCriteria: "Department=*; CostCenter=*", mainAccountCriteria: "4000000-6999999", thresholdPercent: "10", checkTiming: "Line", overrideGroup: "FINANCE_MANAGER" }
  budgetPlanning:
    enabled: "Yes" # Yes/No
    hierarchyRequired: "Yes" # Yes/No
  import:
    budgetEntriesImportId: 5

transactionRecording:
  journalNames:
    - { journalName: "General journals", journalType: "Daily", legalEntity: "All", approvalRequired: "Y", voucherSequence: "GJRN-#######", postingRestriction: "Role-based" }
    - { journalName: "Accrual journals", journalType: "Daily", legalEntity: "All", approvalRequired: "Y", voucherSequence: "AJRN-#######", postingRestriction: "Role-based" }
    - { journalName: "Allocation journals", journalType: "Allocation", legalEntity: "All", approvalRequired: "Y", voucherSequence: "ALLO-#######", postingRestriction: "Role-based" }
    - { journalName: "Intercompany journals", journalType: "Daily", legalEntity: "All", approvalRequired: "Y", voucherSequence: "ICJN-#######", postingRestriction: "Role-based" }
  accrualPatterns:
    - { patternId: "OH-ALLOC-01", patternType: "Allocation", triggerFrequency: "Monthly", sourceAccountRule: "6100000-6299999", offsetRule: "Headcount-based allocation basis", legalEntity: "All" }
    - { patternId: "ACCRUAL-01", patternType: "Accrual", triggerFrequency: "Monthly", sourceAccountRule: "6300000-6399999", offsetRule: "Reverse next period to original account", legalEntity: "All" }
  approvalWorkflowRequired: "Yes" # Yes/No

periodClose:
  closeTemplates:
    - { templateId: "ME-CLOSE", periodType: "Month-end", legalEntityScope: "All", slaDays: "4" }
    - { templateId: "YE-CLOSE", periodType: "Year-end", legalEntityScope: "All", slaDays: "4" }
  revaluationRequired: "Yes" # Yes/No
  consolidationInScope: "No" # Yes/No
  yearEndCloseTemplates:
    - { templateId: "YE-USMF", legalEntity: "USMF", retainedEarningsRule: "3100000", rerunPolicy: "Rerun allowed, keep prior vouchers" }
    - { templateId: "YE-USSE", legalEntity: "USSE", retainedEarningsRule: "3100000", rerunPolicy: "Rerun allowed, keep prior vouchers" }
    - { templateId: "YE-DEMF", legalEntity: "DEMF", retainedEarningsRule: "3100000", rerunPolicy: "Rerun allowed, keep prior vouchers" }
    - { templateId: "YE-GBMF", legalEntity: "GBMF", retainedEarningsRule: "3100000", rerunPolicy: "Rerun allowed, keep prior vouchers" }
  import:
    openingBalancesImportId: 6

financialPerformance:
  financialReports:
    - { reportId: "RPT-BS", reportName: "Balance Sheet", audience: "Finance Leadership", legalEntityScope: "All", frequency: "Monthly", approvalRequired: "Y" }
    - { reportId: "RPT-IS", reportName: "Income Statement", audience: "Finance Leadership", legalEntityScope: "All", frequency: "Monthly", approvalRequired: "Y" }
    - { reportId: "RPT-DPL", reportName: "Department P&L", audience: "Department Leaders, Finance", legalEntityScope: "All", frequency: "Monthly", approvalRequired: "Y" }
    - { reportId: "RPT-CF", reportName: "Cash Flow Statement", audience: "Executive Team, Treasury", legalEntityScope: "All", frequency: "Monthly", approvalRequired: "Y" }
  variancePolicy:
    - { analysisScope: "Department P&L", dimensionSet: "Department, Cost Center", thresholdPercent: "10", cadence: "Monthly", ownerRole: "FP&A Lead", escalationRoute: "Finance Leadership" }
  reportDistributionApprovalRequired: "Yes" # Yes/No
  import:
    reportingMetadataImportId: 7

securityAndControls:
  segregationOfDutiesRules:
    - { conflictArea: "Journal creation and posting", roleA: "Accountant", roleB: "GL Posting Approver", mitigationControl: "Workflow approval with audit trail" }
    - { conflictArea: "Budget override and budget ownership", roleA: "Budget Owner", roleB: "Finance Manager", mitigationControl: "Override restricted to Finance Manager role" }
  approvalAuthorities:
    - { processArea: "Budget control override", authorityRole: "Finance Manager", limitOrCondition: "Threshold exception only" }
    - { processArea: "Report distribution approval", authorityRole: "VP Finance", limitOrCondition: "Required before publication" }

dataMigration:
  importRegisterStatus:
    - { importId: "1", recordType: "Main accounts", entityName: "MainAccountEntity", owner: "Finance Master Data Lead", status: "Ready for readiness validation" }
    - { importId: "2", recordType: "Financial dimension values", entityName: "TBC", owner: "Finance Master Data Lead", status: "Ready for readiness validation" }
    - { importId: "3", recordType: "Exchange rates", entityName: "TBC", owner: "Treasury Lead", status: "Ready for readiness validation" }
    - { importId: "4", recordType: "Bank accounts", entityName: "TBC", owner: "Treasury Lead", status: "Ready for readiness validation" }
    - { importId: "5", recordType: "Budget account entries", entityName: "Budget Account Entries data entity", owner: "FP&A Lead", status: "Ready for readiness validation" }
    - { importId: "6", recordType: "Opening balance journals", entityName: "TBC", owner: "GL Lead", status: "Ready for readiness validation" }
    - { importId: "7", recordType: "Intercompany due-to/due-from mapping", entityName: "TBC", owner: "Controller Team", status: "Ready for readiness validation" }
  cutoverWindowApproved: "Yes" # Yes/No

validation:
  scenarios:
    - { scenarioName: "Controlled posting", expectedOutcome: "Posting succeeds only for valid account/dimension combinations", evidenceRequired: "Posted voucher and validation output", status: "Ready" }
    - { scenarioName: "Main account load validation", expectedOutcome: "Main accounts align to category ranges and controls", evidenceRequired: "DMF log and exception report", status: "Planned" }
    - { scenarioName: "P&L mandatory dimensions", expectedOutcome: "Department and Cost Center enforced on P&L only", evidenceRequired: "Journal test and blocked-posting evidence", status: "Planned" }
    - { scenarioName: "Intercompany AP/AR", expectedOutcome: "Automated due-to and due-from postings", evidenceRequired: "Intercompany voucher pair", status: "Planned" }
    - { scenarioName: "Month-end close", expectedOutcome: "AP to AR to GL close dependency completes within SLA", evidenceRequired: "Close workspace task log", status: "Planned" }
    - { scenarioName: "FX revaluation", expectedOutcome: "Unrealized gain/loss posted by legal entity and pair", evidenceRequired: "Revaluation history and vouchers", status: "Planned" }
    - { scenarioName: "Reporting package", expectedOutcome: "BS, IS, Department P&L, and Cash Flow produced", evidenceRequired: "Report outputs and run parameters", status: "Planned" }
  outstandingOpenItems: []
```

## Reference Documentation

1. Record-to-Report process areas overview: https://learn.microsoft.com/dynamics365/guidance/business-processes/record-to-report-areas
2. Define accounting policies process area: https://learn.microsoft.com/dynamics365/guidance/business-processes/record-to-report-define-accounting-policies
3. Close financial periods process area: https://learn.microsoft.com/dynamics365/guidance/business-processes/record-to-report-close-financial-periods
4. Plan chart of accounts: https://learn.microsoft.com/dynamics365/finance/general-ledger/plan-chart-of-accounts
5. Configure ledgers: https://learn.microsoft.com/dynamics365/finance/general-ledger/configure-ledger
6. Financial dimensions: https://learn.microsoft.com/dynamics365/finance/general-ledger/financial-dimensions
7. Fiscal calendars, fiscal years, and periods: https://learn.microsoft.com/dynamics365/finance/budgeting/fiscal-calendars-fiscal-years-periods
8. Budgeting overview: https://learn.microsoft.com/dynamics365/finance/budgeting/basic-budgeting-overview-configuration
9. Budget control overview: https://learn.microsoft.com/dynamics365/finance/budgeting/budget-control-overview-configuration
10. Ledger journal types: https://learn.microsoft.com/dynamics365/finance/general-ledger/ledger-journal-types
11. Process allocations: https://learn.microsoft.com/dynamics365/finance/general-ledger/process-allocations
12. Financial period close workspace: https://learn.microsoft.com/dynamics365/finance/general-ledger/financial-period-close-workspace
13. Close the general ledger at period end: https://learn.microsoft.com/dynamics365/finance/general-ledger/close-general-ledger-at-period-end
14. Year-end close: https://learn.microsoft.com/dynamics365/finance/general-ledger/year-end-close
15. Foreign currency revaluation for General ledger: https://learn.microsoft.com/dynamics365/finance/general-ledger/foreign-currency-revaluation-general-ledger
16. Cash and bank management home page: https://learn.microsoft.com/dynamics365/finance/cash-bank-management/cash-bank-management
17. Bank foreign currency revaluation: https://learn.microsoft.com/dynamics365/finance/cash-bank-management/bank-revaluation
18. Financial reporting getting started: https://learn.microsoft.com/dynamics365/finance/general-ledger/financial-reporting-getting-started

## Transcript Evidence Summary

| Item | Detail |
| --- | --- |
| Files reviewed | Transcripts/Record _To_Report/Record_To_Report_Transcript.md |
| Process areas with explicit evidence | Define accounting policies, Record financial transactions, Close financial periods, Analyze financial performance |
| Process areas with partial evidence | Manage cash, Manage budgets |
| Confidence level | High |
| Execution mode applied | Evidence-Filled Mode |
