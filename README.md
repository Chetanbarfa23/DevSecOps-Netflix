# Netflix DevSecOps Platform

A production-style DevSecOps implementation for a Netflix Clone application, built with automated CI/CD, security scanning, containerization, Kubernetes, GitOps, infrastructure configuration, monitoring, and alerting.

## About the Project

The Netflix Clone application is based on the open-source `N4si/DevSecOps-Project` as the application starting point.

The DevSecOps infrastructure, CI/CD workflow, containerization, Kubernetes deployment, GitOps integration, monitoring, alerting, recovery configuration, and related improvements in this repository were implemented as part of this project.

## DevSecOps Architecture

![Netflix DevSecOps Project Architecture](docs/screenshots/devsecops-project-overview.png)

The diagram presents the complete DevSecOps workflow implemented in this project, from source code and automated CI/CD security validation to containerization, GitOps-based Kubernetes deployment, and continuous monitoring with Prometheus and Grafana.

## Project Evidence & Screenshots

The following screenshots demonstrate the major components and security stages of the DevSecOps implementation.

### Application

![Netflix Application](docs/screenshots/netflix-app.jpeg)

### GitHub Repository

![GitHub Repository](docs/screenshots/github.png)

### Jenkins CI/CD Pipeline

![Jenkins Pipeline](docs/screenshots/jenkins-pipeline.png)

### SonarQube Code Quality & Security

![SonarQube](docs/screenshots/sonarqube.png)

### OWASP Dependency-Check

![OWASP Dependency-Check](docs/screenshots/owasp-dependency-check.png)

### Trivy Security Scan

![Trivy Scan](docs/screenshots/trivy-scan.png)

### Argo CD GitOps Deployment

![Argo CD](docs/screenshots/argocd.png)

### Grafana Monitoring Dashboard

![Grafana Dashboard](docs/screenshots/grafana-dashboard.png)

### Prometheus Target Monitoring

![Prometheus Targets](docs/screenshots/prometheus-targets.png)
