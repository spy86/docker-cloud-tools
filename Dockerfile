FROM debian:stretch

LABEL maintainer="maciej.michalsk@gmail.com"

ARG KUBECTL_VERSION=v1.13.2
ARG KTOOLS_VERSION=1.2.0
ARG TERRAFORM_VERSION=0.11.11
ARG KOPS_VERSION=1.11.0
ARG OPENSHIFT_VERSION=v3.11.0-0cbc58b

RUN apt-get update -y \
    && apt-get install wget vim curl git telnet zip unzip python-pip lsb-release lsb-base -y

# Ansible
RUN apt-get install ansible -y

# Ansible tower cli tool
RUN pip install ansible-tower-cli

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
RUN curl -sSL https://codeload.github.com/shawnxlw/kubernetes-tools/zip/v${KTOOLS_VERSION} -o ktools.zip \
    && unzip ktools.zip && mv kubernetes-tools-${KTOOLS_VERSION}/bin/* /usr/local/bin/ && mv kubernetes-tools-${KTOOLS_VERSION}/completion/__completion /usr/local/bin/__completion && rm -rf kubernetes-tools*

# Kops - Kubernetes Operations
RUN wget --no-check-certificate https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 -o /usr/local/bin/kops \
    && chmod +x /usr/local/bin/kops

# awscli tool
RUN /usr/bin/pip install awscli

# GCP SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    wget -q -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# Azure cli tool
RUN apt-get install apt-transport-https lsb-release software-properties-common dirmngr -y && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv --keyserver packages.microsoft.com --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF && \
    apt-get update && \
    apt-get install azure-cli
