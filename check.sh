#!/bin/bash

echo -e "List all tools\n"

echo "Versions:"
sleep 0.5
# python
python --version | head -1
# Ansible
ansible --version | head -1
# Ansible Tower CLI
tower-cli --version | head -1
# Openshift CLI
oc version | head -1
# Teeraform
terraform --version | head -1
# Kops - Kubernetes Operations
echo -n "kops: " && kops version | head -1 | cut -d' ' -f2
# kubectl
echo -n "kubectl: " && kubectl version --short=true 2>/dev/null | head -1 | cut -d' ' -f3
# Kubernetes Tools
ktools | head -1
# AWS CLI
pip list 2>/dev/null|grep awscli
# GCP Cloud SDK
echo -n "gcloud: " && gcloud --version |head -1 | cut -d' ' -f4
# MS Azure CLI
az --version | head -1
