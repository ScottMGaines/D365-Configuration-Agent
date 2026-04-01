# Design-to-Retire Implementation Log — Data Load Readiness Validation Activity (D2R-P3-002)

**Process:** Design-to-Retire (D2R)
**Phase:** Phase 3 — Data Load Readiness Validation
**Item ID:** D2R-P3-002
**Work Item:** Validate readiness for BOM and Route baseline imports including referential integrity prerequisites
**Execution Date:** 2026-04-01
**Executed By:** Solution Consultant (SC-1)

---

## Run Summary

| Field | Value |
| --- | --- |
| **Date** | 2026-04-01 |
| **Process** | Design-to-Retire (D2R) |
| **Implement File** | `Processes/Implement_Design_To_Retire.template.md` |
| **Skill File** | `.github/skills/Design-to-Retire/SKILL.md` |
| **Legal Entity Scope** | USMF, USSE, DEMF, GBMF (all 4 target entities) |
| **Activity** | Data Load Readiness Validation for Bill of Materials Lines V3, Bill of Materials Versions V3/V4, and Route Versions V2 |
| **Overall Status** | 🔴 **BLOCKED** — Three critical prerequisite gaps prevent BOM and Route import in all entities |
| **Prerequisite P3-001 BLK-001** | ✅ **RESOLVED** — Item model groups FG-STD and RM-STD confirmed in USSE, DEMF, GBMF with compliant costing model |
| **Execution Mode** | Read-only validation; no configuration changes applied |

---

## Final Status: BLOCKED

| Entity | Bill of Materials Lines V3 | Bill of Materials Versions V4 | Route Versions V2 | Overall |
| --- | --- | --- | --- | --- |
| **USMF** | 🔴 BLOCKED | 🔴 BLOCKED | 🔴 BLOCKED | **🔴 BLOCKED** |
| **USSE** | 🔴 BLOCKED | 🔴 BLOCKED | 🔴 BLOCKED | **🔴 BLOCKED** |
| **DEMF** | 🔴 BLOCKED | 🔴 BLOCKED | 🔴 BLOCKED | **🔴 BLOCKED** |
| **GBMF** | 🔴 BLOCKED | 🔴 BLOCKED | 🔴 BLOCKED | **🔴 BLOCKED** |

> **Overall Assessment: BLOCKED** — No import entity can proceed in any legal entity. Three structural blockers must be resolved in dependency order before imports can be executed.

---

## Prerequisite Status from D2R-P3-001 (BLK-001 Resolution)

### BLK-001: Item Model Groups — **RESOLVED** ✅

D2R-P3-001 identified that item model groups FG-STD and RM-STD were missing in USSE, DEMF, and GBMF and blocked Released products V2 import.

**Live evidence from D2R-P3-002 validation query (InventModelGroupCDREntities, cross-company):**

| Entity | ModelGroupId | InventModel | NegativePhysical | NegativeFinancial | Name | Status |
| --- | --- | --- | --- | --- | --- | --- |
| usmf | FG-STD | StdCost | Yes | No | Finished goods - standard cost | ✅ Compliant |
| usmf | RM-STD | StdCost | Yes | No | Raw materials - standard cost | ✅ Compliant |
| usse | FG-STD | StdCost | Yes | No | Finished Goods - Standard Cost | ✅ Compliant |
| usse | RM-STD | StdCost | Yes | No | Raw Materials - Standard Cost | ✅ Compliant |
| demf | FG-STD | StdCost | Yes | No | Finished Goods - Standard Cost | ✅ Compliant |
| demf | RM-STD | StdCost | Yes | No | *(blank)* | ✅ Compliant (⚠️ Name blank) |
| gbmf | FG-STD | StdCost | Yes | No | *(blank)* | ✅ Compliant (⚠️ Name blank) |
| gbmf | RM-STD | StdCost | Yes | No | *(blank)* | ✅ Compliant (⚠️ Name blank) |

