# D365 Configuration Agent Instructions

This repository is used to generate and execute Dynamics 365 Finance and Supply Chain implementation plans using prompts and specialized agents.

## 1. First-Time Setup After Install

### Step 1: Configure the Dynamics 365 MCP server URL

Update `.vscode/mcp.json` so the Dynamics 365 MCP server points to your environment URL.

Example shape:

```json
{
  "servers": {
    "dynamics365": {
      "url": "https://your-org.sandbox.operations.dynamics.com/mcp"
    }
  }
}
```

Use your actual tenant URL. Do not leave sample URLs in place.

### Step 2: Enable MCP support in Dynamics 365

In Dynamics 365, search for `MCP` and enable the Copilot/Chat MCP feature flag required in your environment.


## 2. Working Folders

- `Transcripts/`: discovery input files (meeting transcripts, notes)
- `Processes/`: generated process implementation markdown workbooks
- `Output/`: generated deliverables (readiness reports, logs, summaries, dashboards)
- `Sample/`: reference examples only

## 3. Main Workflow

### Step 1: Generate the process workbook

Run the prompt named `Process Markdown`.

- With transcript: provide a transcript in `Transcripts/` and run the prompt to extract requirements.
- Without transcript: run the same prompt and fill the process workbook manually.

Output target:
- `Processes/Implement_<Process>.template.md`

### Step 2: Review and adjust the workbook

Open the generated process file in `Processes/` and make any needed business or configuration adjustments before implementation starts.

### Step 3: Switch to Project Manager agent

After the process workbook is ready, switch to `Project Manager` agent.

The Project Manager agent orchestrates execution by delegating to supporting agents, including:
- `Solution Architect`
- `Solution Consultant`

These agents validate readiness and implement the configuration plan based on the approved process workbook.

## 4. Practical Notes

- The project manager agent will create an html dashboard that it will update throughout the process to monitor progress.
- Always verify legal entity context before any configuration activity.
- Use `Output/` as the active destination for generated deliverables.
- Data import execution remains manual outside agent automation; agents prepare configuration and data-load readiness.
