# Dynamics 365 Finance & Supply Chain Inventory-to-Deliver Implementation Discovery Workbook

This workbook captures the discovery decisions required to implement the Inventory-to-Deliver (I2D) process in Dynamics 365 Finance & Supply Chain. It is designed to become the authoritative implementation source for build configuration, data migration readiness, validation execution, and build-agent handoff.

This template is based on two authoritative sources:
1. Microsoft Business Process Catalog (BPC), including the I2D end-to-end process context and process areas.
2. Microsoft Learn guidance for Dynamics 365 Supply Chain Management configuration, controls, and operational procedures.

## Process Context

### Why This Process Exists

Based on Microsoft BPC MAR 2026 Inventory-to-Deliver context and process area descriptions, this process exists to:

- Manage end-to-end flow of goods from warehouse receipt through customer delivery.
- Maintain inventory availability while minimizing stockouts and overstocks.
- Execute controlled inbound processing, including receipts, put-away, and discrepancy handling.
- Execute controlled outbound processing, including picking, packing, shipping, and transfer fulfillment.
- Apply quality inspection, quarantine, and disposition controls before inventory is consumed or shipped.
- Optimize transportation decisions through rating, routing, and freight reconciliation.
- Improve operational performance through warehouse KPIs, throughput analysis, and cycle count accuracy.
- Support connected downstream processes in Order-to-Cash, Source-to-Pay, Plan-to-Produce, and Record-to-Report.

### BPC Process Areas Covered

1. Manage warehouse operations
2. Maintain inventory levels
3. Process inbound goods
4. Process outbound goods
5. Manage inventory quality
6. Manage freight and transportation
7. Analyze warehouse operations

### BPC Scope Notes And Clarifications

- BPC MAR 2026 sequence for this process is `60.00.000.000` with seven process areas in scope.
- BPC context explicitly excludes upstream procurement and production planning processes, while including warehouse receipt of inbound goods and receipt/issue related to production execution.
- BPC highlights dependencies to downstream and adjacent processes such as Source-to-Pay, Order-to-Cash, Plan-to-Produce, and Case-to-Resolution.
- The Microsoft BPC deliverables tree workbook was not present separately in workspace; deliverables and dependencies are inferred from process-area descriptions and Microsoft Learn guidance.
- Live D365 environment inspection for legal entities and module activation status is currently blocked because the configured Dynamics MCP endpoint is a placeholder (`https://<your-org>.operations.dynamics.com/mcp`).

## Configuration Summary

1. Warehouse model and operational policy: Define warehouse operating model, process strategy, and governance decisions that determine whether advanced warehouse management processes are required and where they apply.
2. Warehouse structure and physical layout: Configure sites, warehouses, locations, zones, and location profiles so inventory movement is controlled and scalable.
3. Work execution framework: Configure work templates, location directives, and mobile device menus to automate inbound, internal movement, and outbound warehouse work.
4. Inventory policy and dimension model: Configure item model groups, storage/tracking dimensions, inventory status, reservation behavior, and counting policy to control stock fidelity and costing behavior.
5. Replenishment and counting controls: Define min/max strategy, cycle counting approach, adjustment governance, and inventory journal controls to maintain target service levels.
6. Inbound processing controls: Configure receipt registration, load/inbound shipment handling, ASN integration options, and put-away policies.
7. Outbound fulfillment controls: Configure picking, packing, staging, load handling, and shipment confirmation controls for customer and transfer demand.
8. Quality and quarantine management: Configure quality associations, quality order behavior, nonconformance handling, and quarantine policies.
9. Transportation and freight governance: Configure carriers, modes, methods, rate structures, routing choices, and freight reconciliation controls.
10. Warehouse analytics and KPI model: Define operational KPI set, dashboard ownership, thresholds, and cadence for performance review.
11. Security and operational controls: Define role ownership, approval responsibilities, and segregation of duties for inventory adjustments, quality disposition, and freight settlement.

## Data Import Plan

### Import Register

