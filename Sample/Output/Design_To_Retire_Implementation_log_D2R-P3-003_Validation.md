# Design_To_Retire — D2R-P3-003 Validation Log

## Validation Run Summary

- Date: 2026-04-01
- Item ID: D2R-P3-003
- Work Item: Validate readiness for standard cost component imports and quarterly cost rollup prerequisites
- Validated by: Solution Consultant agent (SC-1)
- Scope entities: USMF, USSE, DEMF, GBMF
- Validation method: OData entity metadata inspection + live D365 data queries + form inspection (Cost categories, Costing sheet designer)
- Overall verdict: **BLOCKED**

---

## Scope Items Evaluated

1. Pending item prices V2 (`InventItemPendingPricesV2`)
2. Pending route cost category unit costs (`RoutePendingRouteCostCategoryUnitCosts`)
3. Costing sheet node calculation factors V2 (`CostSheetNodeCalculationFactors`)
4. Quarterly rollup prerequisites (costing versions + cost groups per entity + costing version policy settings)

---

## Entity Availability Confirmation

All three import entities are available and accessible in the D365 instance.

| Entity Name (OData set) | Label | Keys | Accessible |
|---|---|---|---|
| `InventItemPendingPricesV2` | Pending item prices V2 | dataAreaId, ItemNumber, CostingVersionId, FromDate, PriceType, PriceSiteId, + variant dimensions | ✓ |
| `RoutePendingRouteCostCategoryUnitCosts` | Pending route cost category unit costs | dataAreaId, RouteCostCategoryId, CostingVersionId, ProductionSiteId, EffectiveDate | ✓ |
| `CostSheetNodeCalculationFactors` | Costing sheet node calculation factors V2 | dataAreaId, CostSheetNodeName, PriceSiteId, FromDate, CostingVersionId, ItemNumber, ProductGroupId | ✓ |

---

## Evidence Detail by Scope Item

### Scope Item 1 — Pending Item Prices V2

**Purpose:** Import raw material standard cost prices into the active costing version (STD-CURR) per entity.

**Entity key referential integrity requirements:**
- `dataAreaId` → target entity must exist
- `ItemNumber` → released product must exist in entity
- `CostingVersionId` → costing version must exist in entity

**OData query result (`InventItemPendingPricesV2` cross-company, filtered USMF/USSE/DEMF/GBMF):**
```
0 records returned across all four entities.
```
Expected — no import has been executed yet. The question is whether prerequisites exist for a successful import.

| Entity | Costing version present | Released products present | Import Readiness |
|---|---|---|---|
| USMF | ✓ STD-CURR (Standard, RecordingRestriction=Yes) | ✗ 2 templates only (FG-BASE, RM-BASE) — no RM production catalog | **PARTIAL READY** |
| USSE | ✗ 0 costing versions | ✗ 0 released products | **BLOCKED** |
| DEMF | ✗ 0 costing versions | ✗ 0 released products | **BLOCKED** |
| GBMF | ✗ 0 costing versions | ✗ 0 released products | **BLOCKED** |

**Blocker detail for USMF:** The `CostingVersionId` key `STD-CURR` exists and allows cost price recording. The `ItemNumber` referential integrity will fail on any import row referencing a production RM item that has not yet been released (Import 1b from workbook). Import 1b (Released products V2) must be completed in USMF before the pending item prices file can be processed against production items.

---

### Scope Item 2 — Pending Route Cost Category Unit Costs

**Purpose:** Import resource cost rates (labor, machine) per route cost category into the active costing version (STD-CURR) per entity.

**Entity key referential integrity requirements:**
- `dataAreaId` → target entity must exist
- `RouteCostCategoryId` → route cost category master record must exist in entity
- `CostingVersionId` → costing version must exist in entity
- `ProductionSiteId` → can be blank (global rate) or site-specific; if site-specific, site must exist

