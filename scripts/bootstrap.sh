#!/usr/bin/env bash
set -euo pipefail

echo "=== Bootstrap Script for Progressive Delivery Home Lab ==="

# Create KinD cluster
kind create cluster --config kind-config.yaml --name progressive-lab || echo "Cluster may already exist"

# Install Argo Rollouts
echo "Installing Argo Rollouts controller..."
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml

# Wait for controller to be ready
echo "Waiting for Argo Rollouts controller..."
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=argo-rollouts -n argo-rollouts --timeout=120s

# Apply manifests
kubectl apply -f rollouts/

echo "Bootstrap complete!"
