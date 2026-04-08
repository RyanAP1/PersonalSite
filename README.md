# Repository Moved

This repository has been replaced by the active project repository:

https://github.com/RyanAP1/PortfolioSite

Use that repository for the current source, infrastructure, CI/CD workflows, and ongoing updates.

This repository is retained only so older links from resumes, messages, or bookmarks do not break.
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
