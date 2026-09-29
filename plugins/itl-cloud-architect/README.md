# Cloud Architect Plugin

Enterprise-grade cloud control plane architecture advisor specializing in TOGAF 9.2 frameworks, microservices governance, resource provider patterns, and cloud-native platform engineering for the ITL Cloud Control Plane.

## Components

### Agent: `cloud-architect`

A comprehensive enterprise architecture agent covering:

- **TOGAF 9.2 Framework** — All 4 architecture domains (business, information, technology, applications)
- **Control Plane Architecture** — System overview, component breakdown, interaction patterns
- **Resource Provider Pattern** — Design, implementation, contract governance
- **Microservices Governance** — Patterns, anti-patterns, architectural standards
- **Multi-Cloud Integration** — Abstraction layers, cost optimization, vendor lock-in mitigation
- **Governance & Compliance** — ADRs, SOC2/ISO27001, change management, audit trails
- **Performance & Scalability** — Async/await optimization, caching, rate limiting, load balancing
- **Security & Identity** — OAuth2/OIDC, token management, encryption, secrets

## Quick Start

```
@cloud-architect Review the new Storage Provider design against our standards
@cloud-architect Design the metadata schema for our graph database
@cloud-architect Create governance standards for SDK contract changes
@cloud-architect Evaluate gRPC vs. REST for inter-provider communication
```

## Core Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    API Layer                                │
│  (FastAPI/REST) - Resource/Provider/Health/Metadata Routes  │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    ┌─────────┐ ┌─────────┐ ┌─────────┐
    │   SDK   │ │ GraphDB │ │  IAM    │
    │(PyPkg) │ │(Metadata)│ │(Keycloak)
    └────┬────┘ └────┬────┘ └────┬────┘
         │           │           │
         └───────────┼───────────┘
                     │
         ┌───────────┴───────────┐
         ▼                       ▼
    ┌──────────────┐      ┌──────────────┐
    │  Resource    │      │  Resource    │
    │  Providers   │      │  Providers   │
    │              │      │              │
    │ • Compute    │      │ • IAM/Sec    │
    │ • Core       │      │ • Storage    │
    │ • Custom     │      │ • Network    │
    └──────────────┘      └──────────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
    ┌──────────────────────────────┐
    │   External Cloud Providers   │
    │  (Azure, AWS, GCP, On-Prem)  │
    └──────────────────────────────┘
```

## Key Competencies

### 1. Architectural Patterns
- Control Plane / Data Plane Separation
- Provider Pattern (Strategy/Adapter)
- Metadata-Driven Architecture
- SDK as Contract Layer

### 2. TOGAF Expertise
- Architecture Vision (Phase A)
- Business Architecture (Phase B)
- Information Architecture (Phase C)
- Technology Architecture (Phase D)
- Migration & Implementation (Phases E-F)

### 3. Technical Principles
- Interface-Based Design
- Separation of Concerns
- Metadata-Driven Operations
- Provider Autonomy
- Security by Design
- Observability
- Testability

### 4. Knowledge Areas
- TOGAF 9.2 framework
- Microservices patterns
- Cloud architecture (multi-cloud, hybrid)
- Python ecosystem (FastAPI, async/await)
- Database design (relational, graph, NoSQL)
- API design (REST, gRPC, OpenAPI)
- Security (OAuth2/OIDC, encryption, compliance)
- DevOps/SRE practices
- Enterprise architecture & governance
- Technology strategy & roadmapping

## When to Use

| Situation | Use This Agent? |
|-----------|-----------------|
| Designing new resource provider | ✅ YES |
| Reviewing provider implementation | ✅ YES |
| Evaluating technology choice | ✅ YES |
| Creating architecture standards | ✅ YES |
| Multi-cloud strategy | ✅ YES |
| Security/compliance review | ✅ YES |
| Performance optimization | ✅ YES |
| Governance framework | ✅ YES |
| Debugging code issues | ❌ NO — Use Developer agent |
| Writing test cases | ❌ NO — Use Testing agent |
| Infrastructure provisioning | ❌ NO — Use DevOps agent |
| Frontend design | ❌ NO — Use Frontend agent |

## ITL Control Plane Stack

**Technology Standards:**
- Language: Python 3.9+
- Framework: FastAPI (async, typed)
- Packaging: Poetry (pyproject.toml)
- Containerization: Docker
- CI/CD: GitHub Actions
- Testing: pytest (unit, integration)
- Code Quality: Type hints (mypy), linting

**Core Components:**
- SDK — Python package, typed models, interface layer
- API — REST interface, request handling, routing
- GraphDB — Metadata storage, relationships, lineage
- IAM Provider — Keycloak integration, OAuth2/OIDC
- Resource Providers — Pluggable, containerized, independently deployable

## Deliverables

The agent provides:

- 🏗️ Architecture diagrams (ADL, UML, C4)
- 📋 Design decisions with rationale (ADR format)
- ✅ Review checklists (governance, security, performance)
- 🔄 Governance frameworks (processes, standards)
- 📊 Trade-off analyses (costs, benefits, risks)
- 🎯 Roadmaps (phases, workstreams, dependencies)
- 📖 Architecture documentation (standards, patterns)

## Version

**1.0.0** - Initial migration from ITL.Agents Cloud Architect custom agent

---

**Authored by**: Niels Weistra  
**Repository**: https://github.com/ITlusions/ITL.Claude.PluginMarketplace  
**License**: MIT
