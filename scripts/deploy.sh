#!/usr/bin/env bash
# One-command publish: rewrites the kyryllkezyk-alt placeholder, builds, creates the repo, enables Pages, pushes.
# Requires: git, gh (authenticated: `gh auth login`), python3.
set -euo pipefail

USER_NAME=""; REPO="tech-writing-portfolio"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) USER_NAME="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done
[[ -z "$USER_NAME" ]] && { echo "Usage: $0 --user GITHUB_USERNAME [--repo NAME]"; exit 1; }

cd "$(dirname "$0")/.."

echo "› Rewriting placeholders"
grep -rl --exclude-dir=.git --exclude=deploy.sh "kyryllkezyk-alt\|tech-writing-portfolio" . \
  | xargs sed -i.bak -e "s/kyryllkezyk-alt/${USER_NAME}/g" -e "s/tech-writing-portfolio/${REPO}/g"
find . -name "*.bak" -delete

echo "› Preflight build"
python3 -m pip install -q -r requirements.txt
mkdocs build --strict -q

echo "› Git"
[[ -d .git ]] || git init -q -b main
git add -A
git commit -qm "Publish technical writing portfolio" || true

echo "› GitHub repository"
if ! gh repo view "${USER_NAME}/${REPO}" >/dev/null 2>&1; then
  gh repo create "${USER_NAME}/${REPO}" --public --source . --remote origin \
    --description "Technical writing portfolio: docs-as-code samples, standards and case studies"
fi
git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/${USER_NAME}/${REPO}.git"
git push -u origin main

echo "› GitHub Pages (Actions source)"
gh api -X POST "repos/${USER_NAME}/${REPO}/pages" -f build_type=workflow >/dev/null 2>&1 \
  || gh api -X PUT "repos/${USER_NAME}/${REPO}/pages" -f build_type=workflow >/dev/null

echo "✓ Done. Live in ~2 minutes: https://${USER_NAME}.github.io/${REPO}/"
