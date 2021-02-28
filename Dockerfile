ARG GOVERSION=1.15.5
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
      python3-pip
RUN curl -L https://go.kubebuilder.io/dl/2.3.1/${GOOS}/${GOARCH} | tar -xz -C /tmp/
RUN mv /tmp/kubebuilder_2.3.1_${GOOS}_${GOARCH} /usr/local/kubebuilder
RUN export PATH=$PATH:/usr/local/kubebuilder/bin
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN ln -s /usr/local/bin/helm /usr/local/bin/helm3
RUN rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache
RUN pip install yq --upgrade
RUN chmod +x /usr/local/bin/kubectl \
 && rm -rf /var/lib/apt/lists/*

