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
CONFIG_DIR="$HOME/.soundness"
REPO_ROOT=$(pwd)
mkdir -p "$BIN_DIR" "$CONFIG_DIR"/{keys,logs,config}
export PATH="$BIN_DIR:$PATH"

# Step 1: Install dependencies
info "Installing dependencies..."
if command -v apt &> /dev/null; then
  sudo apt update && sudo apt install -y curl git gcc build-essential pkg-config libssl-dev unzip
elif command -v pacman &> /dev/null; then
  sudo pacman -Sy --noconfirm curl git base-devel pkg-config openssl unzip
else
  error "Unsupported package manager. Install deps manually."
  exit 1
fi
success "Dependencies installed."

# Step 2: Install Rust
if ! command -v cargo &> /dev/null; then
  info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  echo 'source "$HOME/.cargo/env"' >> ~/.bashrc
  source "$HOME/.cargo/env"
else
  info "Rust already installed."
  source "$HOME/.cargo/env"
  rustup update
fi
success "Rust is ready: $(rustc --version)"

# Step 3: Install soundnessup via forked repo
info "Installing soundnessup via forked repo..."
if curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/soundnessup/install | bash; then
  source ~/.bashrc
  if [ -f "$HOME/.soundness/bin/soundnessup" ]; then
    ln -sf "$HOME/.soundness/bin/soundnessup" "$BIN_DIR/soundnessup"
    chmod +x "$BIN_DIR/soundnessup"
    success "soundnessup installed from your fork!"
  fi
else
  error "Failed to install soundnessup via curl. Trying build from source..."
  cd "$REPO_ROOT/soundnessup"
  cargo build --release
  cp target/release/soundnessup "$BIN_DIR/"
  chmod +x "$BIN_DIR/soundnessup"
  cd "$REPO_ROOT"
  success "soundnessup built from source!"
fi

# Step 4: Install soundness-cli manually (since soundnessup install may fail)
info "Installing soundness-cli from source..."
cd "$REPO_ROOT/soundness-cli"
cargo build --release
cp target/release/soundness-cli "$BIN_DIR/"
chmod +x "$BIN_DIR/soundness-cli"
cd "$REPO_ROOT"
success "soundness-cli built from source!"

# Step 5: Verify install
echo -e "\n📦 ${GREEN}Installed Tools:${NC}"

if command -v soundnessup &> /dev/null; then
  success "soundnessup: $(soundnessup version || echo '✅ Exists, but version cmd limited')"
else
  error "soundnessup not found in PATH"
fi

if command -v soundness-cli &> /dev/null; then
  success "soundness-cli: $(soundness-cli --version || echo '✅ Exists, but version cmd limited')"
else
  error "soundness-cli not found in PATH"
fi

# Step 6: Final message
echo ""
success "Install completed! Restart your terminal or run: source ~/.bashrc"

# Step 7: Wallet setup menu
echo ""
echo -e "${YELLOW}================================${NC}"
echo -e "${YELLOW}    WALLET SETUP MENU${NC}"
echo -e "${YELLOW}================================${NC}"
echo ""
echo "Choose an option:"
echo "1) Generate new wallet key"
echo "2) Import existing mnemonic phrase"
echo "3) Skip wallet setup (exit)"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        info "Generating new wallet key..."
        read -p "Enter wallet name (default: my-wallet): " wallet_name
        wallet_name=${wallet_name:-my-wallet}
        
        if soundness-cli generate-key --name "$wallet_name"; then
            success "New wallet '$wallet_name' generated successfully!"
        else
            error "Failed to generate wallet. Please try again manually."
        fi
        ;;
    2)
        echo ""
        info "Importing existing mnemonic phrase..."
        read -p "Enter wallet name (default: my-wallet): " wallet_name
        wallet_name=${wallet_name:-my-wallet}
        
        echo "Enter your 12-word mnemonic phrase (separated by spaces):"
        read -p "Mnemonic: " mnemonic
        
        if soundness-cli import-key --name "$wallet_name" --mnemonic "$mnemonic"; then
            success "Wallet '$wallet_name' imported successfully!"
        else
            error "Failed to import wallet. Please check your mnemonic phrase and try again."
        fi
        ;;
    3)
        echo ""
        info "Skipping wallet setup. You can set up your wallet later using:"
        echo "  soundness-cli generate-key --name my-wallet"
        echo "  soundness-cli import-key --name my-wallet --mnemonic \"your twelve word seed here\""
        ;;
    *)
        error "Invalid choice. Exiting without wallet setup."
        ;;
esac

echo ""
success "Setup complete! You can now use soundness-cli commands."
