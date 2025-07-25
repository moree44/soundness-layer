# Soundness Layer

![Soundness Layer Banner](banner.png)

Soundness Layer is a decentralized verification layer that provides low latency, high throughput, and cross-chain compatibility for blockchain networks. Built on [Walrus](https://www.walrus.xyz/) for data availability and [Sui](https://sui.io/) for sequencing, it delivers a robust infrastructure for data verification. The network's security is maintained through an innovative restaking protocol.

[Twitter (X)](https://x.com/SoundnessLabs) | [Discord](https://discord.gg/SoundnessLabs) | [Telegram](https://t.me/SoundnessLabs) | [Website](https://soundness.xyz/)

> ⚠️ **Warning**: This is a testnet implementation. Do not use in production. The protocol is still under development and may contain bugs or security vulnerabilities. We are gradually rolling out features and open sourcing components as we progress through our development roadmap.

## License

This project is licensed under the [MIT License](./LICENSE).

## Beginner Installation Tutorial

Follow these steps to install Soundness CLI on Linux/WSL:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/moree44/soundness-layer.git
   cd soundness-layer
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install-soundness.sh
   ./install-soundness.sh
   ```
   This script will:
   - Install required dependencies (curl, wget, git, build-essential, pkg-config, libssl-dev)
   - Install Rust (if not already installed)
   - Build the Soundness CLI
   - Add the binary to your PATH for global access
   - Create configuration directories at `~/.soundness`

3. **Verify the installation:**
   After installation, check with the following commands:
   ```bash
   soundness-cli --version
   soundness-cli --help
   ```

4. **Next steps:**
   - Generate a new key:
     ```bash
     soundness-cli generate-key
     ```
   - List your keys:
     ```bash
     soundness-cli list-keys
     ```

5. **Notes:**
   - If the `soundness-cli` command is not recognized, try opening a new terminal or run:
     ```bash
     source ~/.bashrc
     ```
   - Make sure `~/.local/bin` is included in your PATH.

6. **Testnet Information:**
   - Default endpoint: https://testnet.soundness.xyz
   - Discord: https://discord.gg/F4cGbdqgw8
   - Telegram: https://t.me/SoundnessLabs
   - Website: https://soundness.xyz/

7. **Security:**
   - Backup your private key securely
   - Never share your private key
   - This is for testnet only, not for production