**BLK-001 Resolution Conclusion:** All 4 entities have both FG-STD and RM-STD with correct InventModel=StdCost, NegativePhysical=Yes, NegativeFinancial=No. BLK-001 from D2R-P3-001 is **resolved and confirmed by live query in this validation run**.

> **Advisory (non-blocking):** DEMF RM-STD and GBMF FG-STD/RM-STD have blank Name fields. These are cosmetic data quality gaps; they do not block Released products V2 or BOM/Route imports. A data admin can correct via OData update or form edit at any time.

---

## Entity Metadata and Referential Integrity Findings

### Bill of Materials Lines V3 (`BillOfMaterialsLinesV3`)

**Entity confirmed present in D365:** ✅ `BillOfMaterialsLineV3`

**Primary key fields:**
- `dataAreaId` (legal entity)
- `BOMId` (references BOM header)
- `LineCreationSequenceNumber`

**Critical referential integrity dependencies:**
| Dependency Field | Required Object | Current State |
| --- | --- | --- |
| `BOMId` | BOM header must exist (`BillOfMaterialsHeaders`) | 🔴 0 BOM headers in any entity |
| `ItemNumber` | Component item must be a released product in the legal entity | 🔴 Production catalog not imported — only 2 templates in USMF; 0 in others |
| `ProductUnitSymbol` | UOM must exist | ✅ EA configured (assumed shared; verified for template items) |
| `ConsumptionSiteId` | Site must exist (if site-specific consumption) | 🔴 0 sites in target entities |

**Import sequence dependency:** BOM Lines V3 can only be imported **after** BOM Versions/Headers are created. The BOM version import creates the BOM header, then lines are imported referencing the BOM ID.

---

### Bill of Materials Versions V4 (`BillOfMaterialsVersionsV4`)

> ⚠️ **Entity Version Discrepancy:** The workbook Import Register (row 2) references "Bill of materials versions V3". This entity designation does not exist in the current D365 instance. Available entity versions are: **V4** (`BillOfMaterialsVersionsV4`, label "Bill of materials versions V4") and **V2** (`BillOfMaterialsVersionsODataV2`). This validation used V4 as the authoritative current entity. The Import Register must be corrected.

**Entity confirmed present in D365:** ✅ `BillOfMaterialsVersionV4`

**Primary key fields:**
- `dataAreaId`
- `ManufacturedItemNumber` (released product in entity)
- `BOMId`
- `ProductionSiteId` (can be blank for company-wide BOMs)
- `ProductConfigurationId`, `ProductColorId`, `ProductSizeId`, `ProductStyleId`, `ProductVersionId` (blank for non-variant items)
- `IsActive`, `ValidFromDate`, `FromQuantity`, `SequenceId`

**Critical referential integrity dependencies:**
| Dependency Field | Required Object | Current State |
| --- | --- | --- |
| `ManufacturedItemNumber` | Released product must exist per legal entity | 🔴 Production catalog not imported |
| `ProductionSiteId` | Site must exist (if site-specific BOM) | 🔴 0 sites in target entities |
| `IsApproved` | Approval governance baseline | ✅ Field present; approval can be deferred post-import |
| `ApproverPersonnelNumber` | Worker must exist if approval set at import | ⚠️ Not validated; advisory concern |

---

### Route Versions V2 (`RouteVersionsV2`)

**Entity confirmed present in D365:** ✅ `RouteVersionV2` (note: system label shown as "BOM versions V2" in entity search — this is a misleading label; the technical name is `RouteVersionsV2` and it processes route version data)

**Primary key fields:**
- `dataAreaId`
- `ItemNumber` (released product)
- `RouteId` (route header)
- `ProductionSiteId` (site)
- `ValidFromDate`, `ValidFromQuantity`
- `ProductConfigurationId`, `ProductColorId`, `ProductSizeId`, `ProductStyleId`, `ProductVersionId`, `IsActive`

