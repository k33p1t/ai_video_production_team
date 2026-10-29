# Idea Bank — Research Memory + Voting System

Persistent knowledge store for past research ideas, niche topics, and products / media / tech / clothing / etc. that have (or are building) cool, fanboy, or almost cult-like followings.

Designed so **Trends Researcher** and **Trend Strategist** can read and write it, the **Supervisor** can maintain scores and decay, and the **status dashboard** can show a live Top 20 with full drill-down.

---

## Files

| File | Purpose |
|------|---------|
| `idea_bank.json` | Current state of all ideas + config (source of truth for ranking) |
| `votes.jsonl` | Append-only log of every vote (audit + recompute) |
| `../schemas/idea-bank.schema.json` | JSON Schema for validation |

---

## Voting Rules (locked to your choices)

- **Who can vote**: Agents **and** you.
- **Weight**: Your vote is worth **3×** an agent vote.
- **Decay**: **Slow** — approximately **12% per month** applied to the weighted score.
- **Auto-add**: Researcher may auto-add any idea whose `confidence_at_intake` ≥ **0.65**. You can still edit, reject, archive, or delete later.
- **Override**: You can always promote, veto, archive, or force a score regardless of current rank.

### Score calculation

```
weighted_raw   = (human_vote_sum × 3.0) + agent_vote_sum
decayed_score  = weighted_raw after monthly decay
rank_score     = decayed_score + (cult_fanboy_score × 0.35) + small_recency_bonus
```

`rank_score` is what the dashboard uses for the Top 20.

---

## Categories (day-one set)

- `products`
- `movies_tv`
- `games`
- `tech_tools`
- `clothing_fashion`
- `vehicles`
- `music_artists`
- `creators_influencers`
- `events`
- `memes_trends`
- `other`

You can add more later; keep the enum in the schema and config in sync.

---

## How agents use it

### Trends Researcher (agent_03)
1. Runs normal platform research.
2. For each strong candidate, checks whether a similar idea already exists (title / tags / sources).
3. If new **and** confidence ≥ 0.65 → creates a new `IDEA-YYYY-NNNN` entry and writes an initial agent vote.
4. Always appends a line to `votes.jsonl`.
5. Never deletes ideas; only the human or Supervisor (on explicit reject/archive) changes status.

### Trend Strategist (agent_02)
1. Reads the current Top N + any ideas matching the active research theme.
2. Casts votes (positive or negative) with short reasoning.
3. Can propose merges or related links between ideas.
4. Uses high-ranking ideas as seeds for new video concepts.

### Supervisor (agent_01)
1. Periodically (weekly or monthly) runs the decay pass.
2. Recomputes `decayed_score` and `rank_score` for all active ideas.
3. Exposes the sorted Top 20 (and full list) to the dashboard API.
4. Records decay runs in the main event log.

### You (human)
- Vote from the dashboard or by editing / adding a vote entry.
- Change status (`active` → `watching` / `archived` / `rejected` / `produced`).
- Override rank when you know something the scores don’t.

---

## Dashboard requirements (status web page)

**Top 20 view (default)**
- Sorted by `rank_score` descending
- Columns: Rank, Title, Category, Cult score, Rank score, Lifecycle, Status, Last updated
- Quick actions: Vote +, Vote −, Open detail, Mark watching / archived

**Drill-down / Full list**
- Same table with pagination or virtual scroll
- Filters: category, lifecycle, status, date range, minimum cult score
- Search across title, summary, tags, niche_signals
- Click any row → detail pane showing summary, sources, vote history, linked projects, notes

**Optional later**
- Sparkline of score over time (from votes.jsonl)
- “Ideas that became videos” filter (linked_project_ids not empty)

---

## ID and file conventions

- Idea IDs: `IDEA-YYYY-NNNN` (zero-padded sequential per year)
- Vote IDs: `VOTE-NNNNNN` (global sequential)
- One idea = one object inside the `ideas` array
- All score-changing actions must also append to `votes.jsonl`

---

## Integration with existing production pipeline

1. When a video project is created from an idea, write the `project_id` into `linked_project_ids` and set status to `produced` (or keep `active` if you want follow-ups).
2. Researcher and Strategist task contracts should include:
   - Path to `idea_bank/idea_bank.json`
   - Current `auto_add_confidence_threshold`
   - Instruction to respect existing ideas (no near-duplicate spam)
3. Supervisor health check should confirm the idea bank file parses and the Top 20 can be computed.

---

## Minimal API surface the dashboard / Supervisor need

```text
GET  /api/ideas/top?limit=20
GET  /api/ideas?category=&status=&q=&page=
GET  /api/ideas/:id
POST /api/ideas/:id/vote   { value, reason }   // human or agent
PATCH /api/ideas/:id       // status, notes, etc.
POST /api/ideas            // manual add
```

All writes that change scores must update both `idea_bank.json` and append to `votes.jsonl`.

---

## Starting values (your choices)

| Setting | Value |
|---------|-------|
| Human vote weight | **3×** |
| Monthly decay | **~12%** |
| Auto-add threshold | **0.65** |
| Dashboard default | **Top 20** + full drill-down |
| Categories | Full starter set (11) |

You can change the numbers in `idea_bank.json → config` at any time; the Supervisor should read config on each decay/rank pass.
