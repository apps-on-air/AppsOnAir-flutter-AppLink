#!/bin/sh
# Run once after cloning to activate the shared Git hooks.
#
# Usage:
#   sh scripts/setup-hooks.sh

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

git config core.hooksPath .githooks
chmod +x "$REPO_ROOT/.githooks/pre-commit"
chmod +x "$REPO_ROOT/.githooks/pre-push"

echo "✓ Git hooks configured."
echo "  pre-commit — doc/changelog sync check"
echo "  pre-push   — format, analyze, test, pub dry-run"
