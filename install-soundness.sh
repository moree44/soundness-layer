#!/bin/bash

# =============================================================================
# Soundness CLI - Universal Installation Script (Using soundnessup)
# Compatible with: Linux, WSL, GitHub Codespaces, Docker containers
# =============================================================================

#!/bin/bash
set -e

# Styling
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

# STEP 0: Display system info
info "System Info:"
echo "OS: $(uname -a)"
echo "User: $(whoami)"
echo "PATH: $PATH"

# STEP 1: Install dependencies
info "Installing required packages..."
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y curl git gcc build-essential pkg-config libssl-dev unzip
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm curl git base-devel pkg-config openssl unzip
else
    error "Unsupported package manager. Install dependencies manually."
    exit 1
fi
success "Dependencies installed."

# STEP 2: Install Rust (if not exists)
if ! command -v cargo &> /dev/null; then
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
else
    info "Rust already installed."
    source "$HOME/.cargo/env"
    rustup update
fi
success "Rust is ready: $(rustc --version)"

# STEP 3: Install soundnessup
info "Installing soundnessup via official installer..."
if curl -sSL https://install.soundness.xyz | bash; then
    source ~/.bashrc
    if [ -f "$HOME/.soundness/bin/soundnessup" ]; then
        ln -sf "$HOME/.soundness/bin/soundnessup" "$BIN_DIR/soundnessup"
        chmod +x "$BIN_DIR/soundnessup"
        success "soundnessup installed!"
    fi
else
    error "Failed to install soundnessup via curl. Trying from source..."
    # fallback build from source
    if [ -d "soundnessup" ]; then
        cd soundnessup
    else
        git clone https://github.com/SoundnessLabs/soundness-layer.git ~/soundness-layer
        cd ~/soundness-layer/soundnessup
    fi
    cargo build --release
    cp target/release/soundnessup "$BIN_DIR/"
    chmod +x "$BIN_DIR/soundnessup"
    success "soundnessup built from source!"
fi

# STEP 4: Install soundness-cli via soundnessup
info "Installing soundness-cli using soundnessup..."
if command -v soundnessup &> /dev/null; then
    if soundnessup install || soundnessup install soundness-cli; then
        success "soundness-cli installed!"
    else
        error "soundnessup couldn't install soundness-cli"
    fi
else
    error "soundnessup not found in PATH"
fi

# STEP 5: Post-install setup
info "Setting up config directories..."
mkdir -p "$HOME/.soundness"/{keys,logs,config}
chmod 700 "$HOME/.soundness/keys"

# STEP 6: Verify
echo -e "\n📦 ${GREEN}Installed Tools:${NC}"
command -v soundnessup && soundnessup --version || error "soundnessup missing"
command -v soundness-cli && soundness-cli --version || error "soundness-cli missing"

success "Install completed. Restart terminal or run: source ~/.bashrc"
