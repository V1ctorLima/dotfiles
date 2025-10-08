# Dockerfile for testing dotfiles with stow
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages and modern tools
RUN apt-get update && apt-get install -y \
    stow \
    zsh \
    bash \
    vim \
    git \
    curl \
    wget \
    tree \
    less \
    sudo \
    fzf \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    python3 \
    python3-pip \
    build-essential \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create a test user (non-root for realistic testing)
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Create necessary directories following best practices
RUN mkdir -p /home/testuser/.cache/zsh \
    && mkdir -p /home/testuser/.local/bin \
    && mkdir -p /home/testuser/.local/share \
    && mkdir -p /home/testuser/Projects

# Copy dotfiles first (needed for setup script)
COPY --chown=testuser:testuser . /home/testuser/dotfiles/

# Install modern CLI tools (focusing on Oh My Posh)
RUN cd /home/testuser/dotfiles && \
    curl https://mise.run | sh && \
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh && \
    curl -s https://ohmyposh.dev/install.sh | bash -s

# Add tool paths to PATH for testuser
ENV PATH="/home/testuser/.local/bin:/home/testuser/.atuin/bin:$PATH"

# Set working directory to dotfiles
WORKDIR /home/testuser/dotfiles

# Default command to run tests
CMD ["/bin/bash", "-c", "echo 'Testing dotfiles with stow...' && ./test-dotfiles.sh"]
