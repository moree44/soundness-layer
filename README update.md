#  Soundness CLI - Easy Installation Guide


> **One-click installation script for Soundness CLI in GitHub Codespaces**

Soundness Layer is a decentralized verification layer that provides low latency, high throughput, and cross-chain compatibility for blockchain networks. This guide helps you set up the CLI tool quickly and easily.


## Installation Methods


### Option 1: One-Line Installation

```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-cli-installer/main/install-soundness.sh | bash
```

### Option 2: Manual Installation

```bash
# 1. Clone this repo
git clone https://github.com/moree44/soundness-cli-installer.git
cd soundness-cli-installer

# 2. Run installation script
chmod +x install-soundness.sh
./install-soundness.sh

# 3. Generate your first key
soundness-cli generate-key
```

### Option 3: GitHub Codespaces (Zero Setup)

1. Open [Soundness Layer Repository](https://github.com/SoundnessLabs/soundness-layer)
2. Click **"< > Code"** → **"Codespaces"** → **"Create codespace on main"**
3. Wait for Codespace to load (2-5 minutes)
4. Run our installation script:

```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-cli-installer/main/install-soundness.sh | bash
```

Verify installation
```bash
soundness-cli --version
```
### Generate Your First Key

```bash
# Generate a new private key
soundness-cli generate-key

# List all your keys
soundness-cli list-keys
```

## 🎯 What is Soundness Layer?

Soundness Layer is a **decentralized verification layer** built on:
- **[Walrus](https://www.walrus.xyz/)** for data availability
- **[Sui](https://sui.io/)** for sequencing

### Key Features:
- ✅ **Low Latency** - Fast transaction processing
- ✅ **High Throughput** - Scalable for high volume
- ✅ **Cross-Chain** - Works across different blockchains
- ✅ **Secure** - Maintained through restaking protocol

## 📦 Prerequisites

### For GitHub Codespaces (Recommended):
- ✅ **GitHub account**
- ✅ **Web browser**
- ✅ **Nothing else!** (All dependencies auto-installed)

### For Local Installation:
- ✅ **Linux/macOS** (Ubuntu 20.04+ recommended)
- ✅ **Internet connection**
- ✅ **Git** installed
- ✅ **Basic terminal knowledge**


### Basic Commands

```bash
# Show help
soundness-cli --help

# Check version
soundness-cli --version

# Generate key with custom name
soundness-cli generate-key --name my-wallet

# Send proofs (advanced usage)
soundness-cli send --help
```

### Configuration

```bash
# Default endpoint (automatically configured)
https://testnet.soundness.xyz

# Check current configuration
soundness-cli list-keys

# All keys stored in:
~/.soundness/keys/
```

## 🐛 Troubleshooting

### Common Issues & Solutions

#### 1. **Command not found: soundness-cli**

```bash
# Solution 1: Update PATH
source ~/.bashrc

# Solution 2: Use full path
./target/release/soundness-cli --help

# Solution 3: Reinstall
curl -sSL https://raw.githubusercontent.com/yourusername/soundness-cli-installer/main/install-soundness.sh | bash
```

#### 2. **Build errors**

```bash
# Install missing dependencies
sudo apt update
sudo apt install -y build-essential pkg-config libssl-dev

# Clean and rebuild
cd soundness-layer/soundness-cli
cargo clean
cargo build --release
```

#### 3. **Permission denied**

```bash
# Fix binary permissions
chmod +x ~/.local/bin/soundness-cli

# Or use sudo for global install
sudo cp target/release/soundness-cli /usr/local/bin/
```

#### 4. **Rust not found**

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Verify Rust installation
rustc --version
cargo --version
```

### Debug Mode

```bash
# Run script with verbose output
bash -x install-soundness.sh

# Check syntax before running
bash -n install-soundness.sh
```

## 🌐 Community & Support

### Official Links

-  **Website**: [soundness.xyz](https://soundness.xyz/)
-  **Discord**: [Join Community](https://discord.gg/F4cGbdqgw8)
-  **Telegram**: [SoundnessLabs](https://t.me/SoundnessLabs)
-  **X/Twitter**: [@SoundnessLabs](https://x.com/SoundnessLabs)
-  **GitHub**: [SoundnessLabs](https://github.com/SoundnessLabs/soundness-layer)

### Getting Testnet Access

1. **Join Discord**: https://discord.gg/F4cGbdqgw8
2. **Go to #testnet-access** channel
3. **Share your public key** (not private key!)
4. **Follow team instructions** for testnet registration


###  Important Security Reminders


####
- **Share private keys** in Discord/Telegram
- **Use testnet keys** for mainnet (when available)
- **Store keys** in plain text files
- **Trust unofficial** installation sources
- **Use for production** (this is testnet only)

### File Locations

```bash
# CLI Binary
~/.local/bin/soundness-cli

# Configuration & Keys (encrypted)
~/.soundness/keys/
~/.soundness/logs/

# Rust toolchain
~/.cargo/bin/
```

### Backup Your Keys

```bash
# Create backup directory
mkdir -p ~/soundness-backup

# Copy keys (they're encrypted)
cp ~/.soundness/keys/* ~/soundness-backup/

# Or create tar archive
tar -czf soundness-keys-backup.tar.gz ~/.soundness/keys/
```


## 🎯 Next Steps After Installation

1. **Generate your first key**:
   ```bash
   soundness-cli generate-key
   ```

2. **Join the community**:
   - Discord: https://discord.gg/F4cGbdqgw8
   
3. **Explore CLI features**:
   ```bash
   soundness-cli --help
   soundness-cli send --help
   ```

4. **Request testnet access** in Discord

5. **Start experimenting** with proofs and transactions

## 🤝 Contributing

Found an issue or want to improve this guide?

1. **Fork this repository**
2. **Create your feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

## 📄 License

This installation guide is provided under the [MIT License](LICENSE).

The Soundness Layer project has its own license - check the [official repository](https://github.com/SoundnessLabs/soundness-layer) for details.

## ⭐ Support This Project

If this guide helped you, please:
- ⭐ **Star this repository**
- 🐦 **Share on social media**
- 💬 **Join our Discord community**
- 🍴 **Fork and contribute improvements**

---

<div align="center">

**Made with ❤️ for the Soundness Community**

[Website](https://soundness.xyz/) • [Discord](https://discord.gg/F4cGbdqgw8) • [GitHub](https://github.com/SoundnessLabs/soundness-layer)

</div>
