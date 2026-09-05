# Netflix DevSecOps Disaster Recovery Guide

This document describes the recovery process for the Netflix DevSecOps project.

## Application Source

Repository: https://github.com/Chetanbarfa23/DevSecOps-Netflix

GitHub is the source of truth for application code and GitOps manifests.

## AWS / EC2

The project runs on an Ubuntu AWS EC2 instance hosting Jenkins, Docker, Kind Kubernetes, kubectl, Helm, Argo CD, Prometheus, Grafana, and Metrics Server.

AWS infrastructure can be recreated manually or using the Terraform configuration in the terraform/ directory.

Secrets and SSH private keys are intentionally not stored in this repository.

## Kubernetes

Active Kubernetes configuration is stored in Kubernetes/.

Important resources include deployment.yaml, service.yaml, hpa.yaml, pdb.yaml, and network-policy.yaml.

## Argo CD

Active Argo CD configuration is stored in argocd/application.yaml.

Argo CD watches the GitHub repository and synchronizes the Kubernetes manifests.

## Monitoring

Monitoring configuration is stored in monitoring/ and uses Prometheus and Grafana.

## Secrets

The following must never be committed to Git:
- TMDB API key
- Gmail SMTP App Password
- GitHub Personal Access Token
- Jenkins credentials
- Kubernetes Secret values
- AWS credentials
- SSH private key
- Terraform state

## CI/CD

GitHub → Jenkins → SonarQube → OWASP Dependency-Check → Trivy → Docker → Docker Hub → GitHub GitOps update → Argo CD → Kubernetes

The active Jenkins pipeline is stored in Jenkinsfile.

## Monitoring Flow

Kubernetes → Prometheus → Grafana → Alert Rule → Email Notification

## Recovery Process

1. Recover or create the EC2 instance.
2. Install Docker, kubectl, Kind, and Helm.
3. Recreate the Kubernetes cluster.
4. Install Argo CD and the monitoring stack.
5. Apply the Kubernetes configuration from GitHub.
6. Recreate required secrets securely.
7. Configure Jenkins credentials and tools.
8. Recreate required port-forwards.
9. Verify Kubernetes workloads.
10. Verify Argo CD is Synced and Healthy.
11. Verify Prometheus, Grafana, and email alerting.