**Critical referential integrity dependencies:**
| Dependency Field | Required Object | Current State |
| --- | --- | --- |
| `ItemNumber` | Released product must exist per entity | 🔴 Production catalog not imported |
| `RouteId` | Route header must exist (`RouteHeaders`) | 🔴 0 route headers in any entity |
| `ProductionSiteId` | Site must exist (if site-specific) | 🔴 0 sites in target entities |
| Base operations | `Operations` entity must have operation records before route operations are defined | 🔴 0 base operations defined anywhere |

---

## Per-Prerequisite Findings Across All Entities

### 1. Released Products (Import 1b prerequisite from D2R-P3-001)

| Entity | Records Found | Notes |
| --- | --- | --- |
| USMF | 2 (FG-BASE, RM-BASE) | Template items only — production catalog not imported. Imported items are reference templates not the full BOM/route item catalog |
| USSE | 0 | Released products V2 import (Import 1b) not yet executed |
| DEMF | 0 | Released products V2 import (Import 1b) not yet executed |
| GBMF | 0 | Released products V2 import (Import 1b) not yet executed |

**OData source:** `ReleasedProductsV2`, `$filter=dataAreaId eq 'usmf'` / equivalent per entity, `cross-company=true`

**Conclusion:** Released products prerequisite is **not satisfied** in any entity at production-catalog scale. BLK-001 resolution (item model groups) enables Import 1b to proceed, but Import 1b has not yet been executed. BOM and Route imports are gated behind Import 1b completion.

---

### 2. Operational Sites

| Entity | Sites Found | Site IDs | Notes |
| --- | --- | --- | --- |
| USMF | 0 | — | No sites configured in target entity |
| USSE | 0 | — | No sites configured |
| DEMF | 0 | — | No sites configured |
| GBMF | 0 | — | No sites configured |
| defu (reference) | 1 | SEA | Seattle Corporate DC — demo entity only |
| defm (reference) | 1 | MKE | Milwaukee Plant — demo entity only |

**OData source:** `OperationalSitesV2`, `cross-company=true`

**Conclusion:** No operational sites exist in any D2R target entity. Sites are required for Northwind's site-based discrete manufacturing model. BOM Versions V4 and Route Versions V2 include `ProductionSiteId` as a key field. This must be resolved before BOM/route import.

> **Note on non-site BOMs:** The `ProductionSiteId` key field can technically be empty (company-wide BOM/route). However, the Northwind workbook explicitly specifies resource-group-based capacity planning with site and warehouse dimensions active. Importing company-wide BOMs/routes without site assignment would be inconsistent with the workbook design intent.

---

### 3. BOM Headers

| Cross-company Query Result | Notes |
| --- | --- |
| 0 records | Expected for pre-import state. BOM headers are created as part of the BOM Versions import (BOM ID is generated or provided). This is not a standalone blocker — BOM headers are created during the BOM versions import itself. |

**OData source:** `BillOfMaterialsHeaders`, `cross-company=true`

**Conclusion:** Not a standalone blocker. BOM headers will be created when BOM versions are imported.

---

### 4. Route Headers

| Cross-company Query Result | Notes |
| --- | --- |
| 0 records | Route headers must exist before Route Operations V2 can reference them, and before Route Versions V2 can be assigned. |

**OData source:** `RouteHeaders`, `cross-company=true`

**Conclusion:** Route headers must be created (manually or via import) before Route Versions V2 import can proceed.

---

### 5. Base Operations

| Cross-company Query Result | Notes |
| --- | --- |
| 0 records | Critical blocker for all route-related imports. Operations are production-shared setup objects that route operations reference. |

**OData source:** `Operations`, `cross-company=true`

**Conclusion:** Zero base operations are defined. The Northwind workbook specifies operations for cutting, assembly, and testing with maintained setup/run times. These must be defined in Production control > Setup > Routes > Operations before any route operations or route versions can reference them.

---

### 6. Route Operations V2

| Cross-company Query Result | Notes |
| --- | --- |
| 0 records | Expected — no operations or route headers exist yet. Route operations are the link between a route header and base operations, including resource group assignments. |

**OData source:** `RouteOperationsV2`, `cross-company=true`

---

