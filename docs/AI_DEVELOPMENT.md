# AI-Assisted Development

This document describes how AI tools were used throughout the planning, development, and review of this project. The goal is transparency — showing both where AI accelerated the work and where human judgment was essential.

## Tools Used

| Tool | How It Was Used |
|------|----------------|
| **GitHub Copilot (Chat)** | Architecture planning, code generation, security review, documentation |

## Where AI Was Used

### 1. Planning & Architecture Decisions

AI pair programming was used extensively in the planning phase:

- Evaluated technology choices (Astro vs. Hugo vs. Next.js, Tailwind vs. vanilla CSS)
- Assessed whether Atmos was appropriate for this project's scale (decided against it)
- Defined the branching strategy (trunk-based development)
- Created the implementation phase plan with priorities
- Recommended the security playbook for making the repo public

**Human judgment applied:** All technology decisions were made by the developer based on professional experience. AI provided analysis and trade-offs, but the final choices reflected real-world requirements and career positioning goals.

### 2. Frontend Development

- Scaffolded the Astro project structure and Tailwind configuration
- Generated the base layout with dark mode toggle
- Built responsive page sections (hero, skills, projects, pipeline, architecture, AI, resume)

**Human judgment applied:** Content, branding, design direction, and which sections to include were all human decisions. AI generated the implementation of those decisions.

### 3. Infrastructure as Code

- Refactored legacy Terraform (copy-pasted `dev/` and `prod/` folders) into a modular structure
- Upgraded from deprecated AWS provider patterns (OAI → OAC, inline policies → dedicated resources)
- Created the Terraform Cloud backend configuration

**Human judgment applied:** The module boundaries, environment strategy, and decision to skip DynamoDB locking were informed by the developer's professional assessment of the project's scale.

### 4. CI/CD Pipeline

- Created GitHub Actions workflows (CI, deploy, IaC)
- Recommended pinning actions to full SHA for supply chain security
- Designed the multi-environment deployment strategy with approval gates

**Human judgment applied:** The developer chose to use long-lived AWS keys for MVP (with OIDC as a follow-up), based on practical deployment timeline considerations.

### 5. Security Review

- Identified the hardcoded AWS account ID in the legacy CircleCI config
- Recommended creating a fresh public repo to avoid exposing git history
- Designed the pre-commit hooks and CI scanning configuration
- Created the DevSecOps maintenance guide

**Human judgment applied:** Risk assessment and prioritization of security items were driven by the developer's operational security experience.

### 6. Documentation

- Generated initial drafts of README.md, ARCHITECTURE.md, and MAINTENANCE.md
- Created Mermaid diagrams for architecture visualization
- Wrote ADR templates

**Human judgment applied:** All documentation was reviewed, edited, and refined by the developer before committing.

## What AI Did NOT Do

- **No autonomous deployments** — all infrastructure changes require human review and approval
- **No security decisions made in isolation** — AI recommended, human decided
- **No blind code acceptance** — all generated code was reviewed for correctness, security, and alignment with project goals
- **No credential handling** — AI never had access to AWS keys, secrets, or production systems

## Lessons Learned

1. **AI excels at scaffolding** — generating boilerplate, config files, and standard patterns saves significant time
2. **AI is useful for security auditing** — it caught the exposed account ID that might have been overlooked in a manual review
3. **AI needs guardrails** — without clear requirements, it tends to over-engineer (e.g., suggesting Terragrunt, CDKTF, and blog features that weren't needed)
4. **Planning conversations are high-value** — using AI to debate trade-offs before writing code prevents rework
5. **Always review generated IaC** — infrastructure code has real cost and security implications that require human validation