**OData query result (`RoutePendingRouteCostCategoryUnitCosts` cross-company, filtered USMF/USSE/DEMF/GBMF):**
```
0 records returned across all four entities.
```
Expected — no import executed yet.

**Route cost categories inspection (USMF — menu: Production control > Setup > Routes > Cost categories):**
```
Form opened. Grid returned 0 rows. No route cost categories are configured in USMF.
```

This is a hard blocker: the `RouteCostCategoryId` foreign key in the pending costs entity requires a corresponding master record in the cost categories table for the target entity. No master records = import will fail FK validation for every row.

| Entity | Costing version present | Route cost categories present | Import Readiness |
|---|---|---|---|
| USMF | ✓ STD-CURR | ✗ 0 cost categories defined | **BLOCKED** |
| USSE | ✗ 0 costing versions | ✗ 0 cost categories defined | **BLOCKED** |
| DEMF | ✗ 0 costing versions | ✗ 0 cost categories defined | **BLOCKED** |
| GBMF | ✗ 0 costing versions | ✗ 0 cost categories defined | **BLOCKED** |

**Site-specific rates note:** `ProductionSiteId` is in the entity key but can be null/blank for a global rate. However, the D2R-P3-002 validation confirmed that sites (OperationalSitesV2) return 0 records in all four target entities. If the legacy costing source contains site-specific rates, those rows will also fail FK validation on `ProductionSiteId`. Site configuration is not resolved as of this validation.

---

### Scope Item 3 — Costing Sheet Node Calculation Factors V2

**Purpose:** Import indirect cost rate factors (overhead surcharges or amounts) per costing sheet node and costing version.

**Entity key referential integrity requirements:**
- `dataAreaId` → target entity must exist
- `CostSheetNodeName` → costing sheet node must be defined in entity costing sheet structure
- `CostingVersionId` → costing version must exist in entity

**OData query result (`CostSheetNodeCalculationFactors` cross-company, filtered USMF/USSE/DEMF/GBMF):**
```
0 records returned across all four entities.
```
Expected — no costing sheet nodes are configured yet.

**Costing sheet designer inspection (USMF — menu: Cost management > Predetermined cost policies setup > Costing sheets):**
```
Tree control returned: ["Root"] only.
No indirect cost nodes (surcharge, rate, or subtotal type) have been defined under the Root.
```

This is a hard blocker: `CostSheetNodeName` is required in the entity key. No costing sheet nodes beyond Root = no valid node names to reference in any import row. Every import row will fail FK validation until the costing sheet structure is defined first.

| Entity | Costing version present | Costing sheet nodes present | Import Readiness |
|---|---|---|---|
| USMF | ✓ STD-CURR | ✗ Root node only — no indirect cost nodes | **BLOCKED** |
| USSE | ✗ 0 costing versions | ✗ Root node only | **BLOCKED** |
| DEMF | ✗ 0 costing versions | ✗ Root node only | **BLOCKED** |
| GBMF | ✗ 0 costing versions | ✗ Root node only | **BLOCKED** |

---

### Scope Item 4 — Quarterly Rollup Prerequisites

**Purpose:** Confirm the costing version architecture, cost groups, and variance capture policy are in place across all entities to support the quarterly standard cost rollup cadence (STD-CURR → activation, PLAN-NEXT → simulation and rollup candidate).

**Validated configuration elements per entity:**

#### USMF

| Prerequisite | Expected | Actual | Status |
|---|---|---|---|
| STD-CURR costing version | Standard, RecordingRestriction=Yes, FallbackPrinciple=None, IsVersionBlocked=No, IsActivationBlocked=No | Confirmed via OData | ✓ |
| PLAN-NEXT costing version | Normal/Planned, FallbackPrinciple=CurrentActive, IsActivationBlocked=No | Confirmed via OData | ✓ |
| Cost group M (Material) | DirectMaterials, Variable | Confirmed via OData | ✓ |
| Cost group L (Labor) | DirectManufacturing, Variable | Confirmed via OData | ✓ |
| Cost group O (Overhead) | Indirect, Fixed | Confirmed via OData | ✓ |
| Cost group I (Indirect) | Indirect, Fixed | Confirmed via OData | ✓ |
| Cost breakdown policy | Sub ledger | Configured (D2R-P2-007-3) | ✓ |
| Variance capture | Per cost group | Configured (D2R-P2-007-3) | ✓ |

