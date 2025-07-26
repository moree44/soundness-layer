# Soundness CLI - One-Click Installation Guide

> **Easily set up the Soundness CLI tool for testnet interaction**

Soundness Layer is a decentralized verification protocol that offers low latency, high throughput, and cross-chain compatibility. This guide will help you install and use the Soundness CLI in just a few steps.

---

##  Installation Methods

###  Option 1: Manual Installation

```bash
# 1. Clone the repository
git clone https://github.com/moree44/soundness-layer.git
cd soundness-layer

# 2. Run the install script
chmod +x install-soundness.sh
./install-soundness.sh

# 3. Generate your first wallet key
soundness-cli generate-key --name my-wallet
```

###  Option 2: GitHub Codespaces (Zero Setup)

1. Go to [Soundness Layer Repository](https://github.com/moree44/soundness-layer)
2. Click **"<> Code"** → **"Codespaces"** → **"Create codespace on main"**
3. Wait for the environment to initialize
4. Run the following install command:

```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
```

5. Verify installation:

```bash
soundness-cli --version
soundnessup version
```

---

##  Managing Your Keys

### Generate a New Key:

```bash
soundness-cli generate-key --name my-wallet
```
### Import Existing Mnemonic:

```bash
soundness-cli import-key --name my-wallet --mnemonic "your twelve word seed here"
```
### List Your Keys:

```bash
soundness-cli list-keys
```
>  **Your keys are stored locally at:** `~/.soundness/keys/`

---

##  Prerequisites

### GitHub Codespaces:

* ✅ GitHub account
* ✅ Web browser

### Local Setup:

* ✅ Linux/macOS (Ubuntu 20.04+ recommended)
* ✅ Internet connection
* ✅ Git & curl
* ✅ Basic terminal usage

---

## 🔧 Common CLI Commands

```bash
# Show CLI help
soundness-cli --help

# Generate key
soundness-cli generate-key --name my-wallet

# Check installed version
soundness-cli --version

# Send proof (advanced)
soundness-cli send --help
```

---

##  Configuration & Endpoints

* ✅ Default endpoint: `https://testnet.soundness.xyz`
* ✅ All config and logs: `~/.soundness/`

---

## 🛠 Troubleshooting

### Command not found: `soundness-cli`

```bash
source ~/.bashrc
```

### Missing dependencies:

```bash
sudo apt install -y build-essential pkg-config libssl-dev
```

### Rust not found:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

### Permission denied:

```bash
chmod +x ~/.local/bin/soundness-cli
```

### Rebuild manually:

```bash
cd soundness-layer/soundness-cli
cargo build --release
```

---

##  Backup Your Keys

```bash
mkdir -p ~/soundness-backup
cp ~/.soundness/keys/* ~/soundness-backup/
tar -czf soundness-keys-backup.tar.gz ~/.soundness/keys/
```

---


##  What is Soundness Layer?

Soundness is a **decentralized verification network**, built with:

* 🔹 **[Walrus](https://www.walrus.xyz/)** for data availability
* 🔹 **[Sui](https://sui.io/)** for sequencing

### Highlights:

* ⚡ **Low latency**
* 🚀 **High throughput**
* 🔗 **Cross-chain support**
* 🔐 **Restaking-backed security**

---

---

## 📄 License

This guide is under the [MIT License](LICENSE). For the Soundness Layer codebase license, check the [official repository](https://github.com/SoundnessLabs/soundness-layer).

---

<div align="center">
  Made with ❤️ for the Soundness Community  
  [Website](https://soundness.xyz/) • [Discord](https://discord.gg/F4cGbdqgw8) • [GitHub](https://github.com/SoundnessLabs/soundness-layer)
</div>
