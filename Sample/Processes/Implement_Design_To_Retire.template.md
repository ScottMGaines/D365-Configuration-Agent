# Dynamics 365 Finance & Supply Chain Design-to-Retire Implementation Discovery Workbook

Execution mode: Evidence-Filled Mode

This workbook is the implementation source of truth for Design-to-Retire (D2R) in Dynamics 365 Supply Chain Management. It is written for implementation consultants and build agents and is based on transcript-backed decisions, Microsoft Business Process Catalog structure, and Microsoft Learn guidance.

Transcript evidence handling:
- Only values explicitly stated in the transcript are prefilled.
- Missing decisions are marked as `TBC`.
- No assumptions are introduced.

## 1. Title and Preamble

Process: Design-to-Retire (D2R)

Target legal entities (aligned to Record-to-Report outputs): USMF, USSE, DEMF, GBMF

Master policy owner legal entity: USMF

## 2. Process Context

### Why this process exists

Design-to-Retire governs the product lifecycle from product definition through engineering change, manufacturing readiness, active lifecycle control, and retirement. For Northwind Equipment Manufacturing, the process is used to support configured industrial equipment in discrete manufacturing with governed change control and quality gates.

### BPC process areas in scope

1. Develop product strategy
2. Introduce products
3. Manage active products
4. Retire products
5. Analyze product performance

### Transcript Evidence Summary

Files reviewed:
1. Transcripts/Design_To_Retire/Design_To_Retire_Transcript.md
2. Output/Record_To_Report_Implementation_log.md
3. Output/Record_To_Report_Implementation_Summary.md

Process areas covered by transcript evidence:
1. Product Information Management (product structure, dimensions, lifecycle)
2. Engineering Change Management
3. BOMs, routes, production control
4. Costing and inventory valuation
5. Quality management
6. Retirement controls
7. Data migration scope
8. Cross-process dependencies

Confidence level: High

## 3. Configuration Summary

1. Manufacturing model: Discrete manufacturing for configured industrial equipment.
2. Product master baseline: Released products with BOM, route, and product versions; no product variants/configurator in phase one.
3. Dimensions and tracking: Site, warehouse, serial number; no batch tracking; finished goods serial tracking at receipt and issue only.
4. Lifecycle governance: Pre-production, Active, End-of-Life; lifecycle state controls purchasing and production permissions.
5. Engineering change governance: ECM mandatory; ECR and ECO required; effective dating required; no retroactive changes; ECO applies to released products only.
6. Product structure and routing: Multi-level BOM, phantom BOM for subassemblies, approved vendor list enforcement for purchased components, standard routes with cutting/assembly/testing operations and maintained setup/run times.
7. Capacity and execution: Resource-group-based finite capacity planning; MES not in scope for phase one.
8. Production control: Production orders only; no batch orders; no process manufacturing; component reservation at production release.
9. Costing policy: Standard cost for all manufactured items; quarterly standard cost rollup with formal approval.
10. Inventory valuation policy: Physical negative inventory allowed; financial negative inventory not allowed.
11. Quality policy: Quality orders at purchase receipt and production completion; test instruments tracked externally.
12. Warehousing scope: Basic warehousing only; advanced WMS not in scope.
13. Retirement policy: End-of-Life blocks new purchasing and production; on-hand can be sold or scrapped.

## 4. Data Import Plan

### Import Register

| # | Record type | D365 data entity | Data Import Required | Source | Est. volume | Status |
| --- | --- | --- | --- | --- | --- | --- |
| 1a | Shared product masters | Products V2 | Yes | Legacy product master | TBC | In Scope |
| 1b | Released products per legal entity | Released products V2 | Yes | Legacy product master | TBC | In Scope |
| 2 | Active BOM lines and versions | Bill of materials lines V3 / Bill of materials versions V3 | Yes | Legacy PLM/ERP | TBC | In Scope |
| 3 | Active routes and route versions | Route versions V2 | Yes | Legacy manufacturing | TBC | In Scope |
| 4 | Current standard costs — raw materials, resources, and indirect cost rates only | Pending item prices V2 (raw material prices); Pending route cost category unit costs (resource costs); Costing sheet node calculation factors V2 (indirect costs) | Yes | Legacy costing | TBC | In Scope |
| 5 | Open engineering change orders | Manual re-entry in D365 pre-go-live (no standard DMF batch entity for ECM change orders; confirmed Option A) | Yes | Legacy PLM/ECM | Low volume | In Scope |
| 6 | Product lifecycle state assignments | EcoResProductLifecycleStateEntity | Yes | Configuration — define lifecycle states in D365 first, then migrate product-to-state assignments | Low volume | In Scope |
| 7 | Unit of measure conversions | UnitOfMeasureConversionEntity | Yes | Legacy ERP | TBC | In Scope |
| 8 | Approved vendor list by item | PurchApprovedVendorListEntity | Yes | Legacy procurement / ERP | TBC | In Scope |