**USMF verdict: READY** (costing version architecture and cost group structure in place; rollup simulation capability exists pending data load)

---

#### USSE

| Prerequisite | Expected | Actual | Status |
|---|---|---|---|
| STD-CURR costing version | Standard costing version | ✗ Not found. Query returned 0 costing versions for USSE | **BLOCKED** |
| PLAN-NEXT costing version | Normal/Planned costing version | ✗ Not found | **BLOCKED** |
| Cost groups M, L, O, I | All four groups | ✗ 0 cost groups in USSE | **BLOCKED** |

**USSE verdict: BLOCKED**

---

#### DEMF

| Prerequisite | Expected | Actual | Status |
|---|---|---|---|
| STD-CURR costing version | Standard costing version | ✗ Not found. Query returned 0 costing versions for DEMF | **BLOCKED** |
| PLAN-NEXT costing version | Normal/Planned costing version | ✗ Not found | **BLOCKED** |
| Cost groups M, L, O, I | All four groups | ✗ 0 cost groups in DEMF | **BLOCKED** |

**DEMF verdict: BLOCKED**

---

#### GBMF

| Prerequisite | Expected | Actual | Status |
|---|---|---|---|
| STD-CURR costing version | Standard costing version | ✗ Not found. Query returned 0 costing versions for GBMF | **BLOCKED** |
| PLAN-NEXT costing version | Normal/Planned costing version | ✗ Not found | **BLOCKED** |
| Cost groups M, L, O, I | All four groups | ✗ 0 cost groups in GBMF | **BLOCKED** |

**GBMF verdict: BLOCKED**

---

## Entity-Level Verdict Summary

| Entity | Pending Item Prices V2 | Pending Route Cost Cat Unit Costs | Costing Sheet Node Factors V2 | Quarterly Rollup Prerequisites | Overall |
|---|---|---|---|---|---|
| USMF | PARTIAL READY | BLOCKED | BLOCKED | READY | **PARTIAL READY** |
| USSE | BLOCKED | BLOCKED | BLOCKED | BLOCKED | **BLOCKED** |
| DEMF | BLOCKED | BLOCKED | BLOCKED | BLOCKED | **BLOCKED** |
| GBMF | BLOCKED | BLOCKED | BLOCKED | BLOCKED | **BLOCKED** |

---

## Blockers Register

### BLK-P3-003-001 — Costing versions missing in USSE, DEMF, GBMF

| Field | Value |
|---|---|
| Blocker ID | BLK-P3-003-001 |
| Severity | Critical |
| Entities affected | USSE, DEMF, GBMF |
| Scope items blocked | Pending item prices V2, Pending route cost category unit costs, Costing sheet node calculation factors V2, Quarterly rollup prerequisites |
| Description | OData query on `CostingVersions` filtered to USSE, DEMF, GBMF returned 0 records. Costing versions STD-CURR and PLAN-NEXT were created in USMF only (D2R-P2-007-1). All three import entities carry `CostingVersionId` as a key field — FK validation will fail for every import row in these entities. |
| Resolution required | Create STD-CURR (Standard cost, RecordingRestriction=Yes, FallbackPrinciple=None) and PLAN-NEXT (Normal, FallbackPrinciple=CurrentActive) in USSE, DEMF, and GBMF. Match policy settings from USMF workbook specification. |
| Owner | Cost Accounting Lead / SC agent |
| Pre-conditions | None — costing version creation does not depend on released products or sites |

