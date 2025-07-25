#!/bin/bash

# =============================================================================
# Soundness CLI - Universal Installation Script
# Compatible with: Linux, WSL, GitHub Codespaces, Docker containers
# =============================================================================

set -e  # Exit on any error

echo "🚀 Starting Soundness CLI Universal Installation..."
echo "=================================================="

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

# Set workspace directory based on environment
set_workspace_dir() {
    case "$ENV_TYPE" in
        "codespaces")
            WORKSPACE_DIR="/workspaces/soundness-layer"
            ;;
        "wsl"|"docker"|"linux")
            # Try multiple possible locations
            if [ -d "/workspaces/soundness-layer" ]; then
                WORKSPACE_DIR="/workspaces/soundness-layer"
            elif [ -d "$HOME/soundness-layer" ]; then
                WORKSPACE_DIR="$HOME/soundness-layer"
            elif [ -d "./soundness-layer" ]; then
                WORKSPACE_DIR="$(pwd)/soundness-layer"
            elif [ -d "$(pwd)" ] && [ -f "$(pwd)/soundness-cli/Cargo.toml" ]; then
                WORKSPACE_DIR="$(pwd)"
            else
                WORKSPACE_DIR=""
            fi
            ;;
        *)
            WORKSPACE_DIR=""
            ;;
    esac
}

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

# Step 3: Setup project directory structure
print_header "Step 3: Locating project directory..."

set_workspace_dir

if [ -z "$WORKSPACE_DIR" ]; then
    print_error "Could not find soundness-layer project directory!"
    print_error "Please ensure you're in one of these locations:"
    print_error "  - /workspaces/soundness-layer (Codespaces)"
    print_error "  - ~/soundness-layer (WSL/Linux)"
    print_error "  - Current directory with soundness-cli folder"
    print_error ""
    print_status "Or clone the repository first:"
    print_status "git clone <repository-url> soundness-layer"
    exit 1
fi

if [ ! -d "$WORKSPACE_DIR" ]; then
    print_error "Workspace directory not found: $WORKSPACE_DIR"
    exit 1
fi

cd "$WORKSPACE_DIR"
print_status "Working in: $(pwd)"

# Step 4: Build soundness-cli
print_header "Step 4: Building soundness-cli..."

build_component() {
    local component=$1
    local component_dir="$WORKSPACE_DIR/$component"
    
    if [ -d "$component_dir" ]; then
        print_status "Building $component..."
        cd "$component_dir"
        
        # Verify Cargo.toml exists
        if [ ! -f "Cargo.toml" ]; then
            print_error "Cargo.toml not found in $component directory!"
            return 1
        fi
        
        # Clean previous builds for fresh start
        cargo clean &>/dev/null || true
        
        # Build with proper error handling
        print_status "Compiling $component (this may take 2-5 minutes)..."
        if cargo build --release; then
            # Verify build succeeded
            if [ -f "target/release/$component" ]; then
                print_success "$component built successfully!"
                return 0
            else
                print_error "$component build completed but binary not found!"
                return 1
            fi
        else
            print_error "$component build failed!"
            return 1
        fi
    else
        print_warning "$component directory not found, skipping..."
        return 1
    fi
}

# Build both components
SOUNDNESS_CLI_BUILT=false
SOUNDNESSUP_BUILT=false

if build_component "soundness-cli"; then
    SOUNDNESS_CLI_BUILT=true
fi

cd "$WORKSPACE_DIR"

if build_component "soundnessup"; then
    SOUNDNESSUP_BUILT=true
fi

cd "$WORKSPACE_DIR"

# Ensure at least one component was built
if [ "$SOUNDNESS_CLI_BUILT" = false ] && [ "$SOUNDNESSUP_BUILT" = false ]; then
    print_error "No components were successfully built!"
    exit 1
fi

# Step 5: Install binaries globally
print_header "Step 5: Installing binaries globally..."

# Create local bin directory
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Install soundness-cli
if [ "$SOUNDNESS_CLI_BUILT" = true ] && [ -f "soundness-cli/target/release/soundness-cli" ]; then
    cp soundness-cli/target/release/soundness-cli "$BIN_DIR/"
    chmod +x "$BIN_DIR/soundness-cli"
    print_success "soundness-cli installed to $BIN_DIR/"
fi

# Install soundnessup
if [ "$SOUNDNESSUP_BUILT" = true ] && [ -f "soundnessup/target/release/soundnessup" ]; then
    cp soundnessup/target/release/soundnessup "$BIN_DIR/"
    chmod +x "$BIN_DIR/soundnessup"
    print_success "soundnessup installed to $BIN_DIR/"
fi

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

# Test soundness-cli
if command -v soundness-cli &> /dev/null; then
    print_success "✅ soundness-cli is available globally"
    VERSION=$(soundness-cli --version 2>/dev/null || echo 'Version not available')
    echo "   Version: $VERSION"
else
    if [ "$SOUNDNESS_CLI_BUILT" = true ]; then
        print_warning "⚠️  soundness-cli built but not in PATH"
        echo "   Manual path: $BIN_DIR/soundness-cli"
    else
        print_warning "❌ soundness-cli not built"
    fi
fi

# Test soundnessup
if command -v soundnessup &> /dev/null; then
    print_success "✅ soundnessup is available globally"
    VERSION=$(soundnessup --version 2>/dev/null || echo 'Version not available')
    echo "   Version: $VERSION"
else
    if [ "$SOUNDNESSUP_BUILT" = true ]; then
        print_warning "⚠️  soundnessup built but not in PATH"
        echo "   Manual path: $BIN_DIR/soundnessup"
    else
        print_warning "❌ soundnessup not built"
    fi
fi

# Step 8: Display help information
print_header "Step 8: Available commands..."

echo ""
echo "📖 Command Help:"
echo "================"

if command -v soundness-cli &> /dev/null || [ -f "$BIN_DIR/soundness-cli" ]; then
    echo ""
    echo "🔧 soundness-cli commands:"
    if command -v soundness-cli &> /dev/null; then
        soundness-cli --help 2>/dev/null | head -20 || echo "Help not available"
    else
        echo "   Use: $BIN_DIR/soundness-cli --help"
    fi
fi

if command -v soundnessup &> /dev/null || [ -f "$BIN_DIR/soundnessup" ]; then
    echo ""
    echo "🚀 soundnessup commands:"
    if command -v soundnessup &> /dev/null; then
        soundnessup --help 2>/dev/null | head -20 || echo "Help not available"
    else
        echo "   Use: $BIN_DIR/soundnessup --help"
    fi
fi

# Final summary
echo ""
echo "🎉 INSTALLATION COMPLETED!"
echo "========================="
echo ""
echo "📋 What's installed:"
echo "  ✅ Rust toolchain ($(rustc --version | cut -d' ' -f2))"
if [ "$SOUNDNESS_CLI_BUILT" = true ]; then
    echo "  ✅ soundness-cli binary"
else
    echo "  ❌ soundness-cli binary (build failed)"
fi
if [ "$SOUNDNESSUP_BUILT" = true ]; then
    echo "  ✅ soundnessup binary"
else
    echo "  ❌ soundnessup binary (not found or build failed)"
fi
echo "  ✅ Configuration directories"
echo "  ✅ PATH setup for multiple shells"
echo ""
echo "🌍 Environment: $ENV_TYPE"
echo "📁 Workspace: $WORKSPACE_DIR"
echo "🔧 Binaries: $BIN_DIR"
echo "⚙️  Config: $CONFIG_DIR"
echo ""
echo "🔧 Quick Start Commands:"
if command -v soundness-cli &> /dev/null; then
    echo "  • Generate key: soundness-cli generate-key --name <NAME>"
    echo "  • List keys: soundness-cli list-keys"
else
    echo "  • Generate key: $BIN_DIR/soundness-cli generate-key --name <NAME>"
    echo "  • List keys: $BIN_DIR/soundness-cli list-keys"
fi

if command -v soundnessup &> /dev/null; then
    echo "  • Start soundness: soundnessup start"
    echo "  • Stop soundness: soundnessup stop"
elif [ "$SOUNDNESSUP_BUILT" = true ]; then
    echo "  • Start soundness: $BIN_DIR/soundnessup start"
    echo "  • Stop soundness: $BIN_DIR/soundnessup stop"
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
echo "   • Use manual paths shown above"
echo ""

print_success "Universal installation completed! 🚀"

# Optional environment check
if [ "$ENV_TYPE" = "wsl" ] || [ "$ENV_TYPE" = "linux" ]; then
    echo ""
    read -p "🔄 Restart terminal to ensure PATH is updated? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Please restart your terminal or run: source ~/.bashrc"
    fi
fi
