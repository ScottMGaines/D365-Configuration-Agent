# Design To Retire Inventory Posting Profile Load Notes

## Purpose
This file documents how to load inventory posting profile mappings for all in-scope legal entities in the Record-to-Report and Design-to-Retire scope:
- USMF
- USSE
- DEMF
- GBMF

## Source File
- Output/Design_To_Retire_InventoryPostingProfile_InventPosting_AllEntities.csv

## Target Data Entity
- InventPosting (Item, ledger posting)

## Expected Mapping
- dataAreaId -> dataAreaId
- InventAccountType -> InventAccountType
- ItemCode -> ItemCode
- ItemRelation -> ItemRelation
- CustVendCode -> CustVendCode
- CustVendRelation -> CustVendRelation
- MainAccount -> LedgerDimension (map account number to main account in transformation)

## Configuration Intent
- Item code = Group for FG, RM, SVC item groups
- Account code = All for supplier/customer relation at profile level
- Main account mapping is aligned to FAB-GL chart policy from Record-to-Report
- Includes Sales order tab posting types for FG across all entities:
	- Cost of units, delivered
	- Cost of goods sold, delivered
	- Cost of units, invoiced
	- Cost of goods sold, invoiced
	- Revenue
	- Deferred revenue on delivery
	- Deferred revenue offset on delivery
	- Deferred sales tax on delivery

## Important Validation
1. Confirm item groups FG, RM, SVC exist in each legal entity before import.
2. Confirm all referenced main accounts exist in FAB-GL before import.
3. If your environment requires enum integer values for ItemCode/CustVendCode/InventAccountType, convert labels to enum values in DMF mapping.
4. If LedgerDimension requires display value mapping, map MainAccount as ledger account display value.

## Execution Note
This artifact prepares import data only. Data upload/import execution remains manual outside agent scope.
