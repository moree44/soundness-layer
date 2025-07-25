# 🚀 Soundness CLI - One-Click Installation Tutorial

[![GitHub](https://img.shields.io/badge/GitHub-Soundness%20Layer-blue?logo=github)](https://github.com/SoundnessLabs/soundness-layer)
[![Discord](https://img.shields.io/badge/Discord-Join%20Community-7289da?logo=discord)](https://discord.gg/F4cGbdqgw8)
[![Testnet](https://img.shields.io/badge/Network-Testnet-orange)](https://testnet.soundness.xyz)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **🎯 Easy installation script for Soundness CLI - Zero configuration needed!**

**Soundness Layer** adalah decentralized verification layer yang menyediakan low latency, high throughput, dan cross-chain compatibility untuk blockchain networks. Tutorial ini membantu Anda setup Soundness CLI dengan mudah dan cepat.

## 📋 Daftar Isi

- [🚀 Quick Start](#-quick-start)
- [📖 Apa itu Soundness Layer?](#-apa-itu-soundness-layer)
- [💻 Cara Install](#-cara-install)
- [🔑 Generate Key](#-generate-key)
- [📚 Panduan Penggunaan](#-panduan-penggunaan)
- [🐛 Troubleshooting](#-troubleshooting)
- [🌐 Community & Support](#-community--support)
- [🔒 Catatan Keamanan](#-catatan-keamanan)

## 🚀 Quick Start

### ⚡ One-Line Installation (Termudah!)

```bash
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
```

**Itu saja! Script akan otomatis install semua yang diperlukan.**

### 🐙 GitHub Codespaces (Zero Setup)

1. **Buka**: [Soundness Layer Repository](https://github.com/SoundnessLabs/soundness-layer)
2. **Klik**: **"< > Code"** → **"Codespaces"** → **"Create codespace on main"**
3. **Tunggu**: 2-5 menit untuk Codespace loading
4. **Jalankan**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
   ```
5. **Selesai**: Langsung bisa generate key!

## 📖 Apa itu Soundness Layer?

**Soundness Layer** adalah layer verifikasi terdesentralisasi yang dibangun di atas:
- 🗄️ **[Walrus](https://www.walrus.xyz/)** - untuk data availability
- ⚡ **[Sui](https://sui.io/)** - untuk sequencing

### ✨ Fitur Utama:
- ✅ **Low Latency** - Pemrosesan transaksi cepat
- ✅ **High Throughput** - Skalabel untuk volume tinggi  
- ✅ **Cross-Chain** - Bekerja di berbagai blockchain
- ✅ **Secure** - Diamankan melalui restaking protocol

### 🎯 Use Cases:
- **Proof verification** - Verifikasi bukti matematika
- **Cross-chain messaging** - Komunikasi antar blockchain
- **Data availability** - Penyimpanan data terdesentralisasi
- **Settlement layer** - Layer penyelesaian transaksi

## 💻 Cara Install

### Method 1: Automatic Script (Recommended) 🤖

```bash
# Download dan jalankan installer
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash

# Verify installation
soundness-cli --version
```

**Yang akan di-install oleh script:**
- ✅ **Rust toolchain** (jika belum ada)
- ✅ **System dependencies** (build tools, SSL libraries)
- ✅ **Soundness CLI** (compiled from source)
- ✅ **Global CLI access** (ditambahkan ke PATH)
- ✅ **Configuration directories**

**Estimasi waktu**: 3-5 menit

### Method 2: Manual Installation 🔧

```bash
# 1. Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# 2. Clone repository
git clone https://github.com/SoundnessLabs/soundness-layer.git
cd soundness-layer/soundness-cli

# 3. Build from source
cargo build --release

# 4. Install globally
mkdir -p ~/.local/bin
cp target/release/soundness-cli ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 5. Verify
soundness-cli --version
```

### Method 3: Codespaces (Zero Setup) ☁️

**GitHub Codespaces** memberikan environment yang sudah siap pakai:

1. **Fork atau open** [Soundness Layer repo](https://github.com/SoundnessLabs/soundness-layer)
2. **Klik "Code"** → **"Codespaces"** → **"Create codespace"**
3. **Tunggu loading** (environment otomatis ter-setup)
4. **Run installer**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
   ```

**Keunggulan Codespaces:**
- ✅ **Tidak perlu install** apapun di komputer lokal
- ✅ **Environment konsisten** untuk semua user
- ✅ **Akses dari browser** mana saja
- ✅ **Free tier** tersedia untuk personal use

## 🔑 Generate Key

Setelah installation selesai, generate private key pertama Anda:

```bash
# Generate new private key
soundness-cli generate-key

# List semua keys
soundness-cli list-keys

# Check help
soundness-cli --help
```

### 📝 Output Example:
```bash
$ soundness-cli generate-key
✅ Key generated successfully!
📍 Key stored in: ~/.soundness/keys/
🔐 Please backup your key securely!

$ soundness-cli list-keys
🔑 Available keys:
- Key 1: 0xabc123...def789
- Key 2: 0x456...xyz (if you have multiple)
```

## 📚 Panduan Penggunaan

### 🔧 Basic Commands

```bash
# Show help
soundness-cli --help

# Check version
soundness-cli --version

# Generate key
soundness-cli generate-key

# List keys
soundness-cli list-keys

# Send proofs (advanced)
soundness-cli send --help
```

### ⚙️ Configuration

```bash
# Default endpoint (otomatis ter-configure)
https://testnet.soundness.xyz

# Check current config
soundness-cli list-keys

# File locations
~/.soundness/keys/      # Private keys (encrypted)
~/.soundness/logs/      # Application logs
~/.local/bin/soundness-cli  # CLI binary
```

### 🌐 Testnet Usage

1. **Generate key** dengan `soundness-cli generate-key`
2. **Join Discord**: https://discord.gg/F4cGbdqgw8  
3. **Request testnet access** di channel #testnet-access
4. **Share public key** (BUKAN private key!) untuk registration
5. **Mulai experiment** dengan fitur-fitur yang tersedia

## 🐛 Troubleshooting

### ❌ Problem: `soundness-cli: command not found`

```bash
# Solution 1: Update PATH
source ~/.bashrc

# Solution 2: Use full path
./target/release/soundness-cli --help

# Solution 3: Reinstall
curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash
```

### ❌ Problem: Build errors

```bash
# Install missing dependencies
sudo apt update
sudo apt install -y build-essential pkg-config libssl-dev

# Clean and rebuild
cd soundness-layer/soundness-cli
cargo clean
cargo build --release
```

### ❌ Problem: Permission denied

```bash
# Fix binary permissions
chmod +x ~/.local/bin/soundness-cli

# Or reinstall globally
sudo cp target/release/soundness-cli /usr/local/bin/
```

### ❌ Problem: Rust not found

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Verify installation
rustc --version && cargo --version
```

### 🔍 Debug Mode

```bash
# Run script dengan verbose output
bash -x install-soundness.sh

# Check syntax
bash -n install-soundness.sh
```

## 🌐 Community & Support

### 🔗 Official Links

- 🌍 **Website**: [soundness.xyz](https://soundness.xyz/)
- 💬 **Discord**: [Join Community](https://discord.gg/F4cGbdqgw8) 
- 📱 **Telegram**: [SoundnessLabs](https://t.me/SoundnessLabs)
- 🐦 **X/Twitter**: [@SoundnessLabs](https://x.com/SoundnessLabs)
- 📦 **GitHub**: [SoundnessLabs](https://github.com/SoundnessLabs/soundness-layer)

### 🎯 Getting Testnet Access

1. **Join Discord**: https://discord.gg/F4cGbdqgw8
2. **Go to #testnet-access** channel  
3. **Follow team instructions**
4. **Share your PUBLIC key** (bukan private key!)
5. **Wait for approval** dari team

### 💬 Community Guidelines

- ✅ **Ask questions** di Discord #support
- ✅ **Share experiences** di #general
- ✅ **Report bugs** di #bug-reports  
- ❌ **Jangan share private keys** di public
- ❌ **Jangan spam** community channels

## 🔒 Catatan Keamanan

### ⚠️ PENTING: Security Reminders

#### ✅ LAKUKAN:
- **Backup private keys** di tempat yang aman
- **Gunakan password kuat** untuk enkripsi key
- **Keep keys private** - jangan share ke publik
- **Gunakan testnet** untuk learning dan experiment
- **Join official channels** untuk support

#### ❌ JANGAN:
- **Share private keys** di Discord/Telegram/Public
- **Gunakan testnet keys** untuk mainnet (nanti)
- **Simpan keys** dalam plain text
- **Trust unofficial** installation sources  
- **Gunakan untuk production** (ini masih testnet)

### 📁 File Locations

```bash
# CLI Binary
~/.local/bin/soundness-cli

# Configuration & Keys (encrypted)
~/.soundness/keys/
~/.soundness/logs/

# Rust toolchain  
~/.cargo/bin/
```

### 💾 Backup Your Keys

```bash
# Create backup directory
mkdir -p ~/soundness-backup

# Copy keys (sudah ter-enkripsi)
cp ~/.soundness/keys/* ~/soundness-backup/

# Create archive
tar -czf soundness-backup-$(date +%Y%m%d).tar.gz ~/.soundness/keys/
```

## 📊 Installation Summary

| Component | Description | Size | Location |
|-----------|-------------|------|----------|
| **Rust Toolchain** | Compiler & package manager | ~150MB | `~/.cargo/` |
| **Dependencies** | Build tools, SSL libs | ~50MB | System |
| **Soundness CLI** | Main binary | ~5MB | `~/.local/bin/` |
| **Config** | Keys & logs | <1MB | `~/.soundness/` |

**Total**: ~200MB | **Install Time**: 3-5 minutes

## 🎯 What's Next?

Setelah installation berhasil:

1. **✅ Generate your first key**:
   ```bash
   soundness-cli generate-key
   ```

2. **✅ Join the community**:
   - Discord: https://discord.gg/F4cGbdqgw8

3. **✅ Explore features**:
   ```bash
   soundness-cli --help
   soundness-cli send --help
   ```

4. **✅ Request testnet access** di Discord

5. **✅ Start experimenting** dengan proofs dan transactions

6. **✅ Share pengalaman** Anda di community!

## 🤝 Contributing

Menemukan bug atau ingin improve tutorial ini?

1. **Fork repository** ini
2. **Create feature branch**: `git checkout -b feature/improvement`  
3. **Commit changes**: `git commit -m 'Add improvement'`
4. **Push branch**: `git push origin feature/improvement`
5. **Open Pull Request**

## 📄 License

Tutorial ini tersedia di bawah [MIT License](LICENSE).

Soundness Layer project memiliki lisensi sendiri - cek [official repository](https://github.com/SoundnessLabs/soundness-layer) untuk detail.

## ⭐ Support Project Ini

Jika tutorial ini membantu Anda:
- ⭐ **Star repository** ini  
- 🐦 **Share di social media**
- 💬 **Join Discord community**
- 🍴 **Fork dan contribute**
- 📝 **Share feedback** di Issues

## 🙏 Credits

- **Soundness Labs Team** - untuk amazing project
- **Community Contributors** - untuk feedback dan improvements  
- **GitHub Codespaces** - untuk awesome development environment

---

<div align="center">

**🚀 Happy Building on Soundness Layer! 🚀**

**Made with ❤️ for the Soundness Community**

[Website](https://soundness.xyz/) • [Discord](https://discord.gg/F4cGbdqgw8) • [GitHub](https://github.com/SoundnessLabs/soundness-layer)

**⚡ Start now**: `curl -sSL https://raw.githubusercontent.com/moree44/soundness-layer/main/install-soundness.sh | bash`

</div>
