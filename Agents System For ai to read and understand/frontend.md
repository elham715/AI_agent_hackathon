# Frontend Architecture Plan for Agentic Workflows

This document specifies a highly structured, modular Next.js + React frontend template designed to support **any standard agentic flow** (e.g., chat, autonomous coding, research, data analysis, multi-agent collaboration).

---

## 1. Core Goal & User Experience (UX)
An Agentic UI must prioritize **observability** over simple chat. The user should see the agent’s thoughts, tool calls, retrieved documents, and file mutations as they happen.

```text
+--------------------------------------------------------------------------------+
|                         AGENT WORKSPACE DASHBOARD                              |
+--------------------------------------------------------------------------------+
|  LEFT PANEL: Input & Settings   |  MIDDLE PANEL: Live Run Timeline & Chat      |
|  - Task Input (text/upload)     |  - User query bubble                         |
|  - Agent Pack Selector          |  - RUNNING STEP: [Executor] running search   |
|  - System Prompts & Config      |    - Thoughts: "Need to verify version..."  |
|  - Start / Pause / Reset        |    - Tool Log: tavily_search(q='...')        |
|                                 |  - Final Answer text bubble                  |
+---------------------------------+----------------------------------------------+
|  RIGHT PANEL: Memory & Context  |  BOTTOM PANEL: Output Artifacts              |
|  - Retrieved RAG documents      |  - Generated Code / Files                    |
|  - Shared Scratchpad (variables)|  - CSV Data Tables / Plotly Charts           |
|  - File Tree View               |  - HTML Preview Render                       |
+--------------------------------------------------------------------------------+
```

---

## 2. Directory Layout (`apps/web/`)
The frontend is organized by feature modules so visual components can be swapped easily.

```text
apps/web/
├── app/
│   ├── layout.tsx                # Base styling, font loaders, providers
│   └── page.tsx                  # Main workspace layout (collapsible grids)
├── components/                  # Reusable low-level UI elements (shadcn)
│   ├── ui/
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   └── tabs.tsx
│   └── markdown.tsx              # Safe markdown renderer with code highlights
├── features/                    # Agent UI Modules
│   ├── intake/
│   │   └── task-intake.tsx       # Intake form (prompts, presets, model parameters)
│   ├── timeline/
│   │   ├── run-timeline.tsx      # Main agent thought process timeline
│   │   ├── step-card.tsx         # Individual step showing status, logs, & tools
│   │   └── tool-badge.tsx        # Visual badge for tools (e.g., read_file, git_commit)
│   ├── context/
│   │   ├── memory-inspector.tsx  # Renders current vector context & active variables
│   │   └── file-tree.tsx         # Displays workspace files modified by agent
│   └── artifacts/
│       ├── viewer.tsx            # Switches between Markdown, Code, and HTML preview
│       └── code-preview.tsx      # Monaco or prism-based code viewer with copy button
├── lib/
│   ├── api-client.ts             # SSE stream consumer and REST calls
│   └── utils.ts                  # Shared styling & formatting utilities
└── stores/
    └── use-agent-store.ts        # Zustand state store for active runs
```

---

## 3. The "Lego Block" Agent UI Components

### A. Task Intake Panel (`task-intake.tsx`)
- **Purpose:** Collects the task description, registers initial variables, selects the agent domain pack, and fires the run.
- **Interactions:**
  - File Dropzone for injecting context documents.
  - Dropdown to select model configuration (Claude 3.5 Sonnet, GPT-4o, etc.).
  - Presets (e.g., "Review Code", "Research Market", "Clean CSV").

### B. Live Run Timeline (`run-timeline.tsx`)
- **Purpose:** Renders the LangGraph node execution sequence in real-time.
- **States Rendered:**
  - `IDLE`: Waiting for input.
  - `PLANNING`: Spinner showing planner node is breaking down the prompt.
  - `EXECUTING`: Accordion card showing which agent block is running, the agent's "inner monologue" (thought field), and tool arguments.
  - `VERIFYING`: Evaluating output constraints.
  - `COMPLETED`: Success state showing execution duration and final result.
  - `FAILED`: Highlights exact node + error trace that halted execution.

### C. Tool Execution Trace (`step-card.tsx`)
- **Purpose:** Shows what action the agent took.
- **Interactions:** Collapsible code-block containing:
  - Input: Tool invocation arguments (e.g. `{ path: "app/main.py", content: "..." }`).
  - Output: Raw tool execution string (e.g., compilation logs, search results, CLI output).

### D. Memory & Document Panel (`memory-inspector.tsx`)
- **Purpose:** Visualizes what the agent currently knows.
- **Displays:**
  - Chroma vector lookup results (documents sourced, score of match).
  - Scratchpad state variables (persistent variables preserved across runs).

### E. Artifacts Viewer (`viewer.tsx`)
- **Purpose:** Renders the payload of the agent's work.
- **Tab Layout:**
  - **Result Tab:** Beautiful markdown representation of the final answer.
  - **Files Tab:** File view of any code generated.
  - **Preview Tab:** Renders custom HTML widgets or graphics directly in the browser.

---

## 4. Server-Sent Events (SSE) Streaming Client
The frontend reads real-time trace events from FastAPI via EventSource.

```typescript
// apps/web/lib/api-client.ts
export interface AgentEvent {
  node: "planner" | "executor" | "verifier" | "router" | "end";
  status: "start" | "progress" | "complete" | "error";
  thought?: string;
  tool_calls?: Array<{ name: string; args: any; output?: string }>;
  scratchpad?: Record<string, any>;
  messages?: any[];
}

export function streamAgentRun(
  taskId: string,
  onEvent: (event: AgentEvent) => void,
  onComplete: () => void,
  onError: (err: any) => void
) {
  const eventSource = new EventSource(`http://localhost:8000/api/runs/${taskId}/stream`);

  eventSource.onmessage = (event) => {
    const data: AgentEvent = JSON.parse(event.data);
    onEvent(data);
    if (data.node === "end" && data.status === "complete") {
      eventSource.close();
      onComplete();
    }
  };

  eventSource.onerror = (err) => {
    eventSource.close();
    onError(err);
  };

  return () => eventSource.close();
}
```
