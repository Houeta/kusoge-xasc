# Kusoge Infrastructure (kusoge-xasc)

## Overview
Kusoge Infrastructure (kusoge-xasc) is a repository containing Terraform code and Helm chart for managing the infrastructure and deploying the [Kusoge App](https://github.com/Houeta/kusoge-app) in a Kubernetes cluster. This repository follows the GitOps methodology, enabling declarative configuration and automated deployment and management of infrastructure and applications.

## Purpose
The purpose of this project is to provide a scalable and reliable infrastructure for hosting the [Kusoge App](https://github.com/Houeta/kusoge-app) using Kubernetes and Helm. By using Terraform for infrastructure provisioning and Helm for managing Kubernetes applications, this project demonstrates best practices for infrastructure as code (IaC) and application deployment in a cloud-native environment.

## Features
- Terraform modules for provisioning Kubernetes cluster on AWS
- Helm chart for deploying Kusoge App on Kubernetes
- GitOps workflow for automated deployment and management of infrastructure and applications

## Technologies Used
- Terraform
- AWS (Amazon Web Services)
- Kubernetes
- Helm
- ArgoCD (argocd.<your_hostname>)
- Prometheus
- Grafana (grafana.<your_hostname>)
