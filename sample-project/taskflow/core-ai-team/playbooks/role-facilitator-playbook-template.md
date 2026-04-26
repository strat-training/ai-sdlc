# Facilitator Playbook Template

> Copy this file. Rename it for your segment (e.g., `w1-brd-facilitator-playbook.md`).
> Fill in all sections before Day 1. Update Lessons Learned after the session.

---

## Segment Identity

- **Week / Day:** Week ___ / Day 1 (Monday in-person)
- **Artifact:** ___________________________ (e.g., BRD, PRD, Architecture Document)
- **Module:** Module ___ — ___________________________
- **Facilitator (core AI team):** ___________________________
- **Cohort:** Cohort ___ / Date: ___________________________
- **Segment duration:** ___ minutes (walkthrough) + ___ minutes Q&A

---

## Segment Overview

One paragraph describing what this segment teaches, who it's for, and what
participants will be able to do after it.

```
(write here)
```

---

## Pre-Session Checklist

- [ ] TaskFlow repo cloned and running locally
- [ ] Relevant TaskFlow artifact loaded and open (e.g., `docs/artifacts/BRD.md`)
- [ ] Seed prompts open (`knowledge/prompts/{role}/`)
- [ ] Quality bar checklist reviewed (from Module 2, Part 5)
- [ ] Gate sign-off template ready (`knowledge/templates/gate-signoff-template.md`)
- [ ] Async consultation channel set up for Days 2–4
- [ ] Worked example prepared (see Section 4 below)

---

## Walkthrough Script (Day 1)

### Opening (2 min)

What to say to frame this segment:

```
(write here — keep it tight, first-person)
```

### Step 1 — Show the artifact (3 min)

Open the relevant TaskFlow approved artifact. Walk through its structure.
What to point at, what to highlight, what to call out as "notice this":

```
(write here)
```

### Step 2 — Show the prompting approach (10 min)

Live demo: open a fresh AI session, load context, prompt for a section of the artifact.
Walk through the prompt structure out loud:

- Role assignment: ___________________________
- Context loaded: ___________________________
- Task stated: ___________________________
- Format specified: ___________________________
- Constraints added: ___________________________

What to show working well:

```
(write here)
```

What to show failing and why:

```
(write here — showing failure modes is as important as showing success)
```

### Step 3 — Show iterative refinement (5 min)

Take the AI's first output. Identify one thing to improve. Refine the prompt.
Show how the output improves. Walk through the judgment call:

```
(write here)
```

### Step 4 — Run the quality bar (3 min)

Show how to run the module's quality bar checklist against the output.
Walk through each item. Land on a verdict:

```
(write here — be explicit about what passes and what doesn't)
```

### Closing / hand-off to async (2 min)

What to say before participants start their own async work:

```
(write here)
- Remind them of the async consultation channel
- Remind them of the quality bar they need to hit by Day 5
- Remind them that TaskFlow's artifact is the reference quality bar
```

---

## Worked Example

Paste the exact prompt(s) you'll demo live here. Keep them here for reference
across cohorts — update when you find better versions.

### Context loaded

```
(list the files / text you load as context)
```

### Prompt used

```
(paste the full prompt)
```

### Output received (summary)

```
(summarize the AI output — don't need to paste all of it)
```

### What made it work (or not)

```
(write here)
```

---

## Anticipated Cohort Questions (Days 2–4 Async)

Based on past cohorts (or your first-time estimate), list the 5–8 most likely
questions participants will ask during the async days. Write your intended answer
for each — this speeds up your async response time and keeps answers consistent.

| # | Likely question | Your answer |
|---|---|---|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |

---

## Day 5 Gate Review — Your Role

At Friday's gate review, you co-lead the quality bar review for this artifact.

**What to check (in order):**

1. [ ] Required sections present (from module's quality bar)
2. [ ] Quality checklist items pass
3. [ ] Traceability link to upstream artifact is explicit and correct
4. [ ] Common failure modes NOT present (list them)
5. [ ] Verdict: Approved / Approved with follow-ups / Needs rework / Blocked

**Common failure modes for this artifact:**

```
(write here — copy from module's quality bar section)
```

**Sign-off form path:** `docs/reviews/{week}-friday-signoff.md` in the cohort's sample-project repo.

---

## Lessons Learned (fill in after session)

### What worked

```
(write here after the session)
```

### What didn't work

```
(write here)
```

### Prompt improvements for next cohort

```
(paste improved prompts here)
```

### Cohort questions we didn't anticipate

```
(write here — update the "Anticipated Questions" section above for next cohort)
```

### Recommended changes for next cohort

```
(write here — timing, content, worked example, quality bar, etc.)
```

---

*This playbook is a living document. Update it after every cohort.*
*Better playbooks = better training = better engineers.*
