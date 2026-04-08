# DevSecOps Maintenance Guide

This document describes the ongoing security and maintenance practices for keeping this project secure, up to date, and production-ready. It serves as both operational documentation and a reference for DevSecOps best practices.

## Automated Dependency Management

### Dependabot

Dependabot is configured to monitor three ecosystems weekly:

| Ecosystem | What It Monitors | Config |
|-----------|-----------------|--------|
| **npm** | Astro, Tailwind, and all site dependencies | `site/package.json` |
| **Terraform** | AWS provider and other Terraform providers | `infra/` |
| **GitHub Actions** | Action versions pinned by SHA | `.github/workflows/` |

**Review cadence:** Dependabot PRs should be reviewed weekly (Monday).

**Process for Dependabot PRs:**
1. Review the changelog/diff for breaking changes
2. CI runs automatically (lint, scan, build) — verify it passes
3. For minor/patch updates: merge if CI passes and changelog looks safe
4. For major updates: test locally before merging, check for migration guides
5. If a PR introduces a vulnerability fix, prioritize merging within 24 hours

### npm Audit

`npm audit` runs as part of the CI pipeline via Trivy's filesystem scan. The policy:

| Severity | Action | SLA |
|----------|--------|-----|
| **Critical** | Fix immediately — block deployment | Same day |
| **High** | Fix within 1 week | 7 days |
| **Moderate** | Fix at next dependency update cycle | 30 days |
| **Low** | Track, fix opportunistically | Next quarter |

## Security Scanning

### Trivy (IaC + Dependencies)

Trivy runs on every push and PR, scanning two targets:

1. **IaC scan** (`infra/`) — detects Terraform misconfigurations (e.g., public S3 buckets, missing encryption, overly permissive IAM)
2. **Filesystem scan** (`site/`) — detects known CVEs in npm dependencies

**Configuration:**
- Pinned to a specific version to avoid supply-chain risk from auto-updates
- Fails the pipeline on `CRITICAL` and `HIGH` findings
- Trivy's vulnerability database updates automatically at scan time

**When Trivy itself has a vulnerability:**
- Monitor Trivy's own releases and security advisories
- Update the pinned version in `.github/workflows/ci.yml` promptly
- Dependabot will also flag this via the `github-actions` ecosystem

### gitleaks (Secrets Detection)

Secrets scanning runs at two layers:

1. **Pre-commit hook** — catches secrets before they enter git history
2. **CI job** — scans the full commit history as a safety net

**When a finding triggers:**
1. If a real secret was committed: rotate the credential immediately, then remove it from history
2. If it's a false positive: add the pattern to `.gitleaks.toml` allowlist with a comment explaining why

### GitHub Native Security

Once the repo is public, enable these GitHub features:

- **Secret scanning** — detects tokens from known providers (AWS, GitHub, etc.)
- **Secret scanning push protection** — blocks pushes containing detected secrets
- **Dependabot security alerts** — notifies on vulnerable dependencies

## Supply Chain Security

### GitHub Actions Pinning

All GitHub Actions are pinned to **full commit SHA**, not tags:

```yaml
# Good — immutable reference
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

# Bad — tag can be moved to point at different code
- uses: actions/checkout@v4
```

**How to update:** When Dependabot proposes an action update, verify the new SHA matches the official release, then merge.

### npm Lockfile

- `package-lock.json` is committed and CI uses `npm ci` (not `npm install`) for reproducible builds
- This ensures the exact same dependency tree in CI as in local development

### Terraform Lockfile

- `.terraform.lock.hcl` should be committed when generated
- It pins provider versions and their checksums for reproducible infrastructure

## Review Cadence

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Review Dependabot PRs | Weekly (Monday) | Developer |
| Check Trivy scan results | Every PR/push (automated) | CI |
| Review gitleaks findings | Every PR/push (automated) | CI |
| Full manual security audit | Quarterly | Developer |
| Update Trivy pinned version | When new release available | Developer |
| Review GitHub security alerts | Weekly | Developer |
| Rotate AWS credentials | Quarterly (until OIDC migration) | Developer |

## Incident Response

### If a vulnerability is found in a deployed dependency:

1. **Assess impact** — is this dependency used in the build output, or only at build time?
   - Static site: most npm vulnerabilities are build-time only and don't affect the deployed HTML/CSS/JS
   - Terraform providers: vulnerabilities may affect infrastructure state
2. **Patch** — update the dependency via Dependabot PR or manual `npm audit fix`
3. **Rebuild and deploy** — push to `main` for auto-deploy to dev, then promote to prod
4. **Verify** — check that Trivy scan passes on the updated version

### If a secret is accidentally committed:

1. **Rotate the credential immediately** — don't wait to clean git history first
2. **Remove from history** — use `git filter-repo` or start a fresh repo
3. **Audit access** — check CloudTrail (AWS) for any unauthorized usage
4. **Post-mortem** — verify pre-commit hooks are installed and working

## Future Improvements

- [ ] Migrate to **OIDC federation** to eliminate long-lived AWS keys entirely
- [ ] Add **SBOM generation** (Software Bill of Materials) to CI pipeline
- [ ] Add **scheduled Trivy scans** (weekly cron) to catch newly disclosed CVEs between pushes
- [ ] Add **uptime monitoring** with automated alerting
