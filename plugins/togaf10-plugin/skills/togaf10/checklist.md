# TOGAF 10 ADM Deliverable Checklist

A phase-by-phase list of the documents a TOGAF ADM engagement can produce. Not every engagement
needs every item — most use 40–60% of this list. Use it to scope an engagement, then track
which items are agreed-needed vs. out of scope.

`📄` = starter template available in `templates/`. Everything else: draft directly from its
description using standard TOGAF 10 content-metamodel guidance.

## Preliminary Phase — Framework & Principles

| Deliverable | Description |
|---|---|
| 📄 Architecture Principles | Foundational rules and guidelines the architecture work must follow |
| Organizational Model for Enterprise Architecture | Who does EA, governance structure, roles/responsibilities |
| Architecture Governance Framework | How architecture decisions get made, reviewed, enforced |
| Architecture Repository structure | Where artifacts, models, and reference materials live |
| Tailored Architecture Framework | TOGAF 10 tailored to this org's terminology, process, and tooling |
| Request for Architecture Work (initial) | The formal trigger authorizing an ADM cycle |
| Architecture Capability Assessment | Current EA maturity, skills, tooling gaps |
| Business Case for EA capability (if standing up EA function) | Justification and funding ask |

## Phase A — Architecture Vision

| Deliverable | Description |
|---|---|
| 📄 Statement of Architecture Work | Scope, approach, deliverables, plan, sign-off — the engagement charter |
| 📄 Stakeholder Map / Stakeholder Management Plan | Stakeholders, concerns, influence/interest, engagement approach |
| 📄 Architecture Vision document | Problem statement, scope, value proposition, high-level target state |
| Business Requirements Document (BRD) | Business needs driving the initiative (often owned jointly with the business) |
| Business Scenarios | Concrete scenarios illustrating business drivers and desired outcomes |
| Capability Assessment (baseline) | Current-state capability maturity relevant to the vision |
| Communications Plan | How architecture progress and decisions are communicated to stakeholders |
| Risk Register (architecture-level) | Architecture risks and mitigations identified at kickoff |
| Value Proposition / Business Case | Why this initiative is worth doing |
| Refined Request for Architecture Work | Updated formal authorization after Phase A scoping |

## Phase B — Business Architecture

| Deliverable | Description |
|---|---|
| 📄 Business Capability Model | Capability inventory, maturity heat-map, alignment to strategy |
| Business Architecture Definition | Organization structure, processes, functions, roles |
| Value Stream Map | End-to-end value delivery flows |
| Business Process Models | Key process definitions relevant in scope |
| Organization Map | Org units, locations, relationships |
| 📄 Gap Analysis (Business) | Baseline vs. target business architecture gaps |
| Business Interoperability Requirements | Cross-unit/cross-org business dependencies |
| Business Architecture Report | Consolidated Phase B findings and decisions |
| Functional Decomposition Diagram | Business functions broken down to actionable detail |
| Roadmap Components (Business) | Business-architecture-level building blocks feeding the overall roadmap |

## Phase C — Information Systems Architectures (Data + Application)

### Data Architecture

| Deliverable | Description |
|---|---|
| 📄 Data Architecture Definition | Target data architecture: entities, flows, stores |
| Data Governance Plan | Ownership, quality, lifecycle, stewardship rules |
| Data Entity/Business Function Matrix | Which functions own/use which data entities |
| Data Dissemination Diagram | How data moves across the estate |
| Data Security Requirements | Classification, access control, protection requirements |
| 📄 Gap Analysis (Data) | Baseline vs. target data architecture gaps |
| Master Data Management Approach | MDM strategy, if applicable |

### Application Architecture

| Deliverable | Description |
|---|---|
| 📄 Application Portfolio Catalog / Inventory | Current application landscape and rationalization decisions |
| Application Architecture Definition | Target application landscape and interaction model |
| Application Communication Diagram | Integration/interaction patterns between applications |
| Application/Data Matrix | Which applications use which data entities |
| Interface Catalog | Application-to-application interfaces, protocols, SLAs |
| 📄 Gap Analysis (Application) | Baseline vs. target application architecture gaps |
| Application Migration/Rationalization Plan | Retire/replace/retain/re-platform decisions |
| SOA/Integration Design (if applicable) | Service-oriented or integration-layer design |

## Phase D — Technology Architecture

| Deliverable | Description |
|---|---|
| 📄 Technology Architecture Definition | Target infrastructure, platform, and technology standards |
| Technology Standards Catalog | Approved technologies, versions, patterns |
| Network/Infrastructure Diagram | Physical and logical infrastructure topology |
| Platform Services Catalog | Shared platform capabilities (compute, IAM, observability, etc.) |
| Infrastructure-as-Code / Configuration Management Approach | How technology architecture is codified and enforced |
| 📄 Gap Analysis (Technology) | Baseline vs. target technology architecture gaps |
| Environments & Deployment Model | Dev/test/stage/prod topology and promotion process |
| Technology Portfolio Rationalization | Consolidation/retirement decisions at the tech layer |

## Phase E — Opportunities & Solutions

| Deliverable | Description |
|---|---|
| Consolidated Gaps, Solutions & Dependencies Matrix | Cross-domain (B/C/D) gap synthesis feeding the roadmap |
| Project/Work Package Definitions | Discrete units of delivery derived from gaps |
| Transition Architectures | Intermediate target states between baseline and final target |
| Implementation Factor Assessment | Cost, risk, benefit, business readiness per option |
| Consolidated Architecture Roadmap (initial) | Sequenced view of work packages and transition states |

## Phase F — Migration Planning

| Deliverable | Description |
|---|---|
| 📄 Migration Roadmap / Implementation & Migration Plan | Sequenced work packages, transition architectures, timeline |
| Cost/Benefit and Risk Assessment (per work package) | Financial and risk justification for the sequencing chosen |
| Migration Governance Approach | How migration progress is tracked and governed |
| Finalized Architecture Roadmap | Fully sequenced, approved roadmap |

## Phase G — Implementation Governance

| Deliverable | Description |
|---|---|
| 📄 Architecture Compliance Assessment | Solution-vs-architecture compliance review for a specific delivery |
| Architecture Contract | Agreement between architecture function and delivery teams on scope/compliance |
| Implementation Governance Model | How the ARB (or equivalent) governs delivery against the architecture |
| Solution/Project Architecture Reviews | Point-in-time reviews of in-flight delivery against the target architecture |

## Phase H — Architecture Change Management

| Deliverable | Description |
|---|---|
| 📄 Architecture Change Request | Formal request to change an approved architecture, with rationale |
| Architecture Change Management Process | How change requests are triaged, assessed, and approved |
| Architecture Impact Assessment | Impact of a proposed change on existing architecture and roadmap |
| Post-Implementation Review | Lessons learned after a work package or migration completes |

## Requirements Management (continuous, all phases)

| Deliverable | Description |
|---|---|
| 📄 Architecture Requirements Specification | Consolidated, traceable requirements register, versioned across phases |
| Requirements Traceability Matrix | Maps requirements to architecture decisions and deliverables |
| Architecture Decision Records (ADRs) | Point-in-time decisions with rationale, alternatives considered, consequences |

---

**Coverage note:** this list intentionally mirrors the "most engagements use less than
everything" philosophy of the source template it's inspired by — treat it as a menu to select
from with the client, not a mandate to produce all ~90 items.