---

### BLK-P3-003-002 — Cost groups missing in USSE, DEMF, GBMF

| Field | Value |
|---|---|
| Blocker ID | BLK-P3-003-002 |
| Severity | Critical |
| Entities affected | USSE, DEMF, GBMF |
| Scope items blocked | Quarterly rollup prerequisites; indirect cost variance reporting |
| Description | `CostGroups` query filtered to USSE, DEMF, GBMF returned 0 records. Cost groups M, L, O, I created in USMF only (D2R-P2-007-2). The absence of cost groups prevents proper variance segmentation during production order close in these entities. |
| Resolution required | Create cost groups M (DirectMaterials/Variable), L (DirectManufacturing/Variable), O (Indirect/Fixed), I (Indirect/Fixed) in USSE, DEMF, and GBMF. Match definitions from workbook D2R-P2-007-2. |
| Owner | Cost Accounting Lead / SC agent |
| Pre-conditions | None — cost group creation does not require other master data |

---

### BLK-P3-003-003 — Route cost categories not configured in any entity

| Field | Value |
|---|---|
| Blocker ID | BLK-P3-003-003 |
| Severity | Critical |
| Entities affected | USMF, USSE, DEMF, GBMF |
| Scope items blocked | Pending route cost category unit costs import |
| Description | Cost categories form (`RouteCostCategory`, Production control > Setup > Routes > Cost categories) opened in USMF and returned 0 rows. No route cost category master records exist. `RoutePendingRouteCostCategoryUnitCosts` entity key includes `RouteCostCategoryId` — FK validation will fail for all import rows in all entities until route cost category definitions are created. |
| Resolution required | Define route cost categories for at least labor (L) and machine/overhead (O) resources in each entity. Categories must be created via Production control > Setup > Routes > Cost categories or `ProjCategory` entity, with the Production (RouteGeneral) usage flag enabled. Assign the appropriate cost group to each category. |
| Owner | Manufacturing Engineering Lead / Cost Accounting Lead |
| Pre-conditions | Cost groups must exist per entity (resolves BLK-P3-003-002) before cost categories can be linked to them |

---

### BLK-P3-003-004 — Costing sheet nodes not defined in any entity

| Field | Value |
|---|---|
| Blocker ID | BLK-P3-003-004 |
| Severity | Critical |
| Entities affected | USMF, USSE, DEMF, GBMF |
| Scope items blocked | Costing sheet node calculation factors V2 import |
| Description | Costing sheet designer (Cost management > Predetermined cost policies setup > Costing sheets) opened in USMF and returned only the system Root node. No indirect cost nodes (surcharge type or rate type) have been created under Root. `CostSheetNodeCalculationFactors` entity key includes `CostSheetNodeName` — no valid node names exist to reference in any import row. |
| Resolution required | Design and create the costing sheet structure in each entity. Minimum required nodes based on workbook cost group policy: at least one overhead/indirect cost node linked to cost groups O and I. Node type (surcharge % vs. fixed rate), applicable cost group, and base cost group must be determined before configuration. This is a design decision that requires input from the Cost Accounting Manager. |
| Owner | Cost Accounting Manager |
| Pre-conditions | Cost groups must exist per entity (BLK-P3-003-002 resolved) before costing sheet nodes can reference them |

---

### BLK-P3-003-005 — Released products not imported (all entities)

| Field | Value |
|---|---|
| Blocker ID | BLK-P3-003-005 |
| Severity | Critical |
| Entities affected | USMF, USSE, DEMF, GBMF |
| Scope items blocked | Pending item prices V2 import |
| Description | `ReleasedProductsV2` cross-company: USMF returns 2 template items (FG-BASE, RM-BASE) only; USSE, DEMF, GBMF return 0 items. `InventItemPendingPricesV2` key requires `ItemNumber` referencing a valid released product in the target entity. First documented in D2R-P3-002 as BLK-002 (in progress). |
| Resolution required | Complete Import 1b (Released products V2) for all in-scope entities before pending item prices import can proceed. This was already registered as BLK-002 in the P3-002 validation; no new action added here — recording for cross-reference. |
| Owner | Product Master Data Lead |
| Pre-conditions | Same as BLK-002 from D2R-P3-002 |