| # | Record type | D365 Data Entity | Source system | Est. volume | Import owner | Priority |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Shared products | Products V2 (`EcoResProductV2Entity`) | Legacy PIM / ERP | TBC | Product Master Data Lead | Foundation |
| 2 | Released products | Released products V2 (`EcoResReleasedProductV2Entity`) | Legacy ERP | TBC | Product Master Data Lead | Foundation |
| 3 | Product variants | Product variants (`EcoResProductVariantV2Entity`) | Legacy PIM | TBC | Product Master Data Lead | Foundation |
| 4 | Released product variants | Released product variants (`EcoResReleasedProductVariantV2Entity`) | Legacy ERP | TBC | Product Master Data Lead | Build |
| 5 | Product barcodes | Item - barcode association (`EcoResProductBarcodeAssociationEntity`) | Legacy WMS / Labeling system | TBC | Warehouse Master Data Lead | Build |
| 6 | Warehouse defaults by item | Released product warehouse defaults V2 (`EcoResReleasedProductWarehouseDefaultsV2Entity`) | Legacy ERP / WMS | TBC | Inventory Control Lead | Build |
| 7 | Warehouses | Warehouses (`InventWarehouseEntity`) | Legacy WMS / ERP | TBC | Warehouse Master Data Lead | Foundation |
| 8 | Work templates | Warehouse work template V2 (`WHSWarehouseWorkTemplateV2Entity`) | Legacy WMS design workbook | TBC | Warehouse Solution Lead | Build |
| 9 | Location directive actions | Warehouse location directive line actions V3 (`WHSWarehouseLocationDirectiveLineActionV3Entity`) | Legacy WMS design workbook | TBC | Warehouse Solution Lead | Build |
| 10 | Quality order baseline / migration scope | Quality orders (`InventQualityOrderHeaderEntity`) | Legacy QMS / ERP | TBC | Quality Lead | Governance |
| 11 | Opening stock balances | TBC (validate stock-load entity strategy in DMF catalog) | Legacy ERP / WMS snapshot | TBC | Data Migration Lead | Build |
| 12 | Inbound ASN integration seed data | TBC (inbound ASN data entity process) | Supplier ASN feed / 3PL | TBC | Integration Lead | Governance |

### Import Sequencing

1. Import #1 through #4 (products and variants) before warehouse execution setup so item dimensions and released product records exist.
2. Import #7 (warehouses) before warehouse execution policies that require warehouse-scoped setup objects.
3. Import #6 (released product warehouse defaults) after released products and warehouses are available.
4. Import #5 (barcodes) after products/variants are loaded and UOM conventions are confirmed.
5. Import #8 and #9 (work templates and directive actions) after warehouse model design sign-off and before pilot execution.
6. Import #10 (quality order baseline, if migrated) after quality policy and disposition codes are configured.
7. Import #11 (opening stock balances) only after inventory dimensions, statuses, and financial controls are validated.
8. Import #12 (ASN seed/reference integration data) after inbound process controls and integration contracts are approved.

### Data Readiness Checklist

| Check | Owner | Status |
| --- | --- | --- |
| Source-to-target mappings approved for all import records | Data Migration Lead | TBC |
| Legal entity ownership identified for each import record | Program Manager | TBC |
| Product dimension value standards approved (size, color, style, config) | Product Master Data Lead | TBC |
| Warehouse/location code conventions approved | Warehouse Operations Lead | TBC |
| Mandatory field defaults validated for each entity | Functional Consultant | TBC |
| Trial import completed for products and released products | Data Migration Lead | TBC |
| Trial import completed for warehouse execution entities | Technical Lead | TBC |
| Opening balance reconciliation method approved with Finance | Inventory Control Lead | TBC |

## How To Use This Workbook

1. Consultant and business owner review each section together.
2. Mark each feature area as In Scope, Out of Scope, or Future Phase in the Process Scope Decision table before completing detailed questions.
3. Complete detailed discovery questions only for areas marked In Scope.
4. Capture concrete values (codes, names, quantities, thresholds, frequencies) and avoid policy-only answers.
5. Track unknowns in the Open Items section.
6. On completion, trigger the build agent. The build agent auto-populates the Agent Handoff Payload YAML block at the bottom of this file. Do not fill in the YAML manually.

Status values: In Scope / Out of Scope / Future Phase / Unknown

## Company Profile And Scope

### 6a. Implementation Context

| Field | Response |
| --- | --- |
| Company legal name |  |
| Countries/regions in scope |  |
| Number of legal entities in scope |  |
| Primary industry and business model |  |
| Go-live date target |  |
| Legacy systems replaced |  |
| Regulatory/compliance frameworks applicable |  |
| External reporting obligations |  |

### 6b. Process Scope Decision

| Process area | Sub-area | Status | Owner | Notes |
| --- | --- | --- | --- | --- |
| Manage warehouse operations | Define warehouse operating model | Unknown |  |  |
| Manage warehouse operations | Design warehouse structure and layout | Unknown |  |  |
| Manage warehouse operations | Define warehouse workforce and device model | Unknown |  |  |
| Maintain inventory levels | Define inventory dimension and status policy | Unknown |  |  |
| Maintain inventory levels | Define replenishment and threshold model | Unknown |  |  |
| Maintain inventory levels | Define cycle counting and adjustment controls | Unknown |  |  |
| Process inbound goods | Define inbound receipt channels and controls | Unknown |  |  |
| Process inbound goods | Define inbound put-away and discrepancy handling | Unknown |  |  |
| Process outbound goods | Define outbound reservation, picking, and packing model | Unknown |  |  |
| Process outbound goods | Define shipment, transfer, and outbound exception model | Unknown |  |  |
| Manage inventory quality | Define quality order trigger and sampling rules | Unknown |  |  |
| Manage inventory quality | Define quarantine and nonconformance disposition | Unknown |  |  |
| Manage freight and transportation | Define carrier, mode, and route strategy | Unknown |  |  |
| Manage freight and transportation | Define freight rating and reconciliation controls | Unknown |  |  |
| Analyze warehouse operations | Define warehouse KPI model and dashboard ownership | Unknown |  |  |
| Analyze warehouse operations | Define review cadence and operational governance | Unknown |  |  |