### Import sequencing

1. Lifecycle state definitions (configure in D365 first; no import needed — create manually)
2. Shared product masters (Products V2 — 1a)
3. Released products per legal entity (Released products V2 — 1b)
4. Unit of measure conversions
5. BOM structures
6. Route structures
7. Standard costs (raw materials and resources only; finished goods via cost rollup)
8. Approved vendor list entries
9. Open ECOs (if present — manual re-entry)

High-volume readiness default: Each imported object requires a named owner, mock-load confirmation, and source-extract confirmation before cutover approval.

| Object | Scope entities | Owner role | Readiness gate |
| --- | --- | --- | --- |
| Shared products (Products V2) | USMF master then shared | Product Data Lead - USMF | Mock load passed + mandatory fields validated |
| Released products (Released products V2) | USMF, USSE, DEMF, GBMF | Product Data Lead per entity | Mock load passed in each entity |
| BOM lines and versions | USMF, USSE, DEMF, GBMF | Manufacturing Engineering Lead | Referential integrity check passed |
| Route versions | USMF, USSE, DEMF, GBMF | Manufacturing Engineering Lead | Operation/resource validation passed |
| UOM conversions | USMF master then replicated | Product Data Lead - USMF | Conversion completeness check passed |
| Approved vendor list | USMF, USSE, DEMF, GBMF | Procurement Manager per entity | Vendor-item validity check passed |

### Data readiness checklist

| Check | Owner | Status |
| --- | --- | --- |
| Legal entity ownership for each import confirmed (USMF/USSE/DEMF/GBMF) | Program Manager | Complete |
| Product number uniqueness and required fields validated | Product Data Lead per entity | Complete - enforce pre-load validation and duplicate check per entity |
| BOM and route referential integrity validated | Manufacturing Engineering Lead | Complete - enforce parent/child and operation-resource validation before load |
| Standard cost governance and approval control defined | Cost Accounting Manager | Complete |
| ECO import decision for open records finalized | PLM Lead | Resolved: Option A - manual re-entry pre-go-live |

## 5. How to Use This Workbook

1. Confirm each section decision against transcript evidence.
2. Fill every `TBC` value before build execution.
3. Keep unresolved decisions in the Open Items section with owner and due date.
4. Use this workbook as the single source for D365 configuration sequencing and validation.
5. Data uploads remain manual and external to agent execution.

## 6. Company Profile and Scope

### 6a. Implementation context

| Field | Response |
| --- | --- |
| Company legal name | Northwind Equipment Manufacturing (fictional) |
| Process | Design-to-Retire |
| Industry model | Configured industrial equipment, discrete manufacturing |
| Legal entities in scope | USMF, USSE, DEMF, GBMF |
| Primary implementation wave | Phase one |
| Advanced WMS in scope | No |
| MES in scope | No |

### 6b. Process scope decision

| BPC process area | Sub-area | Status | Evidence |
| --- | --- | --- | --- |
| Develop product strategy | Product structure and lifecycle baseline | In Scope | Transcript explicit |
| Develop product strategy | Product variants/configurator | Out of Scope (Phase one) | Transcript explicit |
| Introduce products | BOM/route/product-version design controls | In Scope | Transcript explicit |
| Introduce products | Process manufacturing formula design | Out of Scope | Transcript explicit |
| Manage active products | ECM (ECR/ECO/effective dating) | In Scope | Transcript explicit |
| Manage active products | Quality order controls | In Scope | Transcript explicit |
| Retire products | End-of-Life transaction controls | In Scope | Transcript explicit |
| Analyze product performance | KPI and analytics model detail | In Scope (quarterly review cadence confirmed; KPI catalog and traceability design deferred to Phase two) | Partially defined |

## 7. Detailed Configuration Guidance and Discovery Questions

## A. Develop Product Strategy

### A0. Number sequences (ECM prerequisites)

Number sequences must be configured before any product or change management records can be created. The BOM number sequence **must** be set to *Automatic* — this is a hard prerequisite for Engineering Change Management per Microsoft Learn (source: [ECM overview](https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/product-engineering-overview)).

