# Local-First Deployment Plan

## Logical Topology

```text
Manual idea intake / scheduled trend trigger
                  |
                  v
     Dashboard + API + durable queue
                  |
                  v
  Always-on Supervisor (control-plane host)
       |         |          |
       |         |          +--> audit / event / error logs
       |         +-------------> SQLite (start) → PostgreSQL later
       +-----------------------> task lifecycle / health checks
                  |
                  v
    Local worker dispatcher / resource manager
       |                              |
       v                              v
Desktop (RTX 3060 + 64 GB)     CPU-only micro-PC / laptop workers
LM Studio + Qwen models        (research transforms, file checks,
FFmpeg, TTS, render            dashboard, lightweight tasks)
       |
       v
Project artifact folders + media storage + versioned snapshots
       |
       v
QA → Human final approval → Publishing → Monitoring
```

## Start Small (Recommended Order)

1. Inventory every machine:
   - Desktop: `nvidia-smi` → exact GPU model + VRAM, driver, free SSD, cooling
   - Micro PCs / older machines: CPU, RAM, disk health, power draw, network
   - Android boxes: treat as dashboard clients only

2. Stand up the control plane on one reliable always-on host:
   - Database (SQLite first)
   - Durable task queue
   - Event log (JSONL)
   - Dashboard + manual idea form
   - Supervisor process

3. Connect LM Studio on the gaming desktop via its local OpenAI-compatible endpoint (LAN only if firewalled).

4. Enforce a single GPU-heavy job lock at first. Measure VRAM, temperature, and queue time before increasing concurrency.

5. Add agents in this order:
   - Trends Researcher + Strategist
   - Storyboard + Script
   - Voice-Over
   - Assembly worker (FFmpeg)
   - QA
   - Publishing + monitoring

6. Add cloud workers only after local bottlenecks are measured and a hard monthly spend limit is set.

## Resource Locks
- GPU lock: only one model load / heavy render at a time until proven otherwise
- Supervisor must release the lock after validated output or timeout
- Never let two agents fight over the same GPU process

## Recovery
- All project state lives outside the worker
- Restart of any machine must recover from database + event log
- Test a full restart + recover cycle before calling the system production-ready
