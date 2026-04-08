# Personal Portfolio Site

[![CI](https://github.com/RyanAP1/PortfolioSite/actions/workflows/ci.yml/badge.svg)](https://github.com/RyanAP1/PortfolioSite/actions/workflows/ci.yml)
[![Deploy](https://github.com/RyanAP1/PortfolioSite/actions/workflows/deploy.yml/badge.svg)](https://github.com/RyanAP1/PortfolioSite/actions/workflows/deploy.yml)
[![Infrastructure](https://github.com/RyanAP1/PortfolioSite/actions/workflows/iac.yml/badge.svg)](https://github.com/RyanAP1/PortfolioSite/actions/workflows/iac.yml)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

A modern portfolio site showcasing DevOps/SRE best practices — fully automated infrastructure, CI/CD pipelines, security scanning, and AI-assisted development.

**Live:** [ryanaparedes.com](https://ryanaparedes.com)

---

## Architecture

```
┌────────────┐     ┌──────────────┐     ┌────────────┐
│  Route 53  │────▶│  CloudFront  │────▶│  S3 Bucket │
│  (DNS)     │     │  (CDN+TLS)   │     │  (Static)  │
└────────────┘     └──────────────┘     └────────────┘
                          │
                   ┌──────────────┐
                   │     ACM      │
                   │  (TLS Cert)  │
                   └──────────────┘
```

All infrastructure is defined as modular Terraform — see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed diagrams.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | [Astro](https://astro.build) + [Tailwind CSS](https://tailwindcss.com) |
| **Hosting** | AWS S3 + CloudFront + Route53 + ACM |
| **IaC** | Terraform (~> 5.0 AWS provider, modular) + [Terraform Cloud](https://app.terraform.io) |
| **CI/CD** | GitHub Actions (lint → scan → build → deploy) |
| **Security** | Trivy (IaC + deps), gitleaks (secrets), Dependabot |
| **AI** | GitHub Copilot — see [AI_DEVELOPMENT.md](docs/AI_DEVELOPMENT.md) |

## Pipeline

Every change flows through this pipeline:

```
Push/PR → Lint → Trivy Scan → Build → Deploy Dev (auto) → Deploy Prod (approval)
```

- **Lint** — `astro check` for types, `terraform validate` for IaC
- **Scan** — security scanning at multiple layers (see below)
- **Build** — Astro generates optimized static HTML
- **Deploy** — S3 sync with CloudFront cache invalidation on prod

### Security Scanning

| Tool | What It Does | Why It Matters |
|------|-------------|----------------|
| [**Trivy**](https://trivy.dev) (IaC) | Scans Terraform files for misconfigurations (open security groups, missing encryption, overly permissive IAM) | Catches infrastructure security gaps before they reach AWS — shift-left for cloud security |
| [**Trivy**](https://trivy.dev) (Dependencies) | Scans `package-lock.json` for known CVEs in npm packages | Prevents deploying code that depends on libraries with published vulnerabilities |
| [**gitleaks**](https://github.com/gitleaks/gitleaks) | Scans code and git history for hardcoded secrets (AWS keys, API tokens, passwords) | Prevents accidental credential exposure — runs as both a pre-commit hook and in CI |
| [**Dependabot**](https://docs.github.com/en/code-security/dependabot) | Monitors npm, Terraform providers, and GitHub Actions for outdated or vulnerable versions | Automates dependency updates with PRs — keeps the supply chain current without manual tracking |
| **GitHub Actions pinning** | All actions are referenced by full SHA instead of mutable tags | Prevents supply-chain attacks where a compromised action tag could inject malicious code |

See [docs/MAINTENANCE.md](docs/MAINTENANCE.md) for the ongoing security and dependency management practices.

## Quick Start

### Prerequisites

- Node.js 22+
- [Task](https://taskfile.dev) (optional, for convenience commands)

### Local Development

```bash
# Install dependencies
cd site && npm ci

# Start dev server (http://localhost:4321)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Using Taskfile

```bash
task dev        # Start dev server
task build      # Production build
task lint       # Run all linters
task scan       # Run Trivy scan
```

### Terraform

State is managed by Terraform Cloud (org `RyanAPLearning`). You'll need a [TFC API token](https://app.terraform.io/app/settings/tokens) configured locally via `terraform login`.

Variables (`domain_name`, `environment`) are set per-workspace in the TFC UI — no local var files needed for remote execution.

```bash
cd infra

# Initialize (selects workspace via TF_WORKSPACE)
export TF_WORKSPACE=PersonalSite-dev    # PowerShell: $env:TF_WORKSPACE = "PersonalSite-dev"
terraform init

# Plan (runs remotely on TFC)
terraform plan

# Apply
terraform apply
```

## Project Structure

```
├── .github/workflows/    # CI, deploy, and IaC workflows
├── infra/                # Terraform modules (storage, cdn, dns)
│   ├── modules/
│   └── environments/     # Per-env tfvars files
├── site/                 # Astro project
│   ├── src/pages/
│   ├── src/layouts/
│   └── public/
├── docs/                 # Architecture, AI development, maintenance
└── Taskfile.yml          # Local dev commands
```

## Documentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — Infrastructure diagrams and design decisions
- [AI_DEVELOPMENT.md](docs/AI_DEVELOPMENT.md) — How AI tools were used to build this project
- [MAINTENANCE.md](docs/MAINTENANCE.md) — DevSecOps practices for keeping the project secure

## License

[MIT](LICENSE)
