# Shah-Infra GitHub Actions

This repository contains GitHub Actions workflows for deploying infrastructure and Kubernetes resources for the Shah application.

## Workflows

### Deploy Workflow

#### Job: `build-plan`
- **Description**: Initializes Terraform, validates configuration, and creates an execution plan.

#### Job: `apply-k8s`
- **Description**: Deploys Kubernetes resources to the cluster.
- **Dependencies**: Depends on the completion of the `build-plan` job.

### Workflow Overview

The `Deploy` workflow automates the deployment of infrastructure and Kubernetes resources required for the Shah application. The workflow consists of two jobs: `build-plan` for Terraform planning and `apply-k8s` for deploying Kubernetes manifests.

For more details about each job and workflow configurations, refer to the corresponding workflow YAML files in this repository.
