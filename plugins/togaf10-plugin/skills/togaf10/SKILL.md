---
name: togaf10
description: TOGAF® Standard, 10th Edition ADM deliverable checklist and starter templates. Use whenever drafting or scoping TOGAF architecture deliverables — Architecture Vision, Business/Data/Application/Technology Architecture definitions, gap analyses, migration plans, compliance reviews, ADRs — or when deciding which ADM documents an engagement actually needs. Domain-agnostic: applies to any organization, industry, or technology stack.
---

# TOGAF 10 ADM Toolkit

Checklist inspired by the community-maintained
[TOGAF-Master-Documenting-Template](https://github.com/JasonTeixeira/TOGAF-Master-Documenting-Template),
expanded and organized to the TOGAF® Standard, 10th Edition's ADM phase structure. This is a
**checklist of what to produce**, not a tutorial on how the ADM works — for methodology, defer
to the TOGAF 10 specification itself.

## How to use this

1. **Never produce the full list by default.** Most engagements use 40–60% of these
   deliverables. Start by asking (or inferring from context): engagement size, criticality,
   regulatory exposure, whether this is a full enterprise-wide ADM cycle or a scoped
   segment/capability architecture. Then propose a subset from `checklist.md` and confirm it
   with the user before drafting anything.
2. **Use `checklist.md`** as the master reference — it lists every deliverable by phase with a
   one-line description and whether a starter template exists in `templates/`.
3. **When drafting a deliverable**, start from its template in `templates/` if one exists (see
   the table below), fill it in from the conversation's context, and explicitly flag any
   section you couldn't fill in — never silently invent client-specific facts (org names,
   figures, dates) to fill gaps.
4. **Track state** across a multi-session engagement: which deliverables are agreed-needed,
   drafted, reviewed, and signed off. Use the harness's task-tracking tools for this rather than
   re-deriving the list each time.
5. **Phase G and H are frequently owned by PMO/governance functions, not the architect** — don't
   over-produce there unless the user is explicitly acting in that governance role.

## Available templates

| Template | Phase | Use for |
|---|---|---|
| `templates/architecture-principles.md` | Preliminary | Foundational principles the whole engagement is governed by |
| `templates/stakeholder-map.md` | A | Stakeholder identification, concerns, influence/interest |
| `templates/architecture-vision.md` | A | The vision document — problem, scope, high-level target state |
| `templates/statement-of-architecture-work.md` | A | Scope, approach, deliverables, plan, approval — the engagement's charter |
| `templates/business-capability-model.md` | B | Capability inventory, maturity, heat-map against strategy |
| `templates/data-architecture-definition.md` | C | Data entities, governance, lifecycle, target data architecture |
| `templates/application-portfolio-catalog.md` | C | Application inventory, rationalization decisions |
| `templates/technology-architecture-definition.md` | D | Platform/infrastructure standards, target technology architecture |
| `templates/architecture-requirements-specification.md` | cross-phase | Consolidated, traceable requirements (feeds Requirements Management) |
| `templates/gap-analysis.md` | cross-phase (B/C/D) | Baseline vs. target, gap disposition |
| `templates/migration-roadmap.md` | E/F | Work packages, transition architectures, sequencing |
| `templates/architecture-compliance-assessment.md` | G | Solution-vs-architecture compliance review |
| `templates/architecture-change-request.md` | H | Change request / ADR triggered by drift or new requirement |

For any deliverable in `checklist.md` without a template listed, draft it directly from the
checklist's description and standard TOGAF 10 content-metamodel guidance — don't block on a
missing template.

## Full deliverable checklist

See `checklist.md` for the complete phase-by-phase list.

## TOGAF 10 specifics to keep in mind while drafting

- Business Capabilities are a first-class artifact — prefer building/referencing a capability
  model (Phase B) before drafting downstream Data/Application/Technology architectures, even on
  scoped engagements.
- Requirements Management deliverables (the Architecture Requirements Specification) should be
  versioned and revisited every phase, not written once in Phase A.
- Where the engagement is a digital transformation or data modernization effort, lean on the
  data/information and digital-enterprise framing that TOGAF 10's Series Guides emphasize, even
  though this toolkit doesn't reproduce those guides verbatim.
- Keep deliverables traceable: every artifact should reference the business driver, principle,
  or requirement that justifies it.
