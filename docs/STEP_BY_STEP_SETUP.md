# Step-by-Step Setup Guide

## Phase 0 — Hardware Inventory (Do This First)

1. On the gaming desktop run:
   ```bash
   nvidia-smi
   ```
   Record exact GPU model, total VRAM, driver version, and free memory under load.

2. Inventory every micro PC / older machine:
   - CPU model
   - RAM amount
   - Disk health (`smartctl -a /dev/sdX` or equivalent)
   - OS and whether it supports containers
   - Power draw and network reliability

3. Choose one low-power, reliable machine as the always-on control plane (Supervisor + queue + database + dashboard).

4. Confirm the gaming desktop is the only machine that will load large local models and do heavy renders initially.

## Phase 1 — Control Plane Foundation

1. Install Python 3.11+, SQLite (or PostgreSQL later), and a simple web framework of your choice for the dashboard.
2. Create the project root:
   ```text
   video-production/
   ├── app/
   ├── database/
   ├── projects/
   ├── schemas/          ← copy from this package
   ├── agents/           ← copy the eight soul.md folders
   └── logs/
   ```
3. Load the JSON schemas from the `schemas/` folder.
4. Implement:
   - Project creation (manual idea form + optional trend trigger)
   - Durable task queue
   - Append-only `events.jsonl` / `errors.jsonl` / `decisions.jsonl`
   - Supervisor state machine that only transitions after validated outputs
5. Exit criterion: submit a manual idea → create project → restart the service → recover correct state.

## Phase 2 — Local Model Endpoint

1. Start LM Studio on the gaming desktop.
2. Load a Qwen instruct model that fits the verified VRAM with comfortable headroom.
3. Enable the local OpenAI-compatible server (bind to localhost or firewalled LAN only).
4. Point the Supervisor and workers at that endpoint.
5. Implement a GPU resource lock so only one heavy model job runs at a time.

## Phase 3 — Agent Loading

1. Copy each `soul.md` into your agent runtime (Hermes, CrewAI, custom, etc.).
2. Map roles:
   - Supervisor → always-on control plane host
   - Researcher / Strategist / Script / Storyboard / QA → can run on desktop or CPU workers
   - Voice-Over → desktop + dedicated TTS
   - Assembly → desktop with FFmpeg
   - Publishing → restricted credentials, approval-gated
3. Give every worker a task contract (see `schemas/task-contract.schema.json`).
4. Require every worker to return a structured result; Supervisor validates before state change.

## Phase 4 — First End-to-End Project

1. Submit one manual idea through the dashboard.
2. Let the pipeline run through research → concept → storyboard → script → voice → assembly → QA.
3. Review the final video yourself and record an explicit approval (or rejection).
4. Only after approval allow the Publishing agent to prepare and upload.
5. Confirm the live post and that monitoring records are written.

## Phase 5 — Continuous Operation

1. Enable scheduled trend research (optional) in addition to on-demand.
2. Keep the queue open for more manual ideas.
3. Set revision limits (default 3) and escalation rules.
4. Add cost and concurrency guards.
5. Only after revenue covers operating costs + reserve consider the RTX 5060+ upgrade.

## Security Checklist
- [ ] No secrets in project JSON, logs, or soul.md files
- [ ] Publishing credentials available only to the publishing worker and only after signed approval
- [ ] Dashboard not exposed directly to the internet (VPN or authenticated reverse proxy + MFA)
- [ ] Backups of database + project artifacts tested with a restore
- [ ] GPU lock prevents simultaneous heavy jobs

## Success Definition for “Production Ready”
- One complete project can be created, recovered after restart, pass QA, receive human approval, and be published without the Supervisor inventing content or bypassing gates.
- Multiple projects can sit in the queue and progress independently while one waits for approval.
