#!/bin/bash

# =============================================================================
# Soundness Layer - Quick Installer (Lokal)
# =============================================================================

set -e  # Exit on any error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🚀 Starting Soundness Layer Local Install..."
echo "==================================================="

# Step 1: Build and install soundnessup from local repo
print_status "Step 1: Building and installing soundnessup from local repo..."
cd "$(dirname "$0")/soundnessup"
cargo build --release
mkdir -p "$HOME/.local/bin"
cp target/release/soundnessup "$HOME/.local/bin/soundnessup"
chmod +x "$HOME/.local/bin/soundnessup"
cd ..

print_success "soundnessup installed to ~/.local/bin/soundnessup"

# Step 2: Advise user to update shell environment
print_status "Step 2: Update your shell environment (PATH) so 'soundnessup' is recognized."
echo "\nTo use 'soundnessup' immediately, update your shell environment:"
echo "  For Bash:   source ~/.bashrc"
echo "  For Zsh:    source ~/.zshenv"
echo "Atau cukup restart terminal Anda."

# Step 3: Advise user to install CLI
print_status "Step 3: Install Soundness CLI using soundnessup:"
echo "  soundnessup install"
echo "\nUntuk update CLI di masa depan, jalankan:"
echo "  soundnessup update"

echo "\n🎉 Installation script completed! 🚀"
