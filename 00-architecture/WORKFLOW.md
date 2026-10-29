# Production Workflow & Approval Gates

```text
IDEA INTAKE
  |-- Manual idea --------------------------------|
  |-- Scheduled / on-demand trend discovery ------|--> NORMALIZE + DEDUPLICATE
                                                        |
                                                        v
                                                SCORE + RIGHTS / POLICY GATES
                                                        |
                                                        v
                                              STRATEGIST + RESEARCHER VOTES
                                                        |
                                                        v
                                                SELECT or BACKLOG
                                                        |
                                                        v
                                                   STORYBOARD
                                                        |
                                                        v
                                                     SCRIPT
                                                        |
                                                        v
                                               VOICE + AUDIO ASSETS
                                                        |
                                                        v
                                            VIDEO ASSEMBLY (worker / human)
                                                        |
                                                        v
                                              AUTOMATED QA + REVIEW
                                              | pass              | fail
                                              v                   v
                                      FINAL HUMAN APPROVAL    REVISION TICKET
                                              |                   |
                                      approve / reject            +--> earliest
                                              |                        failed stage
                                       approve only
                                              |
                                              v
                                         PUBLISHING
                                              |
                                              v
                                     VERIFY LIVE POST / URL
                                              |
                                              v
                                    MONITOR METRICS + COMMENTS
                                              |
                                              v
                                           COMPLETE
```

## Continuous Queue Rules
- Manual ideas and trend-sourced concepts share one persistent backlog but keep their origin tag.
- A project waiting for final human approval does **not** block other eligible projects (subject to concurrency limits).
- No auto-publishing. The exact final video version + metadata + platform + channel + schedule must be approved.
- If anything changes after approval, the approval is invalidated.
- Rights / safety / factuality / privacy / platform-policy blockers cannot be overridden by votes or scores.
- Sensitive comments are routed to a human; no agent posts replies on high-risk topics without review.

## Project Lifecycle States
```
IDEA_SUBMITTED → QUEUED → RESEARCHING → SELECTED → STORYBOARDING →
SCRIPTING → AUDIO → ASSEMBLY → QA → AWAITING_APPROVAL → APPROVED →
PUBLISHING → PUBLISHED → MONITORING → COMPLETED
```

Additional states: `BLOCKED`, `CANCELLED`, `ON_HOLD`, `REJECTED`, `FAILED`

## Trend Scoring Rubric (100 points)
| Metric                        | Weight |
|-------------------------------|--------|
| Momentum / growth             | 20     |
| Audience demand / engagement  | 15     |
| Originality / differentiation | 15     |
| Production feasibility / cost | 15     |
| Monetization fit              | 10     |
| Shelf life / evergreen value  | 10     |
| Localization potential        | 5      |
| Platform fit / distribution   | 5      |
| Evidence confidence           | 5      |

Rights, safety, and policy are **separate pass/fail gates**, not score components.

## Rework Routing
| Defect found in          | Return to                  |
|--------------------------|----------------------------|
| Trend evidence weak      | Trends Researcher          |
| Concept unoriginal / bad fit | Trend Strategist       |
| Scenes missing / unclear | Storyboard Creator         |
| Narration awkward / wrong| Scriptwriter               |
| Audio quality / timing   | Voice-Over Specialist      |
| Assembly / render        | Video Assembly Worker      |
| Metadata / upload        | Publishing Agent           |

Supervisor tracks revision count. Default limit = 3 automated revisions, then escalate to human.
