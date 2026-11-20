#!/usr/bin/env bash
set -euo pipefail

echo "=== Cleanup Script for Progressive Delivery Home Lab ==="

# Delete cluster
kind delete cluster --name progressive-lab || echo "Cluster may not exist"

# Clean up local artifacts
rm -rf tmp/

echo "Cleanup complete!"