### 7. Import Entity Version — BOM Versions

| Plan Reference | Available Entity | Assessment |
| --- | --- | --- |
| "Bill of materials versions V3" | `BillOfMaterialsVersionsV4` (current) | ⚠️ **MISMATCH** — V3 does not exist |
| | `BillOfMaterialsVersionsODataV2` (older OData variant) | Alternative option; V4 is preferred |

**Action required:** Workbook Import Register row 2 must be updated to reference the correct entity name before data load preparation. Recommended correction: `BillOfMaterialsVersionsV4`.

---

## Blocker Summary

### BLK-002 (Critical): Released Products — Production Catalog Not Imported

| Field | Detail |
| --- | --- |
| **Blocker ID** | BLK-002 |
| **Scope** | All entities: USMF, USSE, DEMF, GBMF |
| **Root Cause** | Import 1b (Released products V2) has not been executed. Item model group prerequisite (BLK-001) is now resolved, but the actual import has not run. Production catalog items referenced in BOM and Route source data do not exist as released products in any entity. |
| **Blocking** | Bill of Materials Lines V3, Bill of Materials Versions V4, Route Versions V2 — all three import entities |
| **Resolution** | Execute Import 1b (Released products V2) for USMF, USSE, DEMF, GBMF. Verification: `ReleasedProductsV2` per entity should return the full production item catalog before BOM/Route import is triggered. |
| **Owner** | Product Master Data Lead |
| **Dependency** | BLK-001 (item model groups) — **already resolved** |
| **Target Date** | Before Import 2 (BOM) and Import 3 (Route) are attempted |

---

### BLK-003 (Critical): Sites Not Configured in Target Entities

| Field | Detail |
| --- | --- |
| **Blocker ID** | BLK-003 |
| **Scope** | All entities: USMF, USSE, DEMF, GBMF |
| **Root Cause** | Operational sites have not been created in any D2R target legal entity. Only demo entities `defu` and `defm` have sites (SEA and MKE respectively). |
| **Blocking** | Bill of Materials Versions V4 (ProductionSiteId), Route Versions V2 (ProductionSiteId) — site-specific assignments will fail |
| **Resolution** | Determine manufacturing site IDs and names per legal entity. Create via: Inventory management > Setup > Inventory breakdown > Sites, or data import using `OperationalSitesV2` entity (key: `dataAreaId` + `SiteId`). |
| **Owner** | SCM / Manufacturing Configuration Lead |
| **Target Date** | Before Import 2 (BOM) and Import 3 (Route) are attempted |

---

### BLK-004 (Critical): Base Operations Not Defined

| Field | Detail |
| --- | --- |
| **Blocker ID** | BLK-004 |
| **Scope** | All entities: USMF, USSE, DEMF, GBMF |
| **Root Cause** | Zero Operation records (`Operations` entity) exist cross-company. Route Versions V2 import requires route headers with route operations that reference base Operation records. The workbook specifies cutting, assembly, and testing operations with setup/run times — none of these exist in D365. |
| **Blocking** | Route Versions V2 — cannot be imported without route operations, which cannot be defined without base operations |
| **Resolution** | Define base operations in Production control > Setup > Routes > Operations. Minimum required: Cutting, Assembly, Testing (per workbook). Include setup times and run times for each. After operations are defined: (1) Create route headers, (2) Create route operations linking operations to route headers with resource group assignments, (3) Then import Route Versions V2. |
| **Owner** | Manufacturing Engineering Lead |
| **Target Date** | Before Import 3 (Route versions V2) is attempted |

---

### FYI-001 (Advisory): Import Plan Entity Version Discrepancy

