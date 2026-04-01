# Dynamics 365 Finance & Supply Chain Implementation Agents

This workspace includes specialized agents for implementing Dynamics 365 Finance & Supply Chain Management business processes.

## Available Agents

### Project Manager
**File:** `.github/agents/project-manager.agent.md`  
**Purpose:** Orchestrates end-to-end implementation for a business process  
**Invocation:** `@Project Manager Record_To_Report`  
**Tools:** read, search, agent, edit  
**Subagents:** Solution Architect, Solution Consultant  

**Use when:**
- Starting a new process implementation
- Coordinating multiple agents for end-to-end setup
- Need complete process delivery with validation and configuration

**Workflow:**
1. Solution Architect validates implementation file for gaps
2. Project Manager creates and maintains a dashboard-backed execution queue
3. Solution Consultant receives one dashboard task at a time and reports verbose progress for that item
4. Solution Consultant validates data-load prerequisites and readiness artifacts (when applicable)
5. Produces final implementation summary with outcomes from all agents

---

### Solution Architect
**File:** `.github/agents/solution-architect.agent.md`  
**Purpose:** Requirements extraction and implementation readiness validation  
**Invocation:** `@Solution Architect [transcript path or validation request]`  
**Tools:** read, edit, search, microsoftdocs/mcp/*, agent  

**Use when:**
- Extracting requirements from Teams transcripts or meeting notes
- Populating Implement workbook files
- Validating implementation file completeness before configuration
- Researching gaps and proposing intelligent defaults

**Key Outputs:**
- `Processes/Implement_<Process>.template.md` (populated from requirements)
- `Output/<Process>_Readiness_Report.md` (status and gap analysis)
- Clarification questions for stakeholders

---

### Solution Consultant
**File:** `.github/agents/solution-consultant.agent.md`  
**Purpose:** Hands-on D365 configuration for business processes  
**Invocation:** `@Solution Consultant Record_To_Report`  
**Tools:** read, edit, search, microsoftdocs/mcp/*, agent  

**Use when:**
- Implementing a complete business process in D365
- Configuring a single assigned dashboard item or a complete process, depending on the Project Manager instruction
- Need detailed implementation log with menu paths and data

**Key Outputs:**
- `Output/<Process>_Implementation_log.md` (detailed configuration log)
- Actual D365 configurations deployed in target system
- Validation results for each feature
- Verbose item-level progress reports suitable for the implementation dashboard

---

## Typical Orchestration Flow

For a complete process implementation, the agents work together in sequence:

```
User Request: "Implement Record-to-Report process"
    ↓
┌─────────────────────────────────────────────────────────────┐
│ Project Manager (Orchestrator)                              │
├─────────────────────────────────────────────────────────────┤
│ Phase 1: Requirements Validation                            │
│   → Delegates to: Solution Architect                        │
│   → Output: Readiness report, gaps resolved                 │
├─────────────────────────────────────────────────────────────┤
│ Phase 2: Process Implementation                             │
│   → Delegates to: Solution Consultant                       │
│   → Output: Implementation log, D365 configurations,        │
│             dashboard-ready progress updates                │
├─────────────────────────────────────────────────────────────┤
│ Phase 3: Data Load Readiness                                │
│   → Delegates to: Solution Consultant                        │
│   → Output: Data-load readiness checklist and validation     │
├─────────────────────────────────────────────────────────────┤
│ Phase 4: Final Summary                                      │
│   → Creates: Project implementation summary                 │
│   → Handoff: User receives complete outcome report          │
└─────────────────────────────────────────────────────────────┘
```

## Agent Selection Guide

| Scenario | Agent to Invoke |
|----------|-----------------|
| Need end-to-end process implementation | **Project Manager** |
| Have Teams transcript, need requirements extracted | **Solution Architect** |
| Implementation file ready, need D365 configured | **Solution Consultant** |
| Need system prepared for external data load | **Solution Consultant** |
| Not sure if implementation file is complete | **Solution Architect** (validation mode) |
| Process partially implemented, need specific feature | **Solution Consultant** (with scope clarification) |
| Data load prerequisite failed, need triage | **Solution Consultant** |

## Agent Isolation and Context

Each agent has **context isolation** — they do not see each other's conversation history. When delegating:

1. **Be explicit** — Provide all necessary context (file paths, process name, legal entity).
2. **Request specific outputs** — Tell the agent what deliverable you expect.
3. **Surface results** — When one agent completes, provide their output to the next agent if needed.

**Example (Project Manager orchestrating):**
```
✅ Solution Architect validated Processes/Implement_Record_To_Report.template.md
Status: Ready | 0 blockers | 45 requirements captured

🔄 Delegating one dashboard item to Solution Consultant with context:
- Dashboard item: RTR-CFG-003
- Work item: Configure financial dimensions and account structures
- Process: Record_To_Report
- Implementation file: Processes/Implement_Record_To_Report.template.md
- Skill file: .github/Skills/record-to-report/SKILL.md
- Legal entity: USMF
```

## Tool Restrictions by Agent

| Tool/MCP | Project Manager | Solution Architect | Solution Consultant |
|----------|-----------------|--------------------|--------------------|
| read | ✅ | ✅ | ✅ |
| edit | ✅ | ✅ | ✅ |
| search | ✅ | ✅ | ✅ |
| agent (subagents) | ✅ | ✅ | ✅ |
| microsoftdocs/mcp | ❌ | ✅ | ✅ |
| dynamics365 | ❌ | ❌ | ✅ |

**Design Rationale:**
- **Project Manager**: Orchestration only — no implementation tools.
- **Solution Architect**: Research and documentation — no D365 access.
- **Solution Consultant**: Full implementation access — configures D365 directly.

---

## Workspace Process Skills

Each business process has a corresponding skill in `.github/Skills/<Process>/SKILL.md`:

- `Record_To_Report` — R2R process implementation
- `Order_To_Cash` — (future)
- `Procure_To_Pay` — (future)
- `Inventory_To_Deliver` — (future)

These skills define:
- Step-by-step implementation sequence
- Configuration dependencies and prerequisites
- Required inputs and validation rules
- Legal entity management rules

**Agents reference these skills as the implementation contract.**

---

## Document Conventions

### Implementation Files
- **Location:** `Processes/Implement_<Process>.template.md`
- **Purpose:** Business requirements and configuration decisions
- **Owner:** Solution Architect (populates), Solution Consultant (consumes)
- **Status values:** In Scope, Out of Scope, Future Phase, Unknown

### Implementation Logs
- **Location:** `Output/<Process>_Implementation_log.md`
- **Purpose:** Detailed record of what was configured, where, and with what data
- **Owner:** Solution Consultant (creates)
- **Fields:** Step, Feature, Status, Legal Entity, Menu Path, Data, Validation, Timestamp

### Implementation Summaries
- **Location:** `Output/<Process>_Implementation_Summary.md`
- **Purpose:** Executive summary of implementation with outcomes from all agents
- **Owner:** Project Manager (creates)
- **Sections:** Timeline, deliverables per agent, overall status, next steps

### Readiness Reports
- **Location:** `Output/<Process>_Readiness_Report.md`
- **Purpose:** Structured validation of implementation completeness and configuration blockers
- **Owner:** Solution Architect (creates)
- **Sections:** Status summary, domain gaps, recommendations, stakeholder questions

---

## Legal Entity Verification (Mandatory)

All agents with D365 access **MUST verify and set the correct Legal Entity** before configuration.

**Why:** D365 F&SCM is multi-entity by design. Configurations in wrong entity require manual cleanup.

**Workflow:**
1. Identify target legal entity from implementation file.
2. Verify current legal entity in D365 UI.
3. Switch legal entity if needed.
4. Re-verify before saving configuration.

**Checkpoints:**
- Before creating master data (customers, vendors, items, main accounts).
- Before configuring posting profiles or financial dimensions.
- After any legal entity creation or modification.

If legal entity is unknown, **stop and ask** — never guess.

---

## Getting Started

### New Implementation
```
@Project Manager Please implement the Record_To_Report process. 
Implementation file: Processes/Implement_Record_To_Report.template.md
```

### Requirements Extraction Only
```
@Solution Architect Please extract requirements from this transcript 
and populate Processes/Implement_Record_To_Report.template.md.
[attach or paste transcript]
```

### Configuration Only (Implementation File Already Complete)
```
@Solution Consultant Please implement Record_To_Report using 
Processes/Implement_Record_To_Report.template.md as requirements.
```

### Data Load Readiness Only
```
@Solution Consultant Please prepare Record_To_Report for external main account data load.
Validate legal entity USMF prerequisites, account category mappings, and readiness checks
for MainAccountEntity. Do not execute the import.
```

---

## Support and Troubleshooting

### Agent Not Found
- Verify agent file exists in `.github/agents/`
- Check that `description` field in frontmatter is present
- Restart VS Code to reload agent registry

### Agent Ignores Instructions
- Check tool restrictions in `tools:` frontmatter array
- Verify agent has access to required MCP servers
- Review agent's specific instructions in `.agent.md` file

### Implementation Blockers
- Check implementation log for blocker details
- Review legal entity context (most common issue)
- Validate prerequisites from process skill

### Data Load Readiness Failures
- Review Solution Consultant readiness validation report
- Check CSV file format matches template
- Verify target legal entity exists and is accessible
- Confirm prerequisite configurations are in place

For additional guidance, see:
- `.github/copilot-instructions.md` — Core D365 implementation principles
- `.github/Skills/<Process>/SKILL.md` — Process-specific implementation workflow
- `Microsoft BPC/` — Microsoft Business Process Catalog reference
