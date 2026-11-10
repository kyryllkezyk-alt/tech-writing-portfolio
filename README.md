# Technical writing portfolio — Kyryll Kezyk

[![Build & deploy docs](https://github.com/kyryllkezyk-alt/tech-writing-portfolio/actions/workflows/deploy.yml/badge.svg)](https://github.com/kyryllkezyk-alt/tech-writing-portfolio/actions/workflows/deploy.yml)

**Live site → https://kyryllkezyk-alt.github.io/tech-writing-portfolio/**

A working docs-as-code repository, not a folder of PDFs. Every page is version-controlled
Markdown, linted against a style guide on pull request, and published to GitHub Pages on merge to
`main`.

## What's inside

| Path | What it demonstrates |
| --- | --- |
| `docs/samples/` | Tutorial, REST API reference, how-to, concept, release notes, troubleshooting, runbook |
| `docs/standards/` | Style guide, terminology policy, docs-as-code pipeline |
| `docs/case-studies/` | Two documentation problems and their outcomes |

## Toolchain

- **MkDocs + Material** — static site generator, no CMS lock-in
- **GitHub Actions** — `mkdocs build --strict` gates every deploy
- **Vale** — prose linting against Google developer style and a project vocabulary
- **Lychee** — link checking on pull requests

## Run locally

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve          # http://127.0.0.1:8000
mkdocs build --strict # what CI runs
```

## Deploy your own copy

```bash
./scripts/deploy.sh --user YOUR_GITHUB_USERNAME
```

## Contact

Kyryll Kezyk · [mainoffice@k-docs.com](mailto:mainoffice@k-docs.com) · [k-docs.com](https://k-docs.com) · [LinkedIn](https://www.linkedin.com/in/kyryll-kezyk-5a564336)

> The samples describe **Lingua**, a fictional localization platform invented for this portfolio.
> No client-confidential material appears in this repository.