| Field | Detail |
| --- | --- |
| **Finding ID** | FYI-001 |
| **Scope** | Workbook Import Register (row 2) |
| **Issue** | The workbook references "Bill of materials versions V3" as a D365 data entity. This entity does not exist in the current D365 instance. Available versions are: V4 (`BillOfMaterialsVersionsV4`) and V2 OData variant (`BillOfMaterialsVersionsODataV2`). |
| **Recommended Action** | Update Import Register row 2 entity name from "Bill of materials versions V3" to "Bill of materials versions V4" (`BillOfMaterialsVersionsV4`) before data load file preparation begins. This affects import templates, column mapping, and data load sequencing documentation. |
| **Owner** | Product Master Data Lead / Solution Architect |
| **Severity** | Advisory — does not block configuration; becomes a blocking import preparation error if not corrected before load file construction |

---

## Prerequisite Dependency Resolution Order

The following sequence must be followed before any BOM or Route import can execute:

```
Step 1:  Confirm released products V2 import preparation is ready (prerequisite from P3-001)
Step 2:  Configure operational sites per entity (BLK-003) 
Step 3:  Execute Import 1b — Released products V2 per entity (resolves BLK-002)
Step 4:  Define base operations: Cutting, Assembly, Testing (resolves BLK-004)
Step 5:  Create route headers per entity/site
Step 6:  Correct workbook Import Register entity name: V3 → V4 (resolves FYI-001)
Step 7:  Import 2 — Bill of Materials Lines V3 + Bill of Materials Versions V4 (both USMF first, then USSE/DEMF/GBMF)
Step 8:  Import 3 — Route Versions V2 (after step 4–5 complete; USMF first)
```

---

## Readiness Summary Table

### Bill of Materials Lines V3

| Prerequisite | USMF | USSE | DEMF | GBMF | Notes |
| --- | --- | --- | --- | --- | --- |
| Released products (BOM components) | ⚠️ 2 templates only | 🔴 0 records | 🔴 0 records | 🔴 0 records | Import 1b required |
| Item model groups | ✅ | ✅ (BLK-001 resolved) | ✅ (BLK-001 resolved) | ✅ (BLK-001 resolved) | Prerequisite satisfied |
| BOM headers (created during BOM Versions import) | N/A | N/A | N/A | N/A | Not a standalone blocker |
| Sites (for site-specific components) | 🔴 0 | 🔴 0 | 🔴 0 | 🔴 0 | BLK-003 |
| BOM Lines V3 Readiness | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | |

### Bill of Materials Versions V4 (V3 referenced in plan — FYI-001)

| Prerequisite | USMF | USSE | DEMF | GBMF | Notes |
| --- | --- | --- | --- | --- | --- |
| Released products (ManufacturedItemNumber) | ⚠️ 2 templates only | 🔴 0 records | 🔴 0 records | 🔴 0 records | Import 1b required |
| Item model groups | ✅ | ✅ | ✅ | ✅ | BLK-001 resolved |
| Sites (ProductionSiteId) | 🔴 0 | 🔴 0 | 🔴 0 | 🔴 0 | BLK-003 |
| Entity version name (V3 vs V4) | ⚠️ Plan incorrect | ⚠️ Plan incorrect | ⚠️ Plan incorrect | ⚠️ Plan incorrect | FYI-001 |
| BOM Versions V4 Readiness | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | |

### Route Versions V2

| Prerequisite | USMF | USSE | DEMF | GBMF | Notes |
| --- | --- | --- | --- | --- | --- |
| Released products (ItemNumber) | ⚠️ 2 templates only | 🔴 0 records | 🔴 0 records | 🔴 0 records | Import 1b required |
| Item model groups | ✅ | ✅ | ✅ | ✅ | BLK-001 resolved |
| Sites (ProductionSiteId) | 🔴 0 | 🔴 0 | 🔴 0 | 🔴 0 | BLK-003 |
| Base operations | 🔴 0 | 🔴 0 | 🔴 0 | 🔴 0 | BLK-004 |
| Route headers | 🔴 0 | 🔴 0 | 🔴 0 | 🔴 0 | Depends on operations |
| Route Versions V2 Readiness | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | 🔴 **BLOCKED** | |

---

## OData Evidence Log