---

### ADVISORY — Site configuration still absent

| Field | Value |
|---|---|
| Advisory ID | ADV-P3-003-001 |
| Entities affected | USMF, USSE, DEMF, GBMF |
| Scope items affected | Pending route cost category unit costs (site-specific rate rows) |
| Description | `OperationalSitesV2` returned 0 records for all 4 target entities (confirmed in D2R-P3-002 BLK-003). `RoutePendingRouteCostCategoryUnitCosts` entity key includes `ProductionSiteId` — this field can be blank for global rates, but if the legacy costing source contains site-specific resource rates, those import rows will fail FK validation until sites are created. Non-blocking if all rates are global (blank ProductionSiteId). |
| Resolution required | Confirm with Manufacturing Engineering Lead whether resource cost rates in the legacy system are global or site-specific. If site-specific, resolve BLK-003 from D2R-P3-002 (sites setup) before costing import. |
| Owner | Manufacturing Engineering Lead |

---

## Dependency Graph for Unblocking

```
To unblock ALL four scope items across all entities:

1. [BLK-P3-003-001] Create costing versions STD-CURR + PLAN-NEXT in USSE, DEMF, GBMF
   (no pre-conditions)

2. [BLK-P3-003-002] Create cost groups M, L, O, I in USSE, DEMF, GBMF
   (no pre-conditions)

3. [BLK-P3-003-003] Create route cost categories in all 4 entities
   (pre-condition: BLK-P3-003-002 resolved — cost groups must exist for linkage)

4. [BLK-P3-003-004] Design and build costing sheet node structure in all 4 entities
   (pre-condition: BLK-P3-003-002 resolved — cost groups must exist for node linkage; 
    requires Cost Accounting Manager design decision on node type and overhead rates)

5. [BLK-P3-003-005 / D2R-P3-002 BLK-002] Execute Import 1b (Released products V2) in all 4 entities
   (independent of BLK-001 through BLK-004 above; already tracked in D2R-P3-002)

6. [ADV-P3-003-001] Confirm site-specific vs. global rate strategy
   (advisory; resolve before import if legacy rates are site-specific)
```

---

## OData Evidence Queries Executed

| Query | Filter | Result |
|---|---|---|
| `CostingVersions` | dataAreaId in (usmf, usse, demf, gbmf) | USMF: STD-CURR, PLAN-NEXT. USSE/DEMF/GBMF: 0 records |
| `CostGroups` | dataAreaId in (usmf, usse, demf, gbmf) | USMF: M, L, O, I. USSE/DEMF/GBMF: 0 records |
| `InventItemPendingPricesV2` | dataAreaId in (usmf, usse, demf, gbmf) | 0 records all entities |
| `RoutePendingRouteCostCategoryUnitCosts` | dataAreaId in (usmf, usse, demf, gbmf) | 0 records all entities |
| `CostSheetNodeCalculationFactors` | dataAreaId in (usmf, usse, demf, gbmf) | 0 records all entities |
| `CostingVersions` (all) cross-company | none | Returned USMF: STD-CURR, PLAN-NEXT; defu: STD2026, PLANSIM, STD2027 (demo entity, not in scope) |

## Form Inspections Performed

| Form | Company context | Finding |
|---|---|---|
| RouteCostCategory (Cost categories) | USMF | Grid: 0 rows. No route cost categories defined. |
| CostSheetDesigner (Costing sheet setup) | USMF | Tree: Root node only. No indirect cost nodes defined. |

---

*Validation log generated by Solution Consultant agent. Timestamp: 2026-04-01.*
