ARG GOVERSION=1.17
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
ENV GO111MODULE="on" \
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
      python3-pip && \
    curl -s -o /usr/local/bin/kubebuilder -L https://github.com/kubernetes-sigs/kubebuilder/releases/download/v3.4.1/kubebuilder_${GOOS}_${GOARCH} && \
    chmod +x /usr/local/bin/kubebuilder && \
    export PATH=$PATH:/usr/local/bin    && \
    curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    ln -s /usr/local/bin/helm /usr/local/bin/helm3 && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache && \
    pip install yq --upgrade && \
    chmod +x /usr/local/bin/kubectl && \
    rm -rf /var/lib/apt/lists/*

