ARG GOVERSION=1.20
FROM golang:$GOVERSION
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION
ARG USER_EMAIL="david.alexandre@w6d.io"
ARG USER_NAME="David ALEXANDRE"
LABEL maintainer="${USER_NAME} <${USER_EMAIL}>" \
        org.label-schema.vcs-url="https://github.com/w6d-io/kubebuilder" \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.version=$VERSION
ENV K8S_VERSION=1.27.1 \
    GO111MODULE="on" \
    GOOS=linux \
    GOARCH=amd64
RUN apt update && \
    apt install -y -u \
      ca-certificates \
      openssl \
      bash \
      gettext \
      git \
      curl \
      make \
      jq \
      coreutils \
      gawk \
      python3 \
      python3-pip
RUN curl -sSLo envtest-bins.tar.gz "https://go.kubebuilder.io/test-tools/${K8S_VERSION}/$(go env GOOS)/$(go env GOARCH)" && \
    mkdir /usr/local/kubebuilder && \
    tar -C /usr/local/kubebuilder --strip-components=1 -zvxf envtest-bins.tar.gz

RUN export PATH=$PATH:/usr/local/kubebuilder/bin
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
RUN ln -s /usr/local/bin/helm /usr/local/bin/helm3
RUN pip install --upgrade pip setuptools --break-system-packages
RUN if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/yq && \
    rm -rf /var/lib/apt/lists/*

