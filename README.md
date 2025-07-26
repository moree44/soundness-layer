# Soundness CLI - Installation & Usage Guide

> **Easy setup guide for the Soundness CLI tool on testnet**

Soundness Layer is a decentralized verification protocol offering low latency, high throughput, and cross-chain compatibility.

---

## 🚀 Quick Installation

### Option 1: GitHub Codespaces (Recommended - Zero Setup)
1. Visit the [Soundness Layer Repository](https://github.com/moree44/soundness-layer)
2. Click **"<> Code"** → **"Codespaces"** → **"Create codespace on main"**
3. Wait for environment setup
4. Install with one command:
```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
```
5. Verify installation:
```bash
soundness-cli --version
```

### Option 2: Manual Installation
```bash
# Clone and install
git clone https://github.com/moree44/soundness-layer.git
cd soundness-layer
chmod +x install-soundness.sh
./install-soundness.sh
```

---

## 📋 Prerequisites

**For GitHub Codespaces:**
- GitHub account
- Web browser

**For Local Setup:**
- Linux/macOS (Ubuntu 20.04+ recommended)
- Git & curl installed
- Internet connection

---

## 🔑 Step-by-Step Usage

### Step 1: Generate Your Wallet Key
```bash
# Create a new wallet
soundness-cli generate-key --name my-wallet

# Or import existing mnemonic
soundness-cli import-key --name my-wallet --mnemonic "your twelve word seed here"

# List all keys
soundness-cli list-keys
```

### Step 2: Play Games & Get Proofs
Play supported games on the Soundness testnet to generate proofs. After winning, you'll receive a **Walrus Blob ID** for your proof.

**Example: What you'll receive after winning a game:**

![Soundness CLI Send Command Example](images/cli-send-example.png)

*The system will provide you with the complete command including your proof blob ID and all necessary parameters.*

### Step 3: Submit Your Proof for Verification
Once you have your proof and Blob ID, submit it for verification:

```bash
soundness-cli send --proof-file <proof-blob-id> --game <game-name> --key-name <your-key-name> --proving-system ligetron --payload '<json-payload>'
```

**Command Parameters:**
- `--proof-file` (`-p`): Your unique Walrus Blob ID received after winning
- `--game` (`-g`): Game name (e.g., `8queens`, `tictactoe`)
- `--key-name` (`-k`): Your wallet key name from Step 1
- `--proving-system` (`-s`): Use `ligetron` for current testnet games
- `--payload` (`-d`): JSON string with verification inputs

**Example:**
```bash
soundness-cli send --proof-file abc123xyz --game tictactoe --key-name my-wallet --proving-system ligetron --payload '{"input": "game_data"}'
```

---

## 🔧 Essential Commands

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

## 📁 File Locations

- **Keys:** `~/.soundness/keys/`
- **Config & Logs:** `~/.soundness/`
- **Default Endpoint:** `https://testnet.soundness.xyz`

---

## 🛠 Troubleshooting

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

## 💾 Backup Your Keys

```bash
# Create backup directory
mkdir -p ~/soundness-backup

# Copy keys
cp ~/.soundness/keys/* ~/soundness-backup/

# Create compressed backup
tar -czf soundness-keys-backup.tar.gz ~/.soundness/keys/
```

---

## 🔍 About Soundness Layer

Soundness is a **decentralized verification network** built with:
- **[Walrus](https://www.walrus.xyz/)** for data availability
- **[Sui](https://sui.io/)** for sequencing

## 📄 License

This guide is under the [MIT License](LICENSE). For Soundness Layer codebase license, check the [official repository](https://github.com/SoundnessLabs/soundness-layer).

---

<div align="center">
  Made with ❤️ for the Soundness Community
</div>