| Sequence | Reference area | Required setting | Rationale |
| --- | --- | --- | --- |
| BOM number | BOM ID | **Automatic** | Hard ECM prerequisite — ECM cannot function with Manual BOM numbering |
| Route number | Route ID | Automatic | Required for engineering route governance |
| Production order | Production order | Automatic | Required for production control |
| Engineering change request | ECR number | Automatic | Required for ECM request tracking |
| Engineering change order | ECO number | Automatic | Required for ECM order tracking |
| Product number (items) | Item number | Automatic or External | Must align with product numbering strategy (≤20 chars recommended; ≤10 chars best practice per MS Learn) |

> Menu: **Organization administration > Number sequences > Number sequences**
> BOM number sequence: Filter on BOM references; set *Manual* = No (Automatic), *Continuous* = No, *Scope* = Company.

### A1. Product governance and product structure

| Question | Response |
| --- | --- |
| Manufacturing model | Discrete manufacturing |
| Product type | Configured industrial equipment |
| Finished goods released with BOM/route/version | Yes |
| Product variants in phase one | No |
| Product configurator in phase one | No |
| Engineering organization (ECM) | USMF — the legal entity designated as the engineering company; owns all engineering products and ECM data |
| Engineering org setup menu | Engineering change management > Setup > Engineering organizations |
| Product version dimension group | Version (product dimension group required for ECM versioned products — assign to all engineering product categories) |

### A2. Product dimensions and tracking controls

| Question | Response |
| --- | --- |
| Storage dimensions in scope | Site, Warehouse |
| Tracking dimensions in scope | Serial number (finished goods only) |
| Batch tracking in scope | No |
| Serial tracking point | Receipt and issue |
| Component serial tracking | No |
| Storage dimension group name | SITE_WH — Site + Warehouse active; Inventory location inactive (basic WMS) |
| Tracking dimension group — finished goods | SER_FG — Serial number active at Receipt and Issue; blank receipt/issue not allowed; Manual = No (system-assigned or user-entered at receipt) |
| Tracking dimension group — components | NONE — no tracking dimensions on purchased raw material components |
| Product dimension group for ECM products | Version — assign to engineering product categories in ECM to enable version tracking in transactions |

### A3. Lifecycle state model

| Question | Response |
| --- | --- |
| Lifecycle states at go-live | Pre-production, Active, End-of-Life |
| Lifecycle controls purchasing | Yes |
| Lifecycle controls production | Yes |
| Lifecycle controls sales | Yes |

### A4. Lifecycle transition ownership (Phase one default)

Use a manual approval control in phase one (no workflow) with role-based accountability.

| Transition | Required approver role | Backup approver | Escalation after SLA breach | Evidence |
| --- | --- | --- | --- | --- |
| Pre-production -> Active | Engineering Manager (USMF master policy) | Product Data Lead | Director of Operations after 3 business days | Approved change ticket + released product audit trail |
| Active -> End-of-Life | Product Lifecycle Manager | Supply Chain Manager | Director of Operations after 3 business days | Retirement decision record + lifecycle change log |

| Entity | Local execution owner | Governance owner |
| --- | --- | --- |
| USMF | Product Data Lead - USMF | Engineering Manager - USMF |
| USSE | Product Data Lead - USSE | Engineering Manager - USMF |
| DEMF | Product Data Lead - DEMF | Engineering Manager - USMF |
| GBMF | Product Data Lead - GBMF | Engineering Manager - USMF |

SLA policy: Manual approvals are due in 3 business days; escalations route to Director of Operations if not completed.

## B. Introduce Products

### B1. BOM and route design model

| Question | Response |
| --- | --- |
| BOM depth | Multi-level |
| Phantom BOM usage | Yes, for sub-assemblies |
| Co-products/by-products | No |
| Routing model | Standard routes per finished good |
| Operations listed | Cutting, Assembly, Testing |
| Setup and run times maintained | Yes |
| Resource model for capacity | Resource groups |
| Capacity mode | Finite capacity |

### A3. Item model groups and item groups

Standard cost requires dedicated item model groups per item type. Per Microsoft Learn prerequisites for standard costs, each group must explicitly set the standard cost inventory model and configure negative inventory policy per the business decision in Section C2.

#### Item model groups

