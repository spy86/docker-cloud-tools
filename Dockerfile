FROM ubuntu:noble

ARG KUBECTL_VERSION=v1.29.0
ARG KTOOLS_VERSION=2.1.0
ARG TERRAFORM_VERSION=1.6.6
ARG OPENSHIFT_VERSION=v3.11.0-0cbc58b

RUN apt-get update -y \
    && apt-get install wget vim curl git telnet zip unzip python3-pip lsb-release lsb-base -y

# Kops - Kubernetes Operations
RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
    && chmod +x kops-linux-amd64 \
    && mv kops-linux-amd64 /usr/local/bin/kops

# Ansible
RUN apt-get install ansible -y

# Ansible tower cli tool
RUN pip3 install --user https://releases.ansible.com/ansible-tower/cli/ansible-tower-cli-latest.tar.gz --break-system-packages

# Openshift cli
RUN export OPENSHIFT_VERSION_NUMBER=$(echo $OPENSHIFT_VERSION | cut -d'-' -f1) \
    && curl -sSL https://github.com/openshift/origin/releases/download/${OPENSHIFT_VERSION_NUMBER}/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit.tar.gz -o /tmp/oc.tar.gz \
    && tar -zxvf /tmp/oc.tar.gz --directory /tmp/ \
    && cd /tmp/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit \
    && mv oc /usr/sbin/

# Kubectl
RUN curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Terraform
RUN curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o ./terraform.zip \
    && unzip ./terraform.zip -d /usr/local/bin/ \
    && rm ./terraform.zip

# Kubernetes tools
RUN curl -sSL https://github.com/shawnsw/kubernetes-tools/archive/refs/tags/v${KTOOLS_VERSION}.zip -o ./ktools.zip \
    && unzip ./ktools.zip -d /tmp/ \
    && mv /tmp/kubernetes-tools-${KTOOLS_VERSION}/bin/* /usr/local/bin/ \
    && mv /tmp/kubernetes-tools-${KTOOLS_VERSION}/completion/__completion /usr/local/bin/__completion \
    && rm -rf /tmp/kubernetes-tools* \
    && rm -rf ./ktools.zip

# awscli tool
RUN pip install awscli --break-system-packages

# GCP SDK
RUN curl -sSL https://sdk.cloud.google.com | bash

# Azure cli tool
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD check.sh /check.sh
RUN chmod 755 /check.sh
ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "/check.sh" ]