## Detailed Configuration Guidance And Discovery Questions

## A. Manage Warehouse Operations

### A1. Warehouse Operating Model And Governance

This domain defines whether each warehouse uses advanced warehouse management processes, warehouse-only integration modes, and common policy controls. These decisions determine process architecture for inbound, movement, and outbound execution.

| Question | Response |
| --- | --- |
| Is advanced warehouse management required for all in-scope warehouses (Yes/No)? |  |
| Is warehouse management only mode required for any legal entity (Yes/No)? |  |
| Is cross-legal-entity shared warehouse processing required (Yes/No)? |  |
| Is owner tracking required for shared/external warehousing scenarios (Yes/No)? |  |
| What is the go-live wave strategy for warehouse enablement (single wave/phased)? |  |

Question: List each legal entity and warehouse operating model.

**Warehouse Operating Model Register**

| Legal Entity | Warehouse ID | Warehouse Name | Use Warehouse Management Processes (Y/N) | Operating Model (Native/External Shared/WMS Only) | Owner Tracking Required (Y/N) | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### A2. Warehouse Structure, Layout, And Work Framework

This domain captures site/warehouse structure and execution framework objects such as location directives and work templates. It ensures physical flow is explicitly mapped into system controls.

> **Data Import Required:** Warehouses and warehouse execution setup can require high-volume data loads via DMF - see **Data Import Plan -> Import #7**, **Import #8**, and **Import #9**. Use this section to define structural standards and directive/work governance that govern import templates.

| Question | Response |
| --- | --- |
| How many sites are in scope at go-live? |  |
| How many warehouses are in scope at go-live? |  |
| Are zone-based storage and picking strategies required (Yes/No)? |  |
| Are separate work template families required by work order type (Yes/No)? |  |
| Are directive codes required for explicit step-to-location control (Yes/No)? |  |

Question: Define site standards.

**Sites Register**

| Site ID | Site Name | Legal Entity | Address/Location | Primary Use | Active (Y/N) |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

Question: Define warehouse standards.

**Warehouses Register**

| Warehouse ID | Warehouse Name | Site ID | Legal Entity | WMS Enabled (Y/N) | Default Receipt Location | Default Issue Location | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Question: Define location design standards.

**Locations Register**

| Warehouse ID | Location ID | Location Profile | Zone ID | Aisle/Bay/Bin Pattern | License Plate Controlled (Y/N) | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### A3. Mobile Device Menus, Work Assignment, And Labor Controls

This domain defines mobile device menu strategy, worker assignment controls, and work pool policies that govern day-to-day warehouse execution.

| Question | Response |
| --- | --- |
| Are dedicated inbound, movement, and outbound mobile menus required (Yes/No)? |  |
| Is system grouping (for example shipment/load grouping) required on mobile work (Yes/No)? |  |
| Are work pools used to restrict work by worker group (Yes/No)? |  |
| Are audit templates required to interrupt and enforce process checks (Yes/No)? |  |
| Is cluster picking required (Yes/No)? |  |

Question: Define mobile menu item scope.

**Mobile Menu Item Register**

| Menu Name | Menu Item Name | Mode (Work/Indirect) | Work Creation Process | Use Existing Work (Y/N) | Worker Group Scope | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (A)

1. Warehouse operating model policy by legal entity
2. Sites, warehouses, locations, zones, and location profiles
3. Warehouse management parameters and general work policies
4. Work templates and directive code strategy
5. Location directives and location directive actions
6. Mobile device menu items, menus, and worker/work pool controls

## B. Maintain Inventory Levels

### B1. Inventory Dimensions, Item Model Policy, And Reservation Controls

This domain defines how inventory is tracked and valued by dimension, and how reservation behavior is controlled across operations.

> **Data Import Required:** Product and released product records that carry dimension and model settings are high-volume and must be loaded via DMF - see **Data Import Plan -> Import #1**, **Import #2**, **Import #3**, and **Import #4**. Use this section to define policy defaults that govern import templates.

| Question | Response |
| --- | --- |
| Which storage dimensions are active at go-live (Site/Warehouse/Location/LP/Status/Owner)? |  |
| Is financial inventory tracking required at warehouse level (Yes/No)? |  |
| Are batch and serial tracking required for any product families (Yes/No)? |  |
| Are blank receipt/issue controls required for serial or batch dimensions (Yes/No)? |  |
| Are separate item model groups required by inventory valuation method (Yes/No)? |  |

