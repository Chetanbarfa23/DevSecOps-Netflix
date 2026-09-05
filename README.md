# Netflix DevSecOps Platform

A production-style DevSecOps implementation for a Netflix Clone application, built with automated CI/CD, security scanning, containerization, Kubernetes, GitOps, infrastructure configuration, monitoring, and alerting.

## About the Project

The Netflix Clone application is based on the open-source `N4si/DevSecOps-Project` as the application starting point.

The DevSecOps infrastructure, CI/CD workflow, containerization, Kubernetes deployment, GitOps integration, monitoring, alerting, recovery configuration, and related improvements in this repository were implemented as part of this project.

## DevSecOps Architecture

```text
Developer
    |
    v
GitHub
    |
    v
Jenkins CI/CD
    |
    +----> SonarQube
    |        |
    |        v
    |    Code Quality
    |
    +----> OWASP Dependency-Check
    |        |
    |        v
    |    Dependency Security
    |
    +----> Docker Build
             |
             v
        Trivy Image Scan
             |
             v
        Docker Hub
             |
             v
      GitOps Manifest Update
             |
             v
          GitHub
             |
             v
          Argo CD
             |
             v
      Kubernetes / Kind
             |
       +-----+------+
       |            |
       v            v
   Netflix App     HPA
       |
       v
 Prometheus
       |
       v
   Grafana
       |
       v
   Alerting
