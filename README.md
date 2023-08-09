# Home Lab CI/CD Workflows

This repository contains the configuration files and scripts that I use to maintain continuous integration and continuous delivery (CI/CD) workflows for the services that run on my home lab's Kubernetes cluster.

## Cluster Overview

My cluster is based on an Intel N100 mini PC with 16GB of RAM and a 256GB SSD. It is currently running Ubuntu 23.04. The node acts as both the master and worker node, and uses MetalLB for load balancing within the local network.

The cluster hosts several services that I use for personal and educational purposes, such as:

- Immich: a self-hosted photo sync tool, similar to Google Photos
- Grafana: a data visualization and monitoring tool
- Prometheus: a metrics collection and alerting system
- Home Assistant: a home automation platform
- Eclipse-Mosquitto: an open-source MQTT broker

and much more.

## CI/CD Tools

To automate the deployment and update of these services, I use two tools:

- ArgoCD: a declarative GitOps tool that syncs the cluster state with the desired state defined in Git repositories
- Renovate by Mend: a dependency update tool that scans the Git repositories for outdated images, Helm charts, or other dependencies, and creates pull requests to update them

The workflow is as follows:

- An image maintainer releases a new image build
- Renovate detects this new build via a more recent tag or image digest, and generates a pull request to update the manifest's image tag to the newer version
- Once the pull request is approved and merged, the temporary branch created for the pull request can be deleted
- ArgoCD picks up the changes to the manifest and automatically triggers an update to the deployed application

## Repository Structure

This repository currently has a single folder called 'manifests' that contains the YAML manifests for each service. The manifests are organized in subfolders according to the namespace they belong to. For example, the 'home-assistant' subfolder has the manifests for the Home Assistant service in the 'automation' namespace.