Question: Define storage dimension policy.

**Storage Dimension Groups Register**

| Group ID | Description | Site Financial Inventory (Y/N) | Warehouse Financial Inventory (Y/N) | Location Tracking (Y/N) | LP Tracking (Y/N) | Inventory Status Tracking (Y/N) | Owner Tracking (Y/N) |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

Question: Define tracking dimension policy.

**Tracking Dimension Groups Register**

| Group ID | Description | Batch Active (Y/N) | Serial Active (Y/N) | Batch Financial Inventory (Y/N) | Serial Financial Inventory (Y/N) | Blank Receipt Allowed (Y/N) | Blank Issue Allowed (Y/N) |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

### B2. Replenishment, Counting, And Adjustment Governance

This domain defines replenishment thresholds, cycle counting behavior, and controlled adjustments to keep inventory records reliable.

| Question | Response |
| --- | --- |
| Is min/max replenishment policy required by item-location (Yes/No)? |  |
| Is ABC segmentation used for count frequency strategy (Yes/No)? |  |
| Are counting groups required with periodic or threshold triggers (Yes/No)? |  |
| Is duplicate counting prevention policy required (Yes/No)? |  |
| Are inventory adjustments restricted to approved roles (Yes/No)? |  |

Question: Define counting policy by item segment.

**Counting Policy Register**

| Counting Group | Counting Code (Manual/Period/Zero/Minimum) | Period (Days) | Threshold Rule | Item Scope | Warehouse Scope | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

Question: Define adjustment governance.

**Inventory Journal Governance Register**

| Journal Type | Journal Name | Voucher Series | Approval Required (Y/N) | Role Allowed To Post | Financial Impact Allowed (Y/N) | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (B)

1. Storage and tracking dimension groups
2. Item model groups and item groups
3. Reservation and inventory status policies
4. Counting groups and counting journal defaults
5. Inventory journal names and posting restrictions
6. Replenishment rule and threshold governance

## C. Process Inbound Goods

### C1. Inbound Receipt Channel Design And Registration Controls

This domain defines inbound channels (PO, transfer, return, ASN-driven receipt) and controls for registration accuracy.

*Complete only if Inbound Processing is In Scope.*

> **Data Import Required:** Inbound integration seed data and ASN-related setup can require data loads - see **Data Import Plan -> Import #12**. Use this section to define prerequisites and defaults for inbound data templates.

| Question | Response |
| --- | --- |
| Are inbound receipts processed from purchase orders at go-live (Yes/No)? |  |
| Are inbound transfer order receipts in scope (Yes/No)? |  |
| Is ASN-based receiving required (Yes/No)? |  |
| Are license plate receiving flows required (Yes/No)? |  |
| Is dock registration required before put-away (Yes/No)? |  |

Question: Define inbound receipt channels and controls.

**Inbound Channel Register**

| Channel (PO/Transfer/Return/ASN) | Receiving Method | Registration Location | Mobile Menu Item | ASN Required (Y/N) | Exception Owner | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### C2. Put-Away, Discrepancy Handling, And Receiving Completion

This domain defines how received inventory is put away, how short/over/damaged exceptions are handled, and when loads are marked as receiving complete.

| Question | Response |
| --- | --- |
| Is automatic put-away work generation required (Yes/No)? |  |
| Are separate discrepancy reason codes required for short/over/damaged (Yes/No)? |  |
| Is receiving completed process required to close inbound loads (Yes/No)? |  |
| Are inbound quality checks required before put-away for selected items (Yes/No)? |  |
| Is quarantine routing required for failed inspections (Yes/No)? |  |

Question: Define inbound discrepancy handling model.

**Inbound Discrepancy Register**

| Reason Code | Scenario | Financial Impact Policy | Inventory Status Result | Follow-Up Owner | Escalation SLA (Hours) | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (C)

1. Inbound load handling and receipt channel setup
2. ASN and license plate receiving policies
3. Inbound mobile device menu items and work classes
4. Put-away work templates and location directives
5. Discrepancy reason codes and exception routing model
6. Receiving completion policy and ownership

## D. Process Outbound Goods

### D1. Reservation, Picking, And Packing Strategy

This domain defines outbound reservation behavior, picking method, packing controls, and staging strategy for customer and transfer demand.

*Complete only if Outbound Processing is In Scope.*

| Question | Response |
| --- | --- |
| Is batch reservation strategy required for outbound (FEFO/FIFO/Manual)? |  |
| Is wave or release-to-warehouse orchestration required (Yes/No)? |  |
| Are multiple picking strategies required (order, cluster, zone, sorted) (Yes/No)? |  |
| Is put-to-wall or outbound sorting required (Yes/No)? |  |
| Is packing station control required before shipment confirmation (Yes/No)? |  |

