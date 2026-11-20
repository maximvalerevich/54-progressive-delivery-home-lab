.PHONY: validate up promote-test rollback-test down

validate:
	@bash scripts/validate.sh

up:
	@echo "Creating KinD cluster progressive-lab..."
	@kind create cluster --config kind-config.yaml --name progressive-lab || echo "Cluster may already exist"
	@kubectl apply -f rollouts/namespace.yaml
	@kubectl apply -f rollouts/services.yaml
	@kubectl apply -f rollouts/rollout.yaml
	@kubectl apply -f rollouts/analysis-template.yaml
	@echo "Waiting for rollout to stabilize..."
	@sleep 10

promote-test:
	@echo "Promoting canary to 100%..."
	@kubectl patch rollout demo-rollout -n progressive-delivery --type='json' -p='[{"op": "replace", "path": "/spec/strategy/canary/steps/-/setWeight", "value": 100}]'
	@sleep 5

rollback-test:
	@echo "Rolling back to stable..."
	@kubectl rollout undo rollout/demo-rollout -n progressive-delivery
	@sleep 5

down:
	@echo "Deleting KinD cluster progressive-lab..."
	@kind delete cluster --name progressive-lab || echo "Cluster may not exist"
