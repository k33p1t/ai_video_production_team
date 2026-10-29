# Hardware Strategy — Local First, Revenue Funded Upgrades

## Current Assets (as described)
- Primary desktop: NVIDIA GPU (reported as 3060 / 20 GB — **verify with `nvidia-smi`**), 64 GB RAM, LM Studio running Qwen and other local models
- Several Android set-top boxes
- Micro PCs similar to Lenovo ThinkCentre M700 form factor (specs unknown — inventory required)
- Older laptops and desktops available for dedicated roles

## Immediate Actions
1. Run `nvidia-smi` and record exact GPU model, VRAM, driver version.
2. Inventory every micro PC / laptop: CPU model, RAM, disk health (`smartctl`), OS, power draw, Ethernet reliability.
3. Decide which low-power machine becomes the always-on Supervisor + queue + dashboard host.
4. Keep the gaming desktop as the exclusive GPU / heavy-media host until concurrency is proven safe.

## Role Assignment Recommendations
| Role                        | Preferred Host                  | Notes |
|----------------------------|---------------------------------|-------|
| Supervisor + Queue + DB    | Always-on micro PC / old desktop| Lightweight, must stay up 24/7 |
| LM Studio / local LLMs     | Gaming desktop (3060)           | Single GPU lock at first |
| FFmpeg / render            | Gaming desktop                  | Same machine as models when possible |
| TTS / audio                | Gaming desktop or secondary     | Depends on chosen TTS engine |
| Research transforms / JSON | Any CPU-only machine            | Cheap and parallelizable |
| Dashboard clients          | Android boxes / browser         | Read-only monitoring |
| File / media storage       | Desktop SSD or dedicated NAS    | Outside ephemeral workers |

## Model Routing (Local First)
- Routine orchestration / classification → small fast local instruct model (or pure code)
- Trend research summaries + concept drafts → Qwen instruct model that fits verified VRAM
- Storyboard + Script → stronger local instruct model; fall back to hosted only when acceptance fails or high-value task justifies cost
- Voice → dedicated local TTS (not the LLM itself)
- QA → independent review pass, preferably different model/prompt from generator
- Publishing metadata → small local model + deterministic platform APIs

## Upgrade Gate — RTX 5060 or Better
Upgrade only when **all** of the following are true:
- At least one channel is monetized and revenue is recurring
- Operating costs (power, storage, any cloud overflow) are covered
- A cash reserve equal to the agreed runway remains intact
- Logs show GPU memory or throughput is a real production bottleneck
- Benchmarks prove the new card improves cost-per-approved-video or turnaround enough to justify the purchase
- PSU, case clearance, cooling, and power connectors are compatible

Until then, stay local-first and treat cloud GPU as expensive overflow with hard monthly caps.
