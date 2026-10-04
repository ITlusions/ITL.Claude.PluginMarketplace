FROM node:22-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates curl tini \
 && rm -rf /var/lib/apt/lists/*

# Claude Code CLI (pin with --build-arg CLAUDE_CODE_VERSION=x.y.z for reproducibility)
ARG CLAUDE_CODE_VERSION=latest
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Non-root user; HOME lives on a PVC in the cluster so login + installed plugins survive restarts
RUN useradd -m -u 1000 -s /bin/bash agent
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
USER agent
WORKDIR /home/agent/workspace
ENV HOME=/home/agent

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
