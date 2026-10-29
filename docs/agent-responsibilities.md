# Agent Responsibilities Quick Reference

| Agent ID | Role | Owns | Does NOT Own |
|----------|------|------|--------------|
| 01 | Supervisor | Orchestration, state, validation, escalation, resource lifecycle | Any creative content, final approval, publishing |
| 02 | Trend Strategist | Concept generation, scoring, ranking | Evidence collection, storyboards, scripts |
| 03 | Trends Researcher | Platform research, metrics, provenance, rights flags | Creative angles, final selection |
| 04 | Storyboard Creator | Shot lists, visual plans, asset manifests | Final video, scripts, audio |
| 05 | Scriptwriter | Timed scripts, CTAs, claim citations | Visual direction, audio rendering, publishing |
| 06 | Voice-Over | Narration audio, mix, licensing of audio assets | Script changes, video assembly |
| 07 | Quality Assurance | Independent review, defect tickets, preflight | Creating the work it reviews, final human approval |
| 08 | Publishing & Monitor | Metadata packages, authorized upload, metrics, comment triage | Creating content, posting sensitive replies, auto-publishing |
| Worker | Video Assembly | Deterministic render from approved assets | Creative changes, approval, publishing |

## Handoff Rule
Every agent returns a structured result.  
The Supervisor alone decides whether the result is accepted and the next task is queued.
