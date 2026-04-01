# Inventory-to-Deliver Discovery Session Transcript
**Client:** Alpine Distribution Group (Fictional)  
**Process:** Inventory-to-Deliver (I2D)  
**Session Type:** Advanced Warehouse & Logistics Solution Design Workshop  
**Date:** 2026-03-03  
**Duration:** 4 hours  

## Participants

- **David Morales** — Director of Supply Chain (Client)
- **Emily Carter** — Warehouse Operations Manager (Client)
- **Jason Liu** — Transportation & Logistics Manager (Client)
- **Hannah Brooks** — Inventory Control Manager (Client)
- **Kevin Patel** — D365 Supply Chain Solution Architect (Consultant)
- **Rachel Nguyen** — Senior WMS Functional Consultant (Consultant)

---

## Session Introduction

**Kevin (Consultant):**  
Today we’ll finalize Inventory‑to‑Deliver decisions, focusing heavily on **Advanced Warehouse Management** — sites, warehouses, locations, work, waves, inventory dimensions, and outbound logistics. The intent is to fully enable configuration without open questions.

**David (Supply Chain Director):**  
That’s the goal. We want WMS fully operational at go‑live.

---

## Sites and Warehouses

**Rachel (Consultant):**  
Let’s start with sites and warehouses.

**Emily (Warehouse Ops):**  
We have **two distribution sites**:
- **EAST**
- **WEST**

Each site has **one advanced WMS warehouse**.

### Warehouses

| Warehouse ID | Site | Description | WMS Enabled |
|-------------|------|-------------|-------------|
| EDC | EAST | East Distribution Center | Yes |
| WDC | WEST | West Distribution Center | Yes |

Both warehouses go live at the same time.

---

## Warehouse Layout and Locations

**Rachel:**  
Location structure?

**Emily:**  
We use a standard location format:
``<zone>-<aisle>-<bay>-<level>
Example: PCK-03-12-02</level></bay></aisle></zone>''

### Zones

**Emily:**  
Zones per warehouse:
- **RCV** — Receiving
- **STG** — Staging
- **BLK** — Bulk Storage
- **PCK** — Pick Face
- **SHP** — Shipping

Pick face locations are replenished from bulk.

---

## License Plates and Tracking

**Rachel:**  
License plate usage?

**Emily:**  
License plates are **mandatory** for:
- All warehouse movements
- All picking and packing

We use **system‑generated license plates** only.

---

## Inventory Dimensions

**Kevin:**  
Confirm inventory dimensions.

**Hannah (Inventory Control):**  
We use:
- Site
- Warehouse
- Location
- License Plate
- Inventory Status

No batch or serial tracking.

---

## Inventory Statuses

**Rachel:**  
Inventory statuses?

**Hannah:**  
We will use:
- **Available**
- **Quarantine**
- **Damaged**

Only **Available** inventory is pickable.

---

## Item Model and Dimension Groups

**Kevin:**  
Item setup standards?

**Hannah:**  
- All stocked items use the same **storage dimension group**
- Location and license plate tracking enabled
- Inventory status is mandatory

Costing method is **FIFO**.

---

## Receiving Process

**Rachel:**  
Inbound process?

**Emily:**  
All receipts go through:
1. ASN or purchase order registration
2. Receiving at dock (RCV zone)
3. Put‑away work creation
4. Directed put‑away to bulk or pick locations

No blind receiving.

---

## Put-Away Strategies

**Rachel:**  
Put‑away logic?

**Emily:**  
- System‑directed put‑away
- Based on:
  - Item
  - Location profile
  - Available capacity

Bulk locations preferred first.

---

## Replenishment

**Rachel:**  
Replenishment approach?

**Emily:**  
- **Wave‑based replenishment**
- Triggered automatically when pick face drops below minimum

No manual replenishment except for exceptions.

---

## Picking Strategies

**Rachel:**  
Picking methods?

**Emily:**  
- **Cluster picking** for small orders
- **Wave picking** for large outbound runs
- Picked by license plate

---

## Wave Management

**Kevin:**  
Wave planning?

**Emily:**  
- Waves are created **every hour**
- Separate waves for:
  - Parcel shipments
  - LTL / FTL shipments

Waves are auto‑released.

---

## Packing and Shipping

**Rachel:**  
Packing process?

**Emily:**  
- Pack at pack stations
- Containers confirmed before shipment

**Jason (Logistics):**  
Shipping:
- Parcel carriers: UPS and FedEx
- LTL carrier selected manually
- No Transportation Management module in phase one

---

## Outbound Load Management

**Rachel:**  
Load usage?

**Jason:**  
Loads are created for:
- All LTL and FTL shipments
- Parcel shipments do **not** use loads

---

## Work Templates and Work Classes

**Rachel:**  
Work setup?

**Emily:**  
- Separate work templates for:
  - Receiving
  - Put‑away
  - Replenishment
  - Picking
  - Packing
- Work classes:
  - Forklift
  - Picker
  - Packer

---

## Mobile Device Usage

**Kevin:**  
Warehouse mobile app usage?

**Emily:**  
Yes — **mandatory**.

- All warehouse users use the mobile device
- No desktop processing on the floor

---

## Cycle Counting

**Rachel:**  
Inventory counting?

**Hannah:**  
- **Cycle counting only**
- No annual physical count
- Triggered by:
  - Location count thresholds
  - Inventory status changes

---

## Inventory Blocking and Quality Holds

**Kevin:**  
Blocking rules?

**Hannah:**  
- Damaged inventory is immediately blocked
- Quarantine inventory cannot be picked
- Release requires inventory status change approval

---

## Cross-Docking

**Rachel:**  
Cross‑docking?

**Emily:**  
Yes, **planned cross‑docking** is enabled for:
- High‑velocity SKUs only

---

## Data Migration (I2D Scope)

**Kevin:**  
Data migration scope?

**Hannah:**  
At go‑live we will migrate:
- On‑hand inventory balances by:
  - Item
  - Site
  - Warehouse
  - Location
  - Inventory status
- Open purchase orders
- Open sales orders

No historical transactions.

---

## Cross‑Process Dependencies

**Kevin:**  
Dependencies?

**David:**  
- Products and item model groups from Design‑to‑Retire
- Chart of accounts and inventory posting from Record‑to‑Report
- Customer ship‑to addresses from Order‑to‑Cash

---

## Final Scope Confirmation

**Kevin:**  
Anything intentionally deferred?

**David:**  
Transportation Management, Yard Management, and Labor Standards are **out of scope** for phase one. Everything else discussed is in scope.

**Rachel:**  
Great — this is sufficient to fully generate the Inventory‑to‑Deliver implementation workbook.

---

## Session Close

**Kevin:**  
We’ll generate the Inventory‑to‑Deliver implementation plan directly from this session and proceed to configuration.

**David:**  
Perfect. Let’s move forward.

---