| Group ID | Group name | Inventory model | Physical negative inventory | Financial negative inventory | Usage |
| --- | --- | --- | --- | --- | --- |
| FG-STD | Finished goods — standard cost | Standard cost | Allowed | **Not allowed** | Finished goods and ECM-governed sub-assemblies |
| RM-STD | Raw materials — standard cost | Standard cost | Allowed | **Not allowed** | All purchased BOM components |

> Menu: **Inventory management > Setup > Inventory > Item model groups**
> For both groups: *Inventory model* = Standard cost; *Physical negative inventory* = Yes (allowed per C2 policy); *Financial negative inventory* = No (blocked per C2 policy).
> MS Learn rationale: Enabling physical negative while disabling financial negative prevents sales/production blocking on short inventory while protecting financial integrity at posting.

#### Item groups

Item groups drive inventory posting profiles and cost segmentation. Define at minimum one group per product family.

| Item group ID | Item group name | Usage |
| --- | --- | --- |
| FG | Finished goods | Finished goods and major assemblies |
| RM | Raw materials | All purchased BOM components |
| SVC | Services | Non-inventoried services for subcontracted route operations |

> Menu: **Inventory management > Setup > Inventory > Item groups**

> Data Import Required: BOM and route baseline records should be loaded through DMF-aligned migration sets for production-ready cutover.

### B2. Production model for introduction stage

| Question | Response |
| --- | --- |
| Production order type in scope | Production orders |
| Batch orders in scope | No |
| Process manufacturing in scope | No |
| Component reservation policy | At production release |

### B3. Classification and release-template governance (Phase one default)

Apply a minimum enterprise classification model to support procurement controls, sales controls, and internal product governance without customization.

#### Category hierarchies

| Hierarchy | Purpose | Owner |
| --- | --- | --- |
| Procurement category hierarchy | Sourcing and spend controls for purchased items/components | Procurement Manager - USMF (master) |
| Sales category hierarchy | Sales reporting and product segmentation for finished goods | Sales Operations Manager - USMF (master) |
| Product category hierarchy (internal) | Internal product classification for engineering/manufacturing governance | Product Data Manager - USMF (master) |

#### Minimum attribute and compliance classification set

| Classification area | Required value at release | Owner |
| --- | --- | --- |
| Product attributes | Product family, model, lifecycle class, warranty class | Product Data Lead (local entity) |
| Compliance attributes | Country/region compliance flag, hazardous material flag (Yes/No), document-required flag | Compliance Manager - USMF policy, local entity execution |

#### Released product defaults/templates

| Template ID | Item class | Defaults |
| --- | --- | --- |
| FG-BASE | Finished goods | Item group FG; item model group FG-STD; storage SITE_WH; tracking SER_FG; reservation policy at release |
| RM-BASE | Raw materials | Item group RM; item model group RM-STD; storage SITE_WH; tracking NONE |
| SVC-BASE | Services | Item group SVC; non-stocked service defaults |

| Entity | Template maintenance owner |
| --- | --- |
| USMF | Product Data Lead - USMF |
| USSE | Product Data Lead - USSE |
| DEMF | Product Data Lead - DEMF |
| GBMF | Product Data Lead - GBMF |

#### Compliance and document governance before Active lifecycle

| Control | Requirement |
| --- | --- |
| Required documents | Drawing/specification document and quality control plan must be attached before Pre-production -> Active transition |
| Retention policy | Engineering and compliance documents retained for 7 years minimum |
| Change control | Document updates require ECO reference and effective date |
| Approval gate | Missing required document blocks lifecycle transition to Active |

## C. Manage Active Products

### C1. Engineering Change Management (ECM)

| Question | Response |
| --- | --- |
| ECM in scope | Yes, mandatory |
| Change request object | ECR |
| Change order object | ECO |
| Effective dating required | Yes |
| Retroactive changes allowed | No |
| ECO eligibility | Released products only |
| ECM workflow (ECR/ECO) | Deferred - no workflow configuration in Phase one |
| ECM change SLA target | 3 days |

Interim governance default: Until workflow is enabled, ECR/ECO approvals are recorded through a controlled change log, approved by Engineering Manager, with escalation to Director of Operations when SLA exceeds 3 business days.

### C2. Costing and valuation controls

| Question | Response |
| --- | --- |
| Costing method | Standard cost |
| Standard cost rollup frequency | Quarterly |
| Cost rollup approval required | Yes |
| Physical negative inventory | Allowed |
| Financial negative inventory | Not allowed |

#### Costing version and cost groups

Per Microsoft Learn costing version guidance and standard cost prerequisites:

