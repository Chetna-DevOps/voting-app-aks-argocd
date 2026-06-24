# Voting App — AKS + ArgoCD

A microservices voting application deployed on Azure Kubernetes Service using a GitOps-based CI/CD pipeline.

## Credits

Base application sourced from [dockersamples/example-voting-app](https://github.com/dockersamples/example-voting-app).

## Tech Stack

- **Vote frontend** — Python (Flask) — lets users vote between two options
- **Result frontend** — Node.js — shows live voting results
- **Worker** — C# (.NET) — consumes votes from Redis and stores in PostgreSQL
- **Redis** — collects incoming votes
- **Database** — PostgreSQL
- **CI** — Azure DevOps Pipelines
- **CD** — ArgoCD (GitOps)
- **Registry** — Azure Container Registry (ACR)
- **Ingress** — NGINX on AKS

## CI/CD Flow

1. Code push triggers an Azure DevOps pipeline
2. Pipeline builds and pushes the Docker image to ACR
3. Pipeline updates the image tag in `k8s-specifications/` and commits it back to the repo
4. ArgoCD detects the change and auto-syncs the cluster

## Project Structure

```
├── vote/                    
├── result/                    
├── worker/                  
├── k8s-specifications/      
├── scripts/
│   └── updateK8sManifests.sh
├── azure-pipelines-vote.yml
├── azure-pipelines-result.yml
└── azure-pipelines-worker.yml
```

## Setup

- Create a variable group `ci-cd-variables` in Azure DevOps with: `pat_token`, `acr_login_server`, `azure_devops_org_url`, `azure_repo_name`, `git_email`, `git_name`, `dockerRegistryServiceConnection`
- Create ACR pull secret in the cluster: kubectl create secret docker-registry acr-secret ...  
- Update `<YOUR-CLUSTER-IP>` in `k8s-specifications/ingress.yaml` and `<ACR_LOGIN_SERVER>` in `vote-deployment.yaml, result-deployment.yaml & worker-deployment.yaml ` 
- Point ArgoCD to this repo with path `k8s-specifications`, auto-sync enabled

## What I did

- Set up Azure DevOps CI pipelines for all three services (vote, result, worker)
- Pushed images to Azure Container Registry (ACR)
- Configured ArgoCD on AKS for GitOps-based auto-deployment
- Wrote the manifest update script to automate image tag changes post-build
- Configured NGINX ingress for hostname-based routing using nip.io
- Secured credentials via Azure DevOps variable groups

## ArgoCD UI

![ArgoCD UI](screenshots/argocd-ui-1.png)

![ArgoCD UI](screenshots/argocd-ui-2.png)

![ArgoCD UI](screenshots/argocd-ui-3.png)

## Azure DevOps Pipelines

![vote pipeline](screenshots/pipeline-vote.png)

![result pipeline](screenshots/pipeline-result.png)

![worker pipeline](screenshots/pipeline-worker.png)

## ACR Images

![vote repo](screenshots/repo-vote.png)

![result repo](screenshots/repo-result.png)

![worker repo](screenshots/repo-worker.png)

## Running Applications

![voting page](screenshots/voting_page.png)

![result page](screenshots/result_page.png)

## Cluster Health

![Cluster Health](screenshots/cluster_health.png)