| Query | Entity | Filter | Result |
| --- | --- | --- | --- |
| Released products — USMF | ReleasedProductsV2 | dataAreaId eq 'usmf' | 2 rows: FG-BASE, RM-BASE (EA/Item) |
| Released products — USSE | ReleasedProductsV2 | dataAreaId eq 'USSE' | 0 rows |
| Released products — DEMF | ReleasedProductsV2 | dataAreaId eq 'DEMF' | 0 rows |
| Released products — GBMF | ReleasedProductsV2 | dataAreaId eq 'GBMF' | 0 rows |
| Sites — all entities | OperationalSitesV2 | cross-company=true | 2 rows: defu/SEA, defm/MKE — 0 rows in USMF/USSE/DEMF/GBMF |
| Sites — USMF explicit | OperationalSitesV2 | dataAreaId eq 'usmf' | 0 rows |
| Sites — USSE/DEMF/GBMF explicit | OperationalSitesV2 | dataAreaId eq 'usse' or 'demf' or 'gbmf' | 0 rows |
| BOM headers | BillOfMaterialsHeaders | cross-company=true | 0 rows |
| Route headers | RouteHeaders | cross-company=true | 0 rows |
| Base operations | Operations | cross-company=true | 0 rows |
| Route operations V2 | RouteOperationsV2 | cross-company=true | 0 rows |
| Item model groups (BLK-001 check) | InventModelGroupCDREntities | cross-company=true, SysDataAreaId in all 4 | 11 rows: usmf (2), usse (2), demf (2), gbmf (2), defu (3) — all target entities have FG-STD and RM-STD with StdCost |
| BOM entity metadata | BillOfMaterialsLinesV3 | metadata only | Keys: dataAreaId, BOMId, LineCreationSequenceNumber; ItemNumber field confirmed |
| BOM Versions entity metadata | BillOfMaterialsVersionsV4 | metadata only | Keys: dataAreaId, ManufacturedItemNumber, BOMId, ProductionSiteId... confirmed |
| Route Versions entity metadata | RouteVersionsV2 | metadata only | Keys: dataAreaId, ItemNumber, RouteId, ProductionSiteId... confirmed |

---

## Recommendations to Project Manager

### Immediate Actions (Next 48 hours)

1. **ASSIGN BLK-002 RESOLUTION — Released Products Import (Import 1b)**
   - Owner: Product Master Data Lead
   - Task: Execute Released products V2 import for USMF, USSE, DEMF, GBMF
   - Prerequisite satisfied: Item model groups (BLK-001) confirmed resolved
   - Verification: `ReleasedProductsV2` per entity must return full production catalog count
   - Estimated time: 2–4 hours including file preparation and validation

2. **ASSIGN BLK-003 RESOLUTION — Site Configuration**
   - Owner: SCM / Manufacturing Configuration Lead
   - Task: Define manufacturing site IDs and names per entity; create in D365
   - Input required: Site IDs for USMF, USSE, DEMF, GBMF manufacturing locations
   - Method: Inventory management > Setup > Inventory breakdown > Sites, or OData create via `OperationalSitesV2`
   - Estimated time: 30–60 minutes per entity

3. **ASSIGN BLK-004 RESOLUTION — Base Operations**
   - Owner: Manufacturing Engineering Lead
   - Task: Define base operations (minimum: Cutting, Assembly, Testing) with setup/run times
   - Method: Production control > Setup > Routes > Operations
   - Dependency: Must be completed before any route version import
   - Estimated time: 1–2 hours for baseline operations

4. **ADVISORY — Correct Import Register Entity Name (FYI-001)**
   - Owner: Product Master Data Lead / Solution Architect
   - Task: Update workbook Import Register row 2: "Bill of materials versions V3" → "Bill of materials versions V4"
   - Impact on data load preparation: Column mappings, import packages, and load job definitions must reference V4

### Next BOM/Route Validation Checkpoint

After BLK-002 and BLK-003 are resolved:
- Re-run readiness validation (D2R-P3-003 or equivalent) targeting BOM Versions V4 and Route Versions V2
- Confirm released products catalog coverage and site assignments before Import 2 and Import 3 are triggered