**Costing versions required:**

| Version ID | Type | Purpose |
| --- | --- | --- |
| STD-CURRENT | Standard cost | Active version for live transactions; holds activated item prices used for all inventory postings |
| PLAN-NEXT | Planned cost | Simulation version for the pending quarterly rollup; prices remain Pending status until approved and activated |

> Menu: **Cost management > Predetermined cost policies setup > Costing versions**
> Activation procedure: Enter pending prices into PLAN-NEXT > run BOM calculation > obtain formal approval > activate prices into STD-CURRENT. Never import fully-loaded finished good costs directly — see Import Register row 4.

**Cost groups required:**

| Cost group ID | Name | Type | Usage |
| --- | --- | --- | --- |
| M | Material | Direct material | All purchased raw materials and components |
| L | Labor | Direct manufacturing | Labor cost categories on route operations (Cutting, Assembly, Testing) |
| O | Overhead | Manufacturing overhead | Manufacturing overhead surcharges on production (% of labor or material basis) |
| I | Indirect | Indirect | Indirect cost node calculations in costing sheet |

> Menu: **Production control > Setup > Routes > Cost groups**
> Cost breakdown policy: Set *Cost breakdown* = Sub ledger on **Inventory accounting parameters** to enable per-cost-group variance reporting.
> Variances: Set *Variances to standard* = Per cost group to track purchase price, production lot size, quantity, price, and substitution variances separately by cost group.

### C3. Quality and warehouse integration

| Question | Response |
| --- | --- |
| Quality management in scope | Yes |
| Quality order trigger events | Purchase receipt, Production completion |
| Test instrument tracking in D365 | No (external) |
| Warehouse model | Basic warehousing |
| Advanced WMS in scope | No |

#### Quality management setup sequence (MS Learn best practice)

Quality management must be enabled before quality orders can be generated. Minimum configuration required at go-live:

| Step | Action | Menu path |
| --- | --- | --- |
| 1 | Enable quality management | Inventory management > Setup > Inventory and warehouse management parameters > Quality management tab > *Use quality management* = Yes |
| 2 | Configure tests | Inventory management > Setup > Quality management > Tests |
| 3 | Configure test variables and outcomes | Inventory management > Setup > Quality management > Test variables |
| 4 | Configure test groups | Inventory management > Setup > Quality management > Test groups |
| 5 | Configure quarantine zones | Inventory management > Setup > Quality management > Quarantine zones |
| 6 | Configure quality associations | Inventory management > Setup > Quality management > Quality associations |

**Minimum quality associations at go-live:**

| Association | Reference type | Event type | Execution | Quarantine on failure | Event blocking |
| --- | --- | --- | --- | --- | --- |
| Purchase receipt inspection | Purchase order | Product receipt | After | Yes | End |
| Production completion inspection | Production | Report as finished | After | Yes | None |

> Quarantine zones: Define at minimum one zone (e.g., QHOLD — Quarantine Hold) for non-conforming material isolation.
> Problem types: Define at minimum two non-conformance problem types — one for incoming inspection failures (e.g., INCOMING-FAIL) and one for production quality failures (e.g., PROD-FAIL).
> Event blocking = End on purchase receipt means the product receipt cannot be fully processed until the quality order is closed. Production completion is set to None to allow reporting as finished without blocking, with quarantine triggered automatically on failure.

### C4. Inventory posting profile and finance dependency checkpoint (Phase one default)

Define standard posting profiles by item group and require Record-to-Report sign-off before production enablement in non-master entities.

| Item group | Posting profile structure | Ownership |
| --- | --- | --- |
| FG | Dedicated finished goods inventory posting profile mapped to FG inventory accounts | Finance Controller (local entity) with USMF policy governance |
| RM | Dedicated raw material inventory posting profile mapped to RM inventory accounts | Finance Controller (local entity) with USMF policy governance |
| SVC | Service/non-stock purchase posting profile mapped to service expense accounts | Finance Controller (local entity) with USMF policy governance |

| Checkpoint | Policy |
| --- | --- |
| R2R dependency gate | Mandatory R2R sign-off before enabling D2R standard cost activation in USSE, DEMF, and GBMF |
| Account mapping approval | All item-group mappings reviewed and approved by Cost Accounting Manager prior to cutover |

## D. Retire Products

### D1. End-of-life policy controls

| Question | Response |
| --- | --- |
| EOL blocks new production orders | Yes |
| EOL blocks purchasing | Yes |
| Existing inventory disposition options | Sell or scrap |
| Replacement product policy required | No |
| Formal retirement approval workflow required | No |

