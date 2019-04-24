# Docker Cloud tools container

[![docker-cloud-tools](https://img.shields.io/badge/spy86-cloud_tools-blue.svg)](https://cloud.docker.com/repository/docker/spy86/cloud-tools)

Docker image that contains all necessary tools for doing Cloud Infrastructure Development.

## Tools

- [ ] Ansible
- [ ] Ansible Tower CLI
- [ ] Openshift CLI
- [ ] Terraform
- [ ] kubectl
- [ ] Kubernetes Tools
- [ ] kops (Kubernetes Operations)
- [ ] AWS CLI
- [ ] GCP CLI
- [ ] Azure CLI

## Usage

#### Basic running

`docker run -ti spy86/cloud-tools bash`

#### Run with mount storage

`docker run -v ~/:/root /project/path:/workspace -ti spy86/cloud-tools /bin/bash`

#### Example command

`docker run spy86/cloud-tools "gcloud compute instances list"`
