# Home Lab
## Purpose
This repository contains the configuration files and scripts used to maintain the continuous integration and continuous delivery (CI/CD) workflows for services running on my multi-node Kubernetes cluster, hosted across three physical nodes on Proxmox.\
A separate private repository is used to store and manage highly sensitive data that requires additional security beyond what's publicly available in this repository.

## Cluster Overview
The cluster runs on three physical nodes, each hosting VMs for both master and worker roles:

HP Prodesk 400 G2 Mini (Intel i5 6500T)\
Dell OptiPlex 3050 Micro (Intel i3 7100T)\
Beelink S12 Mini (Intel N100)

The master VMs have minimal resources allocated, while the majority of resources are dedicated to the worker/agent VMs to handle service workloads. \
The cluster utilizes Longhorn for persistent pod storage. \
Proxmox Backup Server is used for regular VM backups, ensuring redundancy and quick recovery.

Key components of the cluster include:

MetalLB for internal load balancing\
Authentik for centralized authentication\
ArgoCD for GitOps-driven service deployment\
Renovate by Mend for automating dependency updates\
SealedSecrets for secure handling of sensitive configuration data\
Regular Longhorn backups are stored on a NAS, providing a robust backup strategy in combination with Proxmox VM backups.

The current set of deployed services includes:

cert-manager: Manages TLS certificates for Kubernetes services automatically.\
changedetection: Monitors websites for content changes and sends notifications.\
code-server: Web-based Visual Studio Code for remote development.\
docker-wyze-bridge: Streams Wyze camera feeds using RTSP from Docker.\
home-assistant: Home automation platform integrating various devices and services.\
kube-vip: Provides a virtual IP for highly available Kubernetes clusters.\
mariadb: Open-source relational database for storing structured data.\
mosquitto: Lightweight MQTT broker for IoT device communication.\
nextcloud: Self-hosted cloud storage and collaboration platform.\
omada-controller: Manages TP-Link Omada network devices centrally.\
uptime-kuma: Self-hosted monitoring service to track uptime of websites and services.\
vaultwarden: Lightweight, self-hosted password manager using Bitwarden APIs.

## Repository Structure
The manifests folder contains YAML manifests for each service. For example, the 'home-assistant' subfolder houses the manifests for the Home Assistant service.\
The argocd-manifests folder includes deployment parameters for adding these services to ArgoCD, which manages the synchronization of the Kubernetes cluster's desired state.

## CI/CD Tools
The deployment and update of services are automated using two key tools:

ArgoCD: A GitOps tool that ensures the cluster's state matches the desired state stored in Git.\
Renovate by Mend: A tool that detects outdated dependencies (such as images or Helm charts) and automatically generates pull requests for updates.

## Onboarding
Services are onboarded through the manifests in the argocd-manifests folder. \
Once applied, ArgoCD begins managing the associated services automatically.

## Updates
The update process follows this workflow:

Renovate detects new versions of images or dependencies.\
A pull request is created to update the manifest.\
Upon approval and merging, ArgoCD triggers automatic updates to the corresponding applications.

## Secrets
Secrets are handled using SealedSecrets, allowing sensitive information to be encrypted and safely committed to the repository. \
Decryption is only possible by the SealedSecrets controller running in the cluster.

## Backups
The cluster stores Longhorn data on a separate virtual disk from the OS, which is excluded from Proxmox Backup Server backups. \
Similarly, containerd folders on the worker nodes are kept on dedicated virtual disks and are not backed up, as they primarily contain ephemeral data. \
These separate virtual disks for Longhorn and containerd allow for scalable disk space without increasing the OS backup size. \
Longhorn backs up to a NAS weekly, while OS backups occur daily.