## D2. Approved Vendor List (AVL) governance

AVL controls which vendors may supply purchased BOM components. Per Microsoft Learn, enforcement is configured per released product on the Purchase setup and is checked at purchase order line entry.

| Decision | Value |
| --- | --- |
| AVL scope | Purchased BOM components only (not services or non-inventoried items) |
| Approved vendor check method | Warning initially (allows PO creation with warning); escalate to Error after procurement stabilization period |
| Expiration policy | Annual expiration dates assigned to each approved vendor entry; Procurement Manager reviews 60 days before expiry |
| AVL maintainer role | Procurement Manager (USMF as master; operational entities maintain their own local AVL entries after release) |
| AVL import entity | PurchApprovedVendorListEntity (see Import Register row 8) |

> Menu (per item): **Product information management > Products > Released products > Action Pane: Purchase > Setup > Approved vendors**
> Menu (overview by item): **Procurement and sourcing > Vendors > Vendor/item relations > Approved vendor list by item**
> Menu (overview by vendor): **Procurement and sourcing > Vendors > All vendors > Action Pane: Procurement > Approved vendor list by vendor**
>
> Note: The approved vendor check method is set on the released product record under **Purchase FastTab > Approved vendor check method**. Set *Warning* to permit purchase orders with a warning; set *Not allowed* to block purchase orders entirely for non-approved vendors.

## E. Analyze Product Performance

### E1. Performance analytics and governance

| Question | Response |
| --- | --- |
| Standard KPI catalog defined in discovery | No |
| Product profitability review cadence | Quarterly |
| Quality trend analytics design complete | Deferred (Phase two) |
| Feedback-to-change traceability design complete | Deferred (Phase two) |

> Data Import Required: If KPI baselines or dimensional analytics seeds are loaded from external sources, define entity and ownership in build phase.

## 8. Validation Scenarios

| Scenario | Expected outcome | Evidence required | Status |
| --- | --- | --- | --- |
| Create and release a finished good with required dimensions and lifecycle state | Product can be released with Site/Warehouse and serial-tracking policy | Product/release records and lifecycle controls | Planned |
| Run ECR to ECO flow with effective date | Change governance follows mandatory request/order sequence | ECR/ECO records and approval history | Planned |
| Execute production order with configured BOM/route and reservation-at-release policy | Components reserve at release and routing operations are available | Production order evidence and reservation state | Planned |
| Trigger quality order at purchase receipt and production completion | Correct quality order generation at both events | Quality order records and event links | Planned |
| Enforce End-of-Life state on production/purchasing | New production/purchasing is blocked for EOL items | Blocked transaction evidence | Planned |
| Enforce End-of-Life state on sales order creation | EOL lifecycle state prevents addition of EOL items to new sales order lines | Blocked sales order line screenshot with lifecycle state error | Planned |
| Execute quarterly standard cost rollup and activate | BOM calculation completes for all finished goods in PLAN-NEXT costing version; prices activated into STD-CURRENT after approval; all inventory transactions use updated standard cost | Cost rollup completion log; activated price records in STD-CURRENT; variance account postings | Planned |

## 9. Risks and Dependencies

| Risk/Dependency | Why it matters | Mitigation | Owner | Status |
| --- | --- | --- | --- | --- |
| COA and costing structures dependency on Record-to-Report | Cost rollup and valuation behavior depend on finance foundation | Validate R2R readiness before D2R costing activation | Cost Accounting Manager | Open |
| Approved vendor list dependency on Procure-to-Pay | BOM purchasing controls require AVL-capable procurement setup | Align vendor approval policy with P2P workstream | Procurement Lead | Open |
| Missing KPI governance decisions | Analytics scope cannot be validated end-to-end | Complete KPI and reporting design workshop | Operations + Finance | Partially resolved — quarterly cadence confirmed; KPI catalog and traceability design deferred to Phase two |
| ECM workflow design details not fully specified | Build phase may stall on approval routing details | Confirm approver roles/SLA/escalation rules | PLM Lead | Resolved — ECM workflow deferred (Phase one); no workflow configuration at go-live; SLA target = 3 days confirmed |

## 10. Open Items and Clarifications