Question: Define outbound execution strategy by demand type.

**Outbound Strategy Register**

| Demand Type (Sales/Transfer/Vendor Return) | Reservation Strategy | Picking Strategy | Packing Method | Staging Location Policy | Shipment Confirmation Trigger | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### D2. Shipment, Load, And Outbound Exception Controls

This domain defines outbound load handling, shipment confirmation controls, and backorder/short pick exception handling.

| Question | Response |
| --- | --- |
| Are outbound loads required for all shipments (Yes/No)? |  |
| Is carrier assignment required before ship confirmation (Yes/No)? |  |
| Are partial shipment rules required by customer class (Yes/No)? |  |
| Are short pick and backorder workflows required (Yes/No)? |  |
| Is real-time shipment tracking integration required (Yes/No)? |  |

Question: Define outbound exception rules.

**Outbound Exception Register**

| Exception Type | Trigger Condition | Auto Action | Manual Resolution Owner | Customer Communication Required (Y/N) | SLA (Hours) | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (D)

1. Outbound release and reservation policy settings
2. Outbound work templates and location directives
3. Mobile picking/packing menu item configuration
4. Load and shipment handling controls
5. Outbound exception reason codes and workflow ownership
6. Shipment confirmation and tracking integration points

## E. Manage Inventory Quality

### E1. Quality Association, Quality Order, And Sampling Policy

This domain defines where quality orders are triggered, which tests apply, and how sampling is controlled across inbound and internal flows.

*Complete only if Quality Management is In Scope.*

> **Data Import Required:** Quality baseline records may require managed migration - see **Data Import Plan -> Import #10**. Use this section to define quality rule defaults and ownership before import.

| Question | Response |
| --- | --- |
| Are automatic quality order associations required at receipt events (Yes/No)? |  |
| Are manual quality orders allowed outside trigger events (Yes/No)? |  |
| Is sampling by item/vendor/site required (Yes/No)? |  |
| Are blocking statuses required until quality disposition is complete (Yes/No)? |  |
| Are quality tests standardized by item family (Yes/No)? |  |

Question: Define quality association policy.

**Quality Association Register**

| Association ID | Reference Type (PO/Transfer/Production/Sales Return) | Item Scope | Trigger Event | Sampling Plan | Blocking Rule | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### E2. Quarantine, Nonconformance, And Disposition Governance

This domain defines quarantine behavior, nonconformance workflows, and disposition decisions that determine inventory usability and traceability.

| Question | Response |
| --- | --- |
| Are dedicated quarantine warehouses or zones required (Yes/No)? |  |
| Is nonconformance workflow approval required (Yes/No)? |  |
| Are disposition codes standardized globally (Yes/No)? |  |
| Is return-to-vendor disposition in scope (Yes/No)? |  |
| Is destruction/scrap approval required above quantity thresholds (Yes/No)? |  |

Question: Define quarantine and disposition standards.

**Quarantine And Disposition Register**

| Disposition Code | Resulting Inventory Status | Financial Treatment | Approval Required (Y/N) | Approval Role | Follow-Up Process | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (E)

1. Quality associations and quality order references
2. Quality test groups and sampling policies
3. Quality order processing controls and ownership
4. Quarantine zones/orders and inventory status transitions
5. Nonconformance and disposition reason code governance
6. Approval policies for disposition outcomes

## F. Manage Freight And Transportation

### F1. Carrier, Mode, Method, And Rate Strategy

This domain defines transportation master data and rating logic used to choose carriers and estimate freight cost.

*Complete only if Transportation Management is In Scope.*

| Question | Response |
| --- | --- |
| How many shipping carriers are in scope at go-live? |  |
| Are transportation modes and methods standardized globally (Yes/No)? |  |
| Is carrier rating required before load confirmation (Yes/No)? |  |
| Are rate masters and break masters required for contract-based pricing (Yes/No)? |  |
| Is route planning optimization required for multi-stop loads (Yes/No)? |  |

Question: Define carrier master and rate strategy.

**Carrier And Rating Register**

| Shipping Carrier | Mode | Transportation Method | Rating Profile | Rate Master | Transit Time Engine | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### F2. Freight Reconciliation And Cost Control

This domain defines freight bill matching, variance handling, approval, and posting controls to maintain transportation cost accuracy.

| Question | Response |
| --- | --- |
| Is automatic freight reconciliation required (Yes/No)? |  |
| Are freight bill type assignments required by carrier/site/warehouse (Yes/No)? |  |
| Are tolerance rules required through audit master configuration (Yes/No)? |  |
| Are reconciliation reason codes required with GL override support (Yes/No)? |  |
| Is invoice approval workflow mandatory before posting (Yes/No)? |  |

