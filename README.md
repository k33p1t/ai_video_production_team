# Video Production Team

**An AI-orchestrated video production system designed for continuous, local-first operation.**

This repository contains the complete agent definitions, schemas, architecture, and setup guides for a production pipeline that turns manual ideas and trending research into finished, human-approved videos.

The system is built around eight specialized AI agents plus one on-demand assembly worker, all coordinated by a lightweight Supervisor that never performs creative work itself.

---

## Key Features

- **Continuous production queue** — Manual ideas and researched trends share the same durable backlog
- **Human approval gate** — No video is published until you explicitly approve the exact final artifact
- **Local-first design** — Runs primarily on your own hardware (RTX 3060 + micro PCs / spare machines)
- **Revenue-aware upgrades** — Cloud and GPU upgrades are treated as optional, budget-controlled stages
- **Full audit trail** — Append-only event logs, versioned artifacts, and recoverable project state
- **Rework routing** — Failed stages are sent back to the correct agent instead of restarting the whole project
- **Rights & safety gates** — Copyright, safety, and platform-policy checks are hard pass/fail blockers
- **Idea Bank + voting** — Persistent store of niche / cult / fan-following topics with weighted agent + human votes, slow decay, and Top 20 dashboard view

---

## The Agents

| #  | Agent                              | Role |
|----|------------------------------------|------|
| 01 | **Supervisor**                     | Orchestrates tasks, validates outputs, manages resources, escalates issues. Never creates content. |
| 02 | **Trend Strategist**               | Generates and ranks original video concepts from research and manual ideas |
| 03 | **Trends Researcher**              | Collects evidence, metrics, and rights flags from YouTube, TikTok, X, etc. |
| 04 | **Storyboard Creator**             | Produces detailed shot lists, visual plans, and asset manifests |
| 05 | **Scriptwriter**                   | Writes natural, timed scripts with CTAs and claim citations |
| 06 | **Voice-Over Specialist**          | Creates narration and audio assets via TTS / recording tools |
| 07 | **Quality Assurance**              | Independent review of content, technical quality, rights, and metadata |
| 08 | **Publishing & Monitor**           | Prepares metadata, uploads only after approval, tracks performance & comments |
| —  | **Video Assembly Worker**          | On-demand FFmpeg / editor worker that renders the final video |

---

## High-Level Workflow

```text
Manual Idea  ──┐
               ├──► Normalize → Score → Vote → Select / Backlog
Trend Research ┘
                      │
                      ▼
               Storyboard → Script → Voice → Assembly → QA
                      │
                      ▼
               Human Final Approval
                      │
                      ▼
               Publish → Verify → Monitor
```

Projects waiting for your approval do **not** block other eligible projects in the queue.

---

## Repository Structure

```text
video-production-team/
├── agents/                     # All soul.md definitions
│   ├── 01-supervisor/
│   ├── 02-trend-strategist/
│   ├── 03-trends-researcher/
│   ├── 04-storyboard-creator/
│   ├── 05-scriptwriter/
│   ├── 06-voice-over/
│   ├── 07-quality-assurance/
│   ├── 08-publishing-monitor/
│   └── workers/video-assembly/
├── architecture/               # System design docs
│   ├── WORKFLOW.md
│   ├── LOCAL_FIRST_DEPLOYMENT.md
│   └── HARDWARE_STRATEGY.md
├── docs/                       # Setup & reference
│   ├── STEP_BY_STEP_SETUP.md
│   └── agent-responsibilities.md
├── schemas/                    # JSON schemas for projects, tasks, events, voting
├── templates/                  # Example project.json + folder skeleton
└── README.md
```

---

## Start here if you are not technical

Read the plain-language overview first:

**[docs/PROJECT_OVERVIEW_FOR_HUMANS.md](docs/PROJECT_OVERVIEW_FOR_HUMANS.md)**  
— What the system does, how ideas become videos, how it researches niches and trends, how it catches and fixes problems, and how you stay in control.

---

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/video-production-team.git
   cd video-production-team
   ```

2. **Read the setup guide**  
   Start with [`docs/STEP_BY_STEP_SETUP.md`](docs/STEP_BY_STEP_SETUP.md)

3. **Inventory your hardware**  
   Run `nvidia-smi` and record the exact GPU model + VRAM before loading large local models.

4. **Stand up the control plane**  
   Place the Supervisor + queue + database on a reliable always-on low-power machine.

5. **Connect LM Studio**  
   Point workers at your local OpenAI-compatible endpoint on the gaming desktop.

6. **Load the agents**  
   Import each `soul.md` into your preferred runtime (Hermes, CrewAI, custom, etc.).

---

## Hardware Philosophy

This system is intentionally **local-first**:

- Primary inference & rendering → your gaming desktop (currently RTX 3060 class + 64 GB RAM)
- Always-on control plane → micro PC / older desktop
- Older machines → lightweight workers, storage, dashboard clients
- Cloud → overflow only, with hard monthly spend limits
- RTX 5060 (or better) upgrade → only after monetized revenue covers operating costs + reserve

See [`architecture/HARDWARE_STRATEGY.md`](architecture/HARDWARE_STRATEGY.md) for the full upgrade gate criteria.

---

## Design Principles

- The **Supervisor never does production work**. It only coordinates, validates, and escalates.
- **Human approval is mandatory** for the exact final video version before any public upload.
- **Manual ideas** are first-class citizens and stay in the backlog until completed, rejected, or put on hold.
- **Rights, safety, and policy issues** cannot be overridden by trend scores or agent votes.
- All important actions are written to append-only event logs for full recoverability and audit.

---

## Status

This repository currently contains:

- Complete agent soul definitions
- Production workflow and scoring design
- JSON schemas for projects, tasks, events, candidates, and voting
- Local-first deployment and hardware strategy
- Step-by-step setup guide

The runtime (queue, database, dashboard, worker launcher) is intentionally left for you to implement on top of these contracts so you can match it to your preferred stack.

---

## Suggested Implementation Order

1. Control plane + project recovery
2. Manual idea intake
3. Trend research + scoring + voting
4. Storyboard → Script → Voice pipeline
5. Assembly worker + QA
6. Human approval UI
7. Authorized publishing + monitoring

---

## License

Add your preferred license (MIT is recommended for this type of project).

---

**Built for continuous, recoverable, human-in-the-loop video production.**
