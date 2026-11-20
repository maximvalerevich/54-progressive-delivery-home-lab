#!/usr/bin/env bash
set -euo pipefail

echo "=== Validation Script for Progressive Delivery Home Lab ==="
echo ""

# Check required files exist
echo "[*] Checking required files..."
REQUIRED_FILES=(
  "kind-config.yaml"
  "rollouts/namespace.yaml"
  "rollouts/services.yaml"
  "rollouts/analysis-template.yaml"
  "rollouts/rollout.yaml"
  "Makefile"
  "scripts/validate.sh"
  "scripts/bootstrap.sh"
  "scripts/cleanup.sh"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    echo "  ✓ $f exists"
  else
    echo "  ✗ $f MISSING"
    exit 1
  fi
done
echo ""

# Validate YAML syntax
echo "[*] Validating YAML syntax..."
for f in rollouts/*.yaml kind-config.yaml; do
  if python -c "
import yaml
with open('$f') as fp:
    list(yaml.safe_load_all(fp))
" 2>/dev/null; then
    echo "  ✓ $f is valid YAML"
  else
    echo "  ✗ $f has invalid YAML"
    exit 1
  fi
done
echo ""

# Validate shell scripts
echo "[*] Validating shell scripts..."
for f in scripts/*.sh; do
  if bash -n "$f"; then
    echo "  ✓ $f is valid bash"
  else
    echo "  ✗ $f has syntax errors"
    exit 1
  fi
done
echo ""

echo "=== All validations passed! ==="