Question: Define freight variance governance.

**Freight Reconciliation Register**

| Freight Bill Type | Carrier | Tolerance Rule | Reconciliation Method (Manual/Auto) | Reason Code Policy | Approval Role | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (F)

1. Transportation modes and transportation methods
2. Shipping carriers and carrier services
3. Rating profiles, rate masters, and break masters
4. Route/rating planning controls
5. Freight reconciliation setup (bill types, assignments, audit master)
6. Reconciliation reasons, approvals, and posting controls

## G. Analyze Warehouse Operations

### G1. KPI Model, Dashboard Design, And Data Ownership

This domain defines the KPI set, scorecard design, and data ownership model for warehouse performance management.

| Question | Response |
| --- | --- |
| Are standard warehouse KPIs sufficient for phase 1 (Yes/No)? |  |
| Is KPI segmentation required by site and warehouse (Yes/No)? |  |
| Is cycle count accuracy a mandatory executive KPI (Yes/No)? |  |
| Is pick productivity KPI tracked at worker level (Yes/No)? |  |
| Is Power BI dashboard publication required at go-live (Yes/No)? |  |

Question: Define KPI catalog.

**Warehouse KPI Register**

| KPI Name | Formula / Definition | Grain (Site/Warehouse/Worker/Item) | Target Threshold | Owner | Review Cadence | Active (Y/N) |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### G2. Performance Review Cadence And Continuous Improvement Controls

This domain defines review rhythm, exception escalation, and action ownership to convert analytics into operational improvements.

| Question | Response |
| --- | --- |
| Is weekly warehouse performance review required (Yes/No)? |  |
| Are exception thresholds required to auto-trigger corrective actions (Yes/No)? |  |
| Is root-cause analysis required for misses above threshold (Yes/No)? |  |
| Are corrective action logs required and auditable (Yes/No)? |  |
| Are cross-process KPI reviews required with O2C/P2P stakeholders (Yes/No)? |  |

Question: Define review and action governance.

**Performance Governance Register**

| Review Forum | Frequency | Required Inputs | Threshold Trigger | Action Owner | Escalation Path | Status |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Required Setup Objects (G)

1. Warehouse KPI dictionary and scorecard definitions
2. Dashboard/report definitions and ownership mapping
3. Review cadence and threshold policy
4. Corrective action and escalation governance controls
5. Cross-process performance governance checkpoints

## Validation Scenarios

| Scenario | Process area | Expected outcome | Evidence required | Status |
| --- | --- | --- | --- | --- |
| Receive PO via mobile receiving and complete put-away | Process inbound goods + Manage warehouse operations | Inventory is registered at dock, put-away work is generated and completed, on-hand updates to storage location | Mobile execution log, work completion record, inventory transaction evidence | Unknown |
| Execute cycle count and post variance with approval controls | Maintain inventory levels | Variance is captured, approved by authorized role, and inventory balance updates correctly | Counting journal, approval trace, posted voucher/inventory transaction | Unknown |
| Release sales order to warehouse and complete pick-pack-ship | Process outbound goods | Reservation, picking, packing, and shipment confirmation complete without policy violations | Shipment work details, packing evidence, shipment confirmation output | Unknown |
| Trigger quality order on receipt and route failed quantity to quarantine | Manage inventory quality + Process inbound goods | Quality order is generated per rule, failed quantity is quarantined and dispositioned | Quality order record, quarantine order/zone evidence, disposition record | Unknown |
| Rate load with configured carrier profile and reconcile freight invoice | Manage freight and transportation | Freight estimate posts to freight bill, invoice is matched and reconciled within tolerance/approval policy | Freight bill, matching log, vendor invoice journal evidence | Unknown |
| Monitor KPI dashboard and raise corrective action on threshold breach | Analyze warehouse operations | KPI breach is detected, action owner assigned, remediation tracked to closure | KPI dashboard snapshot, review minutes, action log | Unknown |
| Execute transfer outbound and inbound with ASN/license plate receiving | Process outbound goods + Process inbound goods | Transfer shipment and receiving complete with inventory traceability across locations | Transfer order history, ASN/LP receiving logs, inventory movement trail | Unknown |
| Post opening stock load and reconcile to baseline inventory report | Maintain inventory levels | Opening balances load successfully and reconcile to approved cutover baseline | DMF execution log, reconciliation report, sign-off evidence | Unknown |

## Risks And Dependencies

