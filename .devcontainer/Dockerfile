# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USE_MOBY="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG KUBECTL_VERSION="1.23.3"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && /bin/bash /tmp/library-scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    && /bin/bash /tmp/library-scripts/kubectl-helm-debian.sh ${KUBECTL_VERSION} "latest" "none" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Script copies localhost's ~/.kube/config file into the container and swaps out 
# localhost for host.docker.internal on bash/zsh start to keep them in sync.
COPY copy-kube-config.sh /usr/local/share/
RUN chown ${USERNAME}:root /usr/local/share/copy-kube-config.sh \
    && echo "source /usr/local/share/copy-kube-config.sh" | tee -a /root/.bashrc /root/.zshrc /home/${USERNAME}/.bashrc >> /home/${USERNAME}/.zshrc

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

ARG INSTALL_DIR=/usr/local/bin
# install flux-vscode, also configured for install in devcontainer.json
ARG FLUXV="0.19.0"
RUN wget https://github.com/weaveworks/vscode-gitops-tools/releases/download/v${FLUXV}/vscode-gitops-tools-${FLUXV}.vsix -O /var/lib/vscode-gitops-tools.vsix
    # && code --install-extension vscode-gitops-tools-${FLUXV}.vsix \
    # && rm vscode-gitops-tools-${FLUXV}.vsix

# install weave gitops core
ARG WGC="0.6.2"
RUN wget https://github.com/weaveworks/weave-gitops/releases/download/v${WGC}/gitops-Linux-x86_64.tar.gz \
    && tar -xzf gitops-Linux-x86_64.tar.gz -C ${INSTALL_DIR} \
    && rm gitops-Linux-x86_64.tar.gz

#  install flux
ARG FV="0.26.0"
RUN curl -s https://fluxcd.io/install.sh | bash -s ${FV} \
    && mv ${FV} /usr/local/bin/flux

# install kind
ARG KIV="0.11.1"
RUN wget https://github.com/kubernetes-sigs/kind/releases/download/v${KIV}/kind-linux-amd64 \
    && chmod +x ./kind-linux-amd64 \
    && mv ./kind-linux-amd64 ${INSTALL_DIR}/kind

# install clusterctl
ARG CC="1.1.0"
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v${CC}/clusterctl-linux-amd64 -o clusterctl \
    && chmod +x ./clusterctl \
    && mv ./clusterctl ${INSTALL_DIR}/clusterctl 

# install Kustomize 
ARG KZV="4.1.3"
RUN curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KZV}/kustomize_v${KZV}_linux_amd64.tar.gz" -o /tmp/kustomize.tar.gz \
    && tar -xf /tmp/kustomize.tar.gz -C /tmp kustomize \
    && mkdir -p $INSTALL_DIR \
    && sudo mv /tmp/kustomize ${INSTALL_DIR} \
    && rm -f /tmp/kustomize.tar.gz \
    && rm -rf /tmp/kustomize

#  install kustomizer
# ARG KKV="2.0.0"
# RUN curl -s https://kustomizer.dev/install.sh | bash -s ${KKV}

#  install k3d
ARG K3V="5.0.0"
RUN wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v${K3V} bash