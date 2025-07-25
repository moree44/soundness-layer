#!/bin/bash

# =============================================================================
# Soundness CLI - Universal Installation Script (Using soundnessup)
# Compatible with: Linux, WSL, GitHub Codespaces, Docker containers
# =============================================================================

set -e  # Exit on any error

echo "🚀 Starting Soundness CLI Installation via soundnessup..."
echo "======================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_header() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Detect environment
detect_environment() {
    if [ -n "$CODESPACES" ]; then
        echo "codespaces"
    elif [ -n "$WSL_DISTRO_NAME" ] || grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
    elif [ -f /.dockerenv ]; then
        echo "docker"
    else
        echo "linux"
    fi
}

ENV_TYPE=$(detect_environment)
print_status "Detected environment: $ENV_TYPE"

# Check if running as root (skip for Docker/Codespaces where it might be needed)
if [[ $EUID -eq 0 ]] && [[ "$ENV_TYPE" != "docker" ]] && [[ "$ENV_TYPE" != "codespaces" ]]; then
   print_error "This script should not be run as root for security reasons!"
   exit 1
fi

# Step 1: Update system and install dependencies
print_header "Step 1: Installing system dependencies..."

# Function to install packages based on distro
install_dependencies() {
    print_status "Detecting package manager..."
    
    if command -v apt &> /dev/null; then
        print_status "Using apt package manager..."
        
        # Update with retries for network issues
        for i in {1..3}; do
            if sudo apt update -qq; then
                break
            elif [ $i -eq 3 ]; then
                print_error "Failed to update package lists after 3 attempts"
                exit 1
            else
                print_status "Retrying apt update... (attempt $i/3)"
                sleep 2
            fi
        done
        
        print_status "Installing required packages..."
        sudo apt install -y \
            curl \
            wget \
            git \
            build-essential \
            pkg-config \
            libssl-dev \
            ca-certificates \
            gnupg \
            lsb-release \
            unzip
            
    elif command -v yum &> /dev/null; then
        print_status "Using yum package manager..."
        sudo yum update -y
        sudo yum install -y \
            curl \
            wget \
            git \
            gcc \
            gcc-c++ \
            make \
            pkg-config \
            openssl-devel \
            ca-certificates \
            unzip
            
    elif command -v dnf &> /dev/null; then
        print_status "Using dnf package manager..."
        sudo dnf update -y
        sudo dnf install -y \
            curl \
            wget \
            git \
            gcc \
            gcc-c++ \
            make \
            pkg-config \
            openssl-devel \
            ca-certificates \
            unzip
            
    elif command -v pacman &> /dev/null; then
        print_status "Using pacman package manager..."
        sudo pacman -Sy --noconfirm \
            curl \
            wget \
            git \
            base-devel \
            pkg-config \
            openssl \
            ca-certificates \
            unzip
            
    else
        print_error "No supported package manager found!"
        print_error "Please install: curl, wget, git, build-essential, pkg-config, libssl-dev manually"
        exit 1
    fi
}

install_dependencies
print_success "System dependencies installed!"

# Step 2: Install Rust if not present
print_header "Step 2: Setting up Rust toolchain..."

# Function to install Rust
install_rust() {
    if ! command -v cargo &> /dev/null; then
        print_status "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
        
        # Source cargo env for different shell configs
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
        fi
        
        # Add to multiple shell configs for compatibility
        for shell_config in ~/.bashrc ~/.zshrc ~/.profile; do
            if [ -f "$shell_config" ]; then
                if ! grep -q "cargo/env" "$shell_config"; then
                    echo 'source "$HOME/.cargo/env"' >> "$shell_config"
                fi
            fi
        done
        
        print_success "Rust installed!"
    else
        print_status "Rust already installed, updating..."
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
        fi
        rustup update stable 2>/dev/null || true
        print_success "Rust updated!"
    fi
}

install_rust

# Verify Rust installation
if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
    print_status "Rust version: $(rustc --version)"
    print_status "Cargo version: $(cargo --version)"
else
    print_error "Rust installation failed!"
    exit 1
fi

# Step 3: Setup local bin directory and PATH
print_header "Step 3: Setting up binary directories..."

# Create local bin directory
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Add to PATH for multiple shells
add_to_path() {
    local shell_config=$1
    if [ -f "$shell_config" ]; then
        if ! grep -q "$HOME/.local/bin" "$shell_config"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_config"
            print_status "Added ~/.local/bin to PATH in $shell_config"
        fi
    fi
}

# Add to common shell configs
for config in ~/.bashrc ~/.zshrc ~/.profile; do
    add_to_path "$config"
done

# Update current session PATH
export PATH="$HOME/.local/bin:$PATH"

print_success "Binary directories configured!"

# Step 4: Install soundnessup first
print_header "Step 4: Installing soundnessup tool..."

# Function to build soundnessup from source if needed
build_soundnessup_from_source() {
    print_status "Building soundnessup from source..."
    
    # Check if we're in the right workspace or need to clone
    WORKSPACE_DIR=""
    
    if [ -d "/workspaces/soundness-layer" ]; then
        WORKSPACE_DIR="/workspaces/soundness-layer"
    elif [ -d "$HOME/soundness-layer" ]; then
        WORKSPACE_DIR="$HOME/soundness-layer"
    elif [ -d "./soundness-layer" ]; then
        WORKSPACE_DIR="$(pwd)/soundness-layer"
    elif [ -d "$(pwd)" ] && [ -f "$(pwd)/soundnessup/Cargo.toml" ]; then
        WORKSPACE_DIR="$(pwd)"
    else
        # Try to clone the repository
        print_status "Cloning soundness-layer repository..."
        if command -v git &> /dev/null; then
            cd "$HOME"
            git clone https://github.com/SoundnessLabs/soundness-layer.git || {
                print_error "Failed to clone repository"
                return 1
            }
            WORKSPACE_DIR="$HOME/soundness-layer"
        else
            print_error "Git not available and no existing project directory found"
            return 1
        fi
    fi
    
    if [ ! -d "$WORKSPACE_DIR/soundnessup" ]; then
        print_error "soundnessup directory not found in $WORKSPACE_DIR"
        return 1
    fi
    
    cd "$WORKSPACE_DIR/soundnessup"
    
    if [ ! -f "Cargo.toml" ]; then
        print_error "Cargo.toml not found in soundnessup directory!"
        return 1
    fi
    
    # Build soundnessup
    print_status "Building soundnessup (this may take 2-5 minutes)..."
    if cargo build --release; then
        if [ -f "target/release/soundnessup" ]; then
            # Install soundnessup to local bin
            cp target/release/soundnessup "$BIN_DIR/"
            chmod +x "$BIN_DIR/soundnessup"
            print_success "soundnessup built and installed successfully!"
            return 0
        else
            print_error "soundnessup build completed but binary not found!"
            return 1
        fi
    else
        print_error "soundnessup build failed!"
        return 1
    fi
}

# Try to install soundnessup via official installer first, fallback to source build
SOUNDNESSUP_INSTALLED=false

print_status "Trying official soundnessup installer..."
if curl -sSL https://install.soundness.xyz | bash; then
    print_success "soundnessup installed via official installer!"
    SOUNDNESSUP_INSTALLED=true
    
    # Ensure it's in PATH
    if [ -f "$HOME/.soundness/bin/soundnessup" ]; then
        ln -sf "$HOME/.soundness/bin/soundnessup" "$BIN_DIR/soundnessup"
    fi
else
    print_warning "Official installer failed, trying source build..."
    if build_soundnessup_from_source; then
        SOUNDNESSUP_INSTALLED=true
    else
        print_error "Failed to install soundnessup via both methods"
        exit 1
    fi
fi

# Update PATH again to ensure soundnessup is available
export PATH="$HOME/.local/bin:$PATH"

# Step 5: Install soundness-cli using soundnessup
print_header "Step 5: Installing soundness-cli using soundnessup..."

if [ "$SOUNDNESSUP_INSTALLED" = true ]; then
    print_status "Using soundnessup to install soundness-cli..."
    
    if command -v soundnessup &> /dev/null; then
        # Try to install soundness-cli using soundnessup
        if soundnessup install; then
            print_success "soundness-cli installed successfully via soundnessup!"
        else
            print_warning "soundnessup install failed, trying alternative method..."
            if soundnessup install soundness-cli; then
                print_success "soundness-cli installed successfully via soundnessup!"
            else
                print_error "Failed to install soundness-cli via soundnessup"
                exit 1
            fi
        fi
    else
        print_error "soundnessup not found in PATH after installation"
        exit 1
    fi
else
    print_error "soundnessup not available, cannot install soundness-cli"
    exit 1
fi

# Step 6: Setup configuration directories
print_header "Step 6: Creating configuration directories..."

CONFIG_DIR="$HOME/.soundness"
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/keys"
mkdir -p "$CONFIG_DIR/logs"
mkdir -p "$CONFIG_DIR/config"

# Set proper permissions
chmod 700 "$CONFIG_DIR"
chmod 700 "$CONFIG_DIR/keys"

print_success "Configuration directories created!"

# Step 7: Verify installations
print_header "Step 7: Verifying installations..."

echo ""
echo "📋 Installation Verification:"
echo "============================"

# Test soundnessup
if command -v soundnessup &> /dev/null; then
    print_success "✅ soundnessup is available globally"
    VERSION=$(soundnessup --version 2>/dev/null || echo 'Version not available')
    echo "   Version: $VERSION"
else
    print_warning "⚠️  soundnessup not found in PATH"
fi

# Test soundness-cli
if command -v soundness-cli &> /dev/null; then
    print_success "✅ soundness-cli is available globally"
    VERSION=$(soundness-cli --version 2>/dev/null || echo 'Version not available')
    echo "   Version: $VERSION"
else
    print_warning "⚠️  soundness-cli not found in PATH"
    
    # Check if it's installed via soundnessup in a different location
    if [ -f "$HOME/.soundness/bin/soundness-cli" ]; then
        ln -sf "$HOME/.soundness/bin/soundness-cli" "$BIN_DIR/soundness-cli"
        print_status "Created symlink for soundness-cli"
    fi
fi

# Step 8: Display help information
print_header "Step 8: Available commands..."

echo ""
echo "📖 Command Help:"
echo "================"

if command -v soundnessup &> /dev/null; then
    echo ""
    echo "🚀 soundnessup commands:"
    soundnessup --help 2>/dev/null | head -20 || echo "Help not available"
fi

if command -v soundness-cli &> /dev/null; then
    echo ""
    echo "🔧 soundness-cli commands:"
    soundness-cli --help 2>/dev/null | head -20 || echo "Help not available"
fi

# Final summary
echo ""
echo "🎉 INSTALLATION COMPLETED!"
echo "========================="
echo ""
echo "📋 What's installed:"
echo "  ✅ Rust toolchain ($(rustc --version | cut -d' ' -f2))"
if command -v soundnessup &> /dev/null; then
    echo "  ✅ soundnessup tool"
else
    echo "  ❌ soundnessup tool (installation failed)"
fi
if command -v soundness-cli &> /dev/null; then
    echo "  ✅ soundness-cli (via soundnessup)"
else
    echo "  ❌ soundness-cli (installation failed)"
fi
echo "  ✅ Configuration directories"
echo "  ✅ PATH setup for multiple shells"
echo ""
echo "🌍 Environment: $ENV_TYPE"
echo "🔧 Binaries: $BIN_DIR"
echo "⚙️  Config: $CONFIG_DIR"
echo ""
echo "🔧 Quick Start Commands:"
if command -v soundness-cli &> /dev/null; then
    echo "  • Generate key: soundness-cli generate-key --name <name>"
    echo "  • List keys: soundness-cli list-keys"
    echo "  • Get help: soundness-cli --help"
fi

if command -v soundnessup &> /dev/null; then
    echo "  • Update CLI: soundnessup update"
    echo "  • Uninstall: soundnessup uninstall"
    echo "  • Get help: soundnessup --help"
fi

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
echo "  • Keys stored in: $CONFIG_DIR/keys (chmod 700)"
echo ""

# Environment-specific instructions
case "$ENV_TYPE" in
    "wsl")
        echo "🪟 WSL-specific notes:"
        echo "  • Restart WSL terminal or run: source ~/.bashrc"
        echo "  • Windows paths accessible via /mnt/"
        ;;
    "codespaces")
        echo "☁️  Codespaces-specific notes:"
        echo "  • No terminal restart needed"
        echo "  • Changes persist in this session"
        ;;
    "docker")
        echo "🐳 Docker-specific notes:"
        echo "  • Restart container to persist PATH changes"
        echo "  • Consider volume mounting for persistent data"
        ;;
esac

echo ""
echo "🔄 If commands not found, try:"
echo "   • Restart your terminal"
echo "   • Run: source ~/.bashrc (or ~/.zshrc)"
echo "   • Check: echo \$PATH | grep .local/bin"
echo ""

print_success "Soundness CLI installation via soundnessup completed! 🚀"

# Optional environment check
if [ "$ENV_TYPE" = "wsl" ] || [ "$ENV_TYPE" = "linux" ]; then
    echo ""
    read -p "🔄 Restart terminal to ensure PATH is updated? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Please restart your terminal or run: source ~/.bashrc"
    fi
fi
