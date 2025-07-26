# Soundness CLI - Installation & Usage Guide

> **Easy setup guide for the Soundness CLI tool on testnet**

Soundness Layer is a decentralized verification protocol offering low latency, high throughput, and cross-chain compatibility.

---

## Quick Installation

### Option 1: GitHub Codespaces (Recommended - Zero Setup)
1. Visit the [Soundness Layer Repository](https://github.com/moree44/soundness-layer)
2. Click **"<> Code"** → **"Codespaces"** → **"Create codespace on main"**
3. Wait for environment setup
4. Install with one command:
```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
```
5. **Reload your shell:**
```bash
source ~/.bashrc
```
6. Verify installation:
```bash
soundness-cli --version
soundnessup version
```

### Option 2: Manual Installation
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

## Step-by-Step Usage

### Step 1: Generate Your Wallet Key
```bash
# Create a new wallet
soundness-cli generate-key --name my-wallet

# Or import existing mnemonic
soundness-cli import-key --name my-wallet --mnemonic "your twelve word seed here"

# List all keys
soundness-cli list-keys
```

### Step 2: Play Games & Submit Proofs
Play supported games on the Soundness testnet to generate proofs. After winning, the system will automatically provide you with a **ready-to-use command** for proof submission.

**Example: What you'll receive after winning a game:**

![Soundness CLI Send Command Example](]https://imgur.com/rMxXVxC.png)

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
