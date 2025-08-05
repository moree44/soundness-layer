# Soundness CLI - Installation & Usage Guide

> **Easy setup guide for the Soundness CLI tool on testnet**

Soundness Layer is a decentralized verification protocol offering low latency, high throughput, and cross-chain compatibility.

---

## Quick Installation

### Option 1: GitHub Codespaces (Recommended - Zero Setup)
1. Click **"<> Code"** → **"Codespaces"** → **"Create codespace on main"**
2. Wait for environment setup
3. Install with one command:
```bash
chmod +x install-soundness.sh
./install-soundness.sh
```
5. **Reload your shell:**
```bash
source ~/.bashrc
```

### Option 2: Manual Installation (For WSL/VPS)
```bash
# Clone and install
git clone https://github.com/moree44/soundness-layer.git
cd soundness-layer
chmod +x install-soundness.sh
./install-soundness.sh
```
**After installation, reload your shell:**
```bash
source ~/.bashrc
```

---

## Wallet Setup

After installation, the script will automatically present you with a **Wallet Setup Menu**:

```
================================
    WALLET SETUP MENU
================================

Choose an option:
1) Generate new wallet key
2) Import existing mnemonic phrase
3) Skip wallet setup (exit)

Enter your choice (1-3):
```

### Option 1: Generate New Wallet
- Choose option **1** from the menu
- Enter your desired wallet name (or press Enter for default: `my-wallet`)
- The system will generate a new wallet key for you

### Option 2: Import Existing Wallet
- Choose option **2** from the menu
- Enter your desired wallet name (or press Enter for default: `my-wallet`)
- Enter your 12-word mnemonic phrase (separated by spaces)
- The system will import your existing wallet

### Option 3: Skip Setup
- Choose option **3** to skip wallet setup
- You can set up your wallet later using manual commands

### Manual Commands (if needed later)
```bash
# List all keys
soundness-cli list-keys
```

### Step 2: Play Games & Submit Proofs
Play supported games on the Soundness testnet to generate proofs. After winning, the system will automatically provide you with a **ready-to-use command** for proof submission.

**Example: What you'll receive after winning a game:**

![Soundness CLI Send Command Example](https://i.imgur.com/rMxXVxC.png)

*Simply copy and paste the complete command provided by the system - it includes your proof blob ID and all necessary parameters!*

---

## Essential Commands

```bash
# Show help
soundness-cli --help

# Check version
soundness-cli --version

# View send command options
soundness-cli send --help

# List your keys
soundness-cli list-keys
```

---

## File Locations

- **Keys:** `~/.soundness/keys/`
- **Config & Logs:** `~/.soundness/`
- **Default Endpoint:** `https://testnet.soundness.xyz`

---

## Troubleshooting

**Command not found:**
```bash
source ~/.bashrc
```

**Missing dependencies:**
```bash
sudo apt install -y build-essential pkg-config libssl-dev
```

**Rust not installed:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

**Permission issues:**
```bash
chmod +x ~/.local/bin/soundness-cli
```

**Manual rebuild:**
```bash
cd soundness-layer/soundness-cli
cargo build --release
```

---

## Backup Your Keys

```bash
# Create backup directory
mkdir -p ~/soundness-backup

# Copy keys
cp ~/.soundness/keys/* ~/soundness-backup/

# Create compressed backup
tar -czf soundness-keys-backup.tar.gz ~/.soundness/keys/
```

---

## About Soundness Layer

Soundness is a **decentralized verification network** built with:
- **[Walrus](https://www.walrus.xyz/)** for data availability
- **[Sui](https://sui.io/)** for sequencing

**Key Features:**
- Low latency verification
- High throughput processing
- Cross-chain compatibility
- Restaking-backed security

---

## Support & Community

- [Website](https://soundness.xyz/)
- [Discord](https://discord.gg/F4cGbdqgw8)
- [GitHub](https://github.com/SoundnessLabs/soundness-layer)

---

## License

This guide is under the [MIT License](LICENSE). For Soundness Layer codebase license, check the [official repository](https://github.com/SoundnessLabs/soundness-layer).

---

<div align="center">
  Made with ❤️ for the Soundness Community
</div>
