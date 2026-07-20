FROM node:24-bookworm-slim

ARG CLAUDE_CODE_VERSION=2.1.212
ARG CODEX_VERSION=0.144.5
ARG PI_VERSION=0.80.10

# Debian security updates should be picked up whenever the image is rebuilt.
# hadolint ignore=DL3008
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        fd-find \
        git \
        jq \
        less \
        openssh-client \
        procps \
        ripgrep \
        tini \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global \
        "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
        "@openai/codex@${CODEX_VERSION}" \
        "@earendil-works/pi-coding-agent@${PI_VERSION}" \
    && npm cache clean --force

ENV NPM_CONFIG_UPDATE_NOTIFIER=false

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
