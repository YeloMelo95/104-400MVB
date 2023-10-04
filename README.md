# Home Lab

## Purpose

This repository contains the configuration files and scripts that I use to maintain continuous integration and continuous delivery (CI/CD) workflows for the services that run on my home lab's Kubernetes cluster.

## Cluster Overview

My cluster is based on an Intel N100 mini PC with 16GB of RAM and a 256GB NVMe drive. It is currently running Ubuntu 23.04. The node acts as both the master and worker node, and uses MetalLB for load balancing within the local network.

The cluster hosts several services that I use for personal and educational purposes, such as:

- Paperless: a tool which automatically creates local copies of documents received via email
- Keycloak: an authentication layer to secure applications and pass credentials to certain applications
- FGC: a tool leveraged to claim free video games from services such as Epic or Amazon Gaming
- Home Assistant: a home automation platform used to integrate various services and devices together
- Eclipse-Mosquitto: an open-source MQTT broker used to provide device information at minimal bandwidth cost

and much more.

## Repository Structure

The 'manifests' folder contains the YAML manifests for each service. The manifests are organized in subfolders according to the namespace they belong to. For example, the 'home-assistant' subfolder has the manifests for the Home Assistant service in the 'automation' namespace.

There is also an 'argocd-manifests' folder, which contains the deployment parameters to add these services directly into ArgoCD for management.

## CI/CD Tools

To automate the deployment and update of these services, I use two tools:

- ArgoCD: a declarative GitOps tool that syncs the cluster state with the desired state defined in Git repositories
- Renovate by Mend: a dependency update tool that scans the Git repositories for outdated images, Helm charts, or other dependencies, and creates pull requests to update them

### Onboarding
The onboarding of the services is done via the manifests found in the 'argocd-manifests' folder. Once those have been applied, ArgoCD will automatically locate the application manifests stored in this repository and begin managing them per the parameters set in the manifest file.

### Updates
The update workflow is as follows:

- An image maintainer releases a new image build
- Renovate detects this new build via a more recent tag or image digest, and generates a pull request to update the manifest's image tag to the newer version
- Once the pull request is approved and merged, the temporary branch created for the pull request can be deleted
- ArgoCD picks up the changes to the manifest and automatically triggers an update to the deployed application

## Secrets

Secrets are stored as "SealedSecrets" using Bitnami's SealedSecrets controller, and can be found in the application manifests. By leveraging this controller, the secret manifest can be publicly displayed, as the secret can only be decrypted by the controller.