| Risk/Dependency | Why it matters | Mitigation | Owner | Status |
| --- | --- | --- | --- | --- |
| Late changes to storage/tracking dimension policy | Can invalidate existing transactions and force rework | Freeze dimension policy before migration rehearsal and enforce CAB approval | Solution Architect | Open |
| Warehouse/location code quality issues in legacy data | Causes import failures and execution confusion | Standardize code schema and run profiling/cleansing before trial loads | Data Migration Lead | Open |
| Work template and directive logic not performance tested | Can create blocked or inefficient warehouse flows | Run volume tests and tune templates/directives before UAT | Warehouse Solution Lead | Open |
| Incomplete ASN integration contract | Inbound receiving automation cannot be stabilized | Define field contract, error handling, and retry policy early | Integration Lead | Open |
| Quality disposition governance undefined | Nonconforming inventory may be consumed or shipped incorrectly | Approve disposition matrix and approval roles before pilot | Quality Lead | Open |
| Freight rate master not aligned with carrier contracts | Freight estimates and reconciliation variances increase | Validate contractual mapping with transport procurement before go-live | Transportation Lead | Open |
| Cross-process dependency: product master from Design-to-Retire | Missing product and variant standards blocks I2D setup | Align master data cutover milestones with D2R workstream | Product Governance Lead | Open |
| Cross-process dependency: posting and costing policy from Record-to-Report | Inventory valuation and adjustment posting may fail | Confirm item model and posting profile readiness before stock loads | Finance Lead | Open |
| Cross-process dependency: order orchestration from Order-to-Cash | Outbound shipment rules may conflict with order promises | Jointly validate release-to-warehouse and shipment rules | O2C Lead | Open |
| D365 environment inspection currently blocked | Current-state baseline cannot be confirmed in-system | Correct MCP endpoint configuration and rerun discovery checkpoint | Technical Lead | Open |

## Open Items And Clarifications

| ID | Process area | Question/unknown | Needed from | Due date | Resolution |
| --- | --- | --- | --- | --- | --- |
| I2D-001 | Manage warehouse operations |  |  |  |  |
| I2D-002 | Maintain inventory levels |  |  |  |  |
| I2D-003 | Process inbound goods |  |  |  |  |
| I2D-004 | Process outbound goods |  |  |  |  |
| I2D-005 | Manage freight and transportation |  |  |  |  |

## Agent Handoff Payload

```yaml
project:
  name: ""
  goLiveDate: ""
  targetLegalEntities: []
  masterLegalEntity: ""

scope:
  manageWarehouseOperations: Unknown
  maintainInventoryLevels: Unknown
  processInboundGoods: Unknown
  processOutboundGoods: Unknown
  manageInventoryQuality: Unknown
  manageFreightAndTransportation: Unknown
  analyzeWarehouseOperations: Unknown

warehouseOperatingModel:
  entities: [] # [{ legalEntity, warehouseId, operatingModel, useWmsProcesses, ownerTrackingRequired }]
  wmsOnlyModeRequired: "" # Yes/No
  sharedExternalWarehouseRequired: "" # Yes/No

warehouseStructure:
  sites: [] # [{ siteId, siteName, legalEntity, primaryUse, active }]
  warehouses: [] # [{ warehouseId, warehouseName, siteId, legalEntity, wmsEnabled, defaultReceiptLocation, defaultIssueLocation }]
  locations: [] # [{ warehouseId, locationId, locationProfile, zoneId, lpControlled }]

warehouseExecution:
  workTemplates: [] # [{ templateId, workOrderType, warehouse, active }]
  locationDirectives: [] # [{ directiveName, workOrderType, workType, directiveCode, warehouseScope }]
  mobileMenuItems: [] # [{ menuName, menuItemName, mode, workCreationProcess, useExistingWork, workerGroupScope }]
  imports:
    warehousesImportId: 7
    workTemplateImportId: 8
    locationDirectiveActionImportId: 9

inventoryPolicy:
  storageDimensionGroups: [] # [{ groupId, siteFinancialInventory, warehouseFinancialInventory, locationTracking, lpTracking, statusTracking, ownerTracking }]
  trackingDimensionGroups: [] # [{ groupId, batchActive, serialActive, batchFinancialInventory, serialFinancialInventory }]
  itemModelGroups: [] # [{ itemModelGroupId, valuationMethod, postPhysicalInventory }]
  reservationPolicy: [] # [{ itemScope, reservationHierarchy, policy }]

inventoryControl:
  replenishmentRules: [] # [{ ruleId, itemScope, warehouseScope, minQty, maxQty, reorderMethod }]
  countingPolicies: [] # [{ countingGroup, countingCode, periodDays, thresholdRule, warehouseScope }]
  journalGovernance: [] # [{ journalType, journalName, approvalRequired, roleAllowedToPost }]
  imports:
    openingStockImportId: 11

inboundProcessing:
  channels: [] # [{ channel, receivingMethod, registrationLocation, asnRequired, mobileMenuItem }]
  putawayPolicy: [] # [{ warehouseId, workTemplate, locationDirective, receivingCompletePolicy }]
  discrepancyRules: [] # [{ reasonCode, scenario, inventoryStatusResult, owner, escalationSlaHours }]
  asnIntegration:
    enabled: "" # Yes/No
    importId: 12

outboundProcessing:
  strategies: [] # [{ demandType, reservationStrategy, pickingStrategy, packingMethod, stagingPolicy }]
  shipmentControls: [] # [{ partialShipmentRule, carrierRequiredBeforeShipConfirm, trackingIntegrationRequired }]
  exceptions: [] # [{ exceptionType, triggerCondition, autoAction, owner, slaHours }]

qualityManagement:
  qualityAssociations: [] # [{ associationId, referenceType, itemScope, triggerEvent, samplingPlan, blockingRule }]
  qualityDisposition: [] # [{ dispositionCode, resultingInventoryStatus, financialTreatment, approvalRequired, approvalRole }]
  imports:
    qualityBaselineImportId: 10

transportationManagement:
  carriers: [] # [{ shippingCarrier, mode, transportationMethod, ratingProfile, rateMaster, active }]
  freightReconciliation: [] # [{ freightBillType, carrier, toleranceRule, reconciliationMethod, reasonCodePolicy, approvalRole }]
  autoReconciliationEnabled: "" # Yes/No

warehouseAnalytics:
  kpis: [] # [{ kpiName, formula, grain, targetThreshold, owner, cadence }]
  governance: [] # [{ reviewForum, frequency, thresholdTrigger, actionOwner, escalationPath }]

securityAndControls:
  segregationOfDutiesRules: [] # [{ conflictArea, roleA, roleB, mitigationControl }]
  approvalAuthorities: [] # [{ processArea, authorityRole, limitOrCondition }]

dataMigration:
  importRegisterStatus: [] # [{ importId, recordType, entityName, owner, status }]
  cutoverReadinessApproved: "" # Yes/No

validation:
  scenarios: [] # [{ scenarioName, expectedOutcome, evidenceRequired, status }]
  outstandingOpenItems: [] # ["I2D-001", "I2D-002"]
```

