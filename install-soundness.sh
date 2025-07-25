#!/bin/bash

# =============================================================================
# Soundness CLI - One-Time Installation Script
# =============================================================================

set -e  # Exit on any error

echo "🚀 Starting Soundness CLI Installation..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Step 1: Update system and install dependencies
print_status "Step 1: Installing system dependencies..."
sudo apt update -qq
sudo apt install -y curl wget git build-essential pkg-config libssl-dev

print_success "System dependencies installed!"

# Step 2: Install Rust if not present
print_status "Step 2: Checking Rust installation..."
if ! command -v cargo &> /dev/null; then
    print_status "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    print_success "Rust installed!"
else
    print_success "Rust already installed!"
    source ~/.cargo/env
fi

# Verify Rust installation
print_status "Rust version: $(rustc --version)"
print_status "Cargo version: $(cargo --version)"

# Step 3: Navigate to soundness-cli directory
print_status "Step 3: Building Soundness CLI..."
cd /workspaces/soundness-layer/soundness-cli

# Verify we're in the right directory
if [ ! -f "Cargo.toml" ]; then
    print_error "Cargo.toml not found! Are you in the right directory?"
    exit 1
fi

# Step 4: Build the project
print_status "Building project (this may take 2-5 minutes)..."
cargo build --release

# Verify build succeeded
if [ ! -f "target/release/soundness-cli" ]; then
    print_error "Build failed! Binary not found."
    exit 1
fi

print_success "Build completed successfully!"

# Step 5: Make CLI globally available
print_status "Step 4: Setting up global CLI access..."

# Create local bin directory if it doesn't exist
mkdir -p ~/.local/bin

# Copy binary to local bin
cp target/release/soundness-cli ~/.local/bin/

# Make it executable
chmod +x ~/.local/bin/soundness-cli

# Add to PATH if not already there
if ! echo $PATH | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    print_status "Added ~/.local/bin to PATH"
fi

# Source bashrc to update current session
export PATH="$HOME/.local/bin:$PATH"

print_success "CLI setup completed!"

# Step 6: Verify installation
print_status "Step 5: Verifying installation..."

# Test if CLI is accessible
if command -v soundness-cli &> /dev/null; then
    print_success "✅ soundness-cli is now globally available!"
    
    # Show version and help
    echo ""
    echo "📋 CLI Information:"
    echo "=================="
    soundness-cli --version
    echo ""
    echo "📖 Available Commands:"
    echo "===================="
    soundness-cli --help
    
else
    print_warning "CLI not found in PATH. You can still use it with full path:"
    echo "./target/release/soundness-cli --help"
fi

# Step 7: Setup directories
print_status "Step 6: Creating configuration directories..."
mkdir -p ~/.soundness
mkdir -p ~/.soundness/keys
mkdir -p ~/.soundness/logs

print_success "Configuration directories created!"

# Final summary
echo ""
echo "🎉 INSTALLATION COMPLETED SUCCESSFULLY!"
echo "======================================="
echo ""
echo "📋 What's installed:"
echo "  ✅ Rust toolchain"
echo "  ✅ Soundness CLI binary"
echo "  ✅ Global CLI access"
echo "  ✅ Configuration directories"
echo ""
echo "🔧 Next Steps:"
echo "  1. Generate a new key: soundness-cli generate-key"
echo "  2. List your keys: soundness-cli list-keys"
echo "  3. Check help: soundness-cli --help"
echo ""
echo "🌐 Testnet Information:"
echo "  • Default endpoint: https://testnet.soundness.xyz"
echo "  • Discord: https://discord.gg/F4cGbdqgw8"
echo "  • Telegram: https://t.me/SoundnessLabs"
echo "  • Website: https://soundness.xyz/"
echo ""
echo "⚠️  Security Reminders:"
echo "  • Backup your private keys securely"
echo "  • Never share private keys publicly"
echo "  • This is testnet - not for production use"
echo ""
echo "🎯 Ready to use! Run: soundness-cli generate-key"
echo ""

print_success "Installation script completed! 🚀"