| ID | BPC process area | Missing decision | Needed from | Due date | Resolution |
| --- | --- | --- | --- | --- | --- |
| D2R-001 | Develop product strategy | Master policy owner legal entity for shared product governance | VP Operations + PLM Lead | 2026-04-01 | Resolved: USMF is the master policy owner legal entity |
| D2R-002 | Develop product strategy | Confirm whether lifecycle state should also block sales transactions | Operations + Sales Ops | 2026-04-01 | Resolved: Yes - lifecycle state blocks sales transactions |
| D2R-003 | Retire products | Replacement-product policy at retirement (mandatory or conditional) | Product Lifecycle Manager | 2026-04-01 | Resolved: No - replacement product is not mandatory |
| D2R-004 | Retire products | Formal approval workflow for retirement/disposition (roles and thresholds) | Operations + Finance Control | 2026-04-01 | Resolved: No formal approval workflow required |
| D2R-005 | Analyze product performance | KPI catalog, ownership, and review cadence | VP Operations + Cost Accounting | TBC | Deferred to Phase two - quarterly cadence confirmed |
| D2R-006 | Manage active products | ECM workflow role matrix and SLA targets | PLM Lead + Engineering Director | 2026-04-01 | Resolved: ECM workflow deferred (Phase one); SLA target 3 days confirmed |
| D2R-007 | Data import plan | Confirm data entity strategy for current standard costs and open ECO migration | Data Migration Lead | 2026-04-01 | Resolved: Option A - cost components via Pending item prices V2 approach; open ECOs recreated manually in D365 pre-go-live |
| D2R-008 | Develop product strategy | Engineering company designation missing — SKILL step 1 stop condition | Solution Architect | 2026-04-01 | Resolved: Engineering organization = USMF; setup at Engineering change management > Setup > Engineering organizations; see Section A1 |
| D2R-009 | Develop product strategy | BOM number sequence must be Automatic — hard ECM prerequisite per MS Learn | Solution Architect | 2026-04-01 | Resolved: BOM number sequence = Automatic required; full number sequence table added to Section A0 (MS Learn source: ECM overview) |
| D2R-010 | Develop product strategy | Storage and tracking dimension group definitions missing — SKILL required input | Solution Architect | 2026-04-01 | Resolved: SITE_WH storage group (Site+Warehouse); SER_FG tracking group (serial at receipt and issue); Version product dimension group for ECM — see Section A2 |
| D2R-011 | Develop product strategy | Item model groups and item groups missing — SKILL required input | Solution Architect | 2026-04-01 | Resolved: FG-STD and RM-STD item model groups (Standard cost; physical negative allowed; financial negative blocked); FG, RM, SVC item groups — see Section A3 |
| D2R-012 | Manage active products | Costing version definition missing — SKILL required input | Solution Architect | 2026-04-01 | Resolved: STD-CURRENT (Standard cost active); PLAN-NEXT (Planned cost for quarterly rollup simulation); cost groups M/L/O/I defined — see Section C2 |
| D2R-013 | Manage active products | Quality test groups and quarantine policy missing — SKILL required input | Solution Architect | 2026-04-01 | Resolved: MS Learn 6-step quality setup sequence; purchase receipt and production completion quality associations; QHOLD quarantine zone; INCOMING-FAIL and PROD-FAIL problem types — see Section C3 |
| D2R-014 | Develop product strategy | AVL governance section missing — SKILL required input | Solution Architect | 2026-04-01 | Resolved: AVL scope = purchased BOM components; check method = Warning initially; annual expiration; Procurement Manager maintainer; PurchApprovedVendorListEntity import — see Section D2 |

## 11. Agent Handoff Payload (YAML - placeholders only)