## Reference Documentation

1. Inventory-to-Deliver process overview: https://learn.microsoft.com/dynamics365/guidance/business-processes/inventory-to-deliver-overview
2. Inventory-to-Deliver process areas: https://learn.microsoft.com/dynamics365/guidance/business-processes/inventory-to-deliver-areas
3. Manage warehouse operations process area: https://learn.microsoft.com/dynamics365/guidance/business-processes/inventory-to-deliver-define-manage-warehouse-operations-overview
4. Maintain inventory levels process area: https://learn.microsoft.com/dynamics365/guidance/business-processes/inventory-to-deliver-maintain-inventory-levels-overview
5. Manage freight and transportation process area: https://learn.microsoft.com/dynamics365/guidance/business-processes/inventory-to-deliver-manage-freight-transportation
6. Warehouse management overview: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/warehouse-management-overview
7. Warehouse configuration overview: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/warehouse-configuration
8. Work templates and location directives: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/control-warehouse-location-directives
9. Mobile device setup for warehouse work: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/configure-mobile-devices-warehouse
10. Inbound load handling: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/inbound-load-handling
11. Outbound load handling: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/outbound-load-handling
12. Inventory journals: https://learn.microsoft.com/dynamics365/supply-chain/inventory/inventory-journals
13. Define inventory counting processes: https://learn.microsoft.com/dynamics365/supply-chain/inventory/tasks/define-inventory-counting-processes
14. Quality and nonconformance management overview: https://learn.microsoft.com/dynamics365/supply-chain/inventory/quality-management-processes
15. Quality orders: https://learn.microsoft.com/dynamics365/supply-chain/inventory/quality-orders
16. Quarantine orders: https://learn.microsoft.com/dynamics365/supply-chain/inventory/quarantine-orders
17. Transportation management modes and methods: https://learn.microsoft.com/dynamics365/supply-chain/transportation/transportation-management-modes-methods
18. Set up shipping carriers: https://learn.microsoft.com/dynamics365/supply-chain/transportation/tasks/set-up-shipping-carriers
19. Set up rate masters, rate bases, and break masters: https://learn.microsoft.com/dynamics365/supply-chain/transportation/tasks/set-up-rate-masters
20. Reconcile freight in transportation management: https://learn.microsoft.com/dynamics365/supply-chain/transportation/reconcile-freight-transportation-management
21. Product data entities: https://learn.microsoft.com/dynamics365/supply-chain/pim/data-entities
22. Data entity support for user-configurable queries in warehouse management: https://learn.microsoft.com/dynamics365/supply-chain/warehousing/data-entity-support-for-user-configurable-queries-in-warehouse-management
23. Data management overview: https://learn.microsoft.com/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages
24. Import product data in Dynamics 365 projects: https://learn.microsoft.com/dynamics365/guidance/resources/import-products
