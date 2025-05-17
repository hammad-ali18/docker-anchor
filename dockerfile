FROM --platform=linux/amd64 ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG SOLANA_CLI
ARG NODE_VERSION="v20.16.0"

ENV HOME="/root"
ENV NVM_DIR="${HOME}/.nvm"
ENV PATH="${HOME}/.cargo/bin:${HOME}/.local/share/solana/install/active_release/bin:${NVM_DIR}/versions/node/${NODE_VERSION}/bin:$PATH"


# Install base utilities
RUN apt-get update -qq && \
    apt-get upgrade -y -qq && \
    apt-get install -y -qq \
    build-essential git curl wget jq pkg-config python3-pip \
    libssl-dev libudev-dev zlib1g-dev llvm clang cmake make \
    libprotobuf-dev protobuf-compiler

# Install Rust
RUN curl -sSf https://sh.rustup.rs -o rustup.sh && \
    sh rustup.sh -y && \
    rustup component add rustfmt clippy

# Install Node.js via NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "${NVM_DIR}/nvm.sh" && \
    nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    npm install -g yarn

# Install Solana CLI (via Anza)
RUN sh -c "$(curl -sSfL https://release.anza.xyz/v1.18.11/install)"

# Generate default keypair
RUN solana-keygen new --no-passphrase -o ~/.config/solana/id.json

# Set Solana to devnet
RUN solana config set --url devnet

# Airdrop
RUN solana airdrop 2 || true

# Install Anchor using AVM with pinned version
RUN cargo install --git https://github.com/coral-xyz/anchor avm --locked --force && \
    export PATH="$HOME/.cargo/bin:$PATH:/root/.avm/bin" && \
    avm install 0.29.0 && \
    avm use 0.29.0 && \
    anchor --version
# Set up project
WORKDIR /project
COPY . .

RUN anchor build
# Set volume and default command
VOLUME /project
CMD ["bash"]