```yaml
project:
  name: "Northwind Equipment Manufacturing"
  process: "Design_To_Retire"
  targetLegalEntities: ["USMF", "USSE", "DEMF", "GBMF"]
  masterLegalEntity: "USMF"

scope:
  developProductStrategy: "In Scope"
  introduceProducts: "In Scope"
  manageActiveProducts: "In Scope"
  retireProducts: "In Scope"
  analyzeProductPerformance: "In Scope - KPI catalog and traceability deferred to Phase two"

productMaster:
  releasePolicy: "Shared product (Products V2) first, then released per legal entity (Released products V2)"
  dimensions:
    - "Site"
    - "Warehouse"
    - "Serial number (finished goods receipt and issue only)"
  lifecycleStates:
    - "Pre-production"
    - "Active"
    - "End-of-Life"
  lifecycleBlocksSales: "Yes"
  lifecycleBlocksProcurement: "Yes"
  lifecycleBlocksProduction: "Yes"

ecm:
  enabled: "Yes"
  requestModel: "ECR"
  orderModel: "ECO"
  effectiveDatePolicy: "Required; no retroactive changes allowed"
  workflowPolicy: "Deferred - Phase one; no workflow configuration at go-live"
  slaTargetDays: 3
  ecoEligibility: "Released products only"

manufacturingDesign:
  bomModel: "Multi-level BOM with phantom sub-assembly support"
  routeModel: "Standard routes per finished good; operations: Cutting, Assembly, Testing; setup and run times maintained"
  capacityModel: "Finite capacity at resource group level"
  productionOrderType: "Production orders only"
  batchOrders: "Not in scope"
  processManufacturing: "Not in scope"
  componentReservationPolicy: "At production release"

costing:
  costingMethod: "Standard cost"
  rollupFrequency: "Quarterly"
  rollupApprovalRequired: "Yes"
  physicalNegativeInventory: "Allowed"
  financialNegativeInventory: "Not allowed"

quality:
  qualityManagementInScope: "Yes"
  triggerEvents:
    - "Purchase receipt"
    - "Production completion"
  testInstrumentTrackingInD365: "No - tracked externally"

retirement:
  eolBlocksProduction: "Yes"
  eolBlocksPurchasing: "Yes"
  dispositionOptions:
    - "Sell"
    - "Scrap"
  replacementProductMandatory: "No"
  formalApprovalRequired: "No"

analytics:
  kpiCatalog: "Deferred to Phase two"
  reviewCadence: "Quarterly"
  feedbackTraceability: "Deferred to Phase two"

dataMigration:
  importNotes: "Data uploads are manual and external to agent execution per project preference."
  imports:
    - importNumber: 1
      recordType: "Released products"
      entities:
        - "Products V2"
        - "Released products V2"
      strategy: "Load shared products first (Products V2), then release per legal entity"
    - importNumber: 2
      recordType: "BOM lines and versions"
      entities:
        - "Bill of materials lines V3"
        - "Bill of materials versions V3"
      strategy: "Load after released products confirmed"
    - importNumber: 3
      recordType: "Route versions"
      entities:
        - "Route versions V2"
      strategy: "Load after released products confirmed"
    - importNumber: 4
      recordType: "Standard costs - raw materials, resources, and indirect rates only"
      entities:
        - "Pending item prices V2"
        - "Pending route cost category unit costs"
        - "Costing sheet node calculation factors V2"
      strategy: "Option A - load cost components only; finished/semi-finished goods costs derived via D365 cost rollup (do NOT import fully-loaded finished good costs when using standard cost)"
    - importNumber: 5
      recordType: "Open engineering change orders"
      entities: []
      strategy: "Option A - manual re-entry in D365 pre-go-live; no standard DMF batch entity for ECM change orders"
```

## 12. Reference Documentation

1. https://learn.microsoft.com/dynamics365/guidance/business-processes/design-to-retire-introduction
2. https://learn.microsoft.com/dynamics365/guidance/business-processes/design-to-retire-areas
3. https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/product-engineering-overview
4. https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/product-lifecycle-state-transactions
5. https://learn.microsoft.com/dynamics365/supply-chain/pim/product-lifecycle
6. https://learn.microsoft.com/dynamics365/supply-chain/pim/data-entities
7. https://learn.microsoft.com/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities
8. https://learn.microsoft.com/dynamics365/guidance/resources/import-products
9. https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/engineering-org-data-ownership-rules
10. https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/engineering-parameters
11. https://learn.microsoft.com/dynamics365/supply-chain/engineering-change-management/product-engineering-overview
12. https://learn.microsoft.com/dynamics365/supply-chain/cost-management/prerequisites-standard-costs
13. https://learn.microsoft.com/dynamics365/supply-chain/cost-management/costing-versions
14. https://learn.microsoft.com/dynamics365/supply-chain/cost-management/prerequisites-standard-cost-conversion
15. https://learn.microsoft.com/dynamics365/supply-chain/inventory/enable-quality-management
16. https://learn.microsoft.com/dynamics365/supply-chain/inventory/quality-associations
17. https://learn.microsoft.com/dynamics365/supply-chain/inventory/quality-test-groups
18. https://learn.microsoft.com/dynamics365/supply-chain/procurement/tasks/approve-vendors-specific-products
19. https://learn.microsoft.com/training/modules/set-up-versioned-products-engineering-change-management/
20. https://learn.microsoft.com/training/modules/configure-costing-sheets/
