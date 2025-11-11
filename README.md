# macOS Bootstrap

Automates the setup of a fresh macOS development machine with Homebrew, CLI tooling, GUI apps, shell configuration, and opinionated system defaults. The script is idempotent, so you can rerun it whenever you need to catch up on new changes.

## What the Script Does

- Installs Homebrew (if missing) and updates formulae
- Replaces stock macOS utilities with GNU versions and installs a curated list of CLI packages
- Installs GUI applications via Homebrew Cask
- Switches your login shell to `zsh`, installs Oh My Zsh, and installs the `marked` npm CLI globally
- Applies preferred macOS defaults (faster key repeat, tap-to-click, disable natural scrolling, etc.)

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/macos-bootstrap.git
cd macos-bootstrap
chmod +x osx_bootstrap.sh
./osx_bootstrap.sh
```

> The script will prompt for sudo several times (or once if you have passwordless sudo configured).

## Prerequisites

- A supported version of macOS (recent Sonoma/Ventura releases work best)
- Xcode Command Line Tools (you will be prompted to install them if they are missing)
- Administrator access

### Optional: Passwordless Sudo

```bash
echo "$(whoami)  ALL=(ALL) NOPASSWD: ALL" | sudo tee /private/etc/sudoers.d/$(whoami)
sudo chown root:wheel /private/etc/sudoers.d/$(whoami)
sudo chmod 0440 /private/etc/sudoers.d/$(whoami)
```

Or edit `/private/etc/sudoers.d/$(whoami)` manually, add the same line, and then ensure the file is owned by `root:wheel` with `0440` permissions—otherwise `sudo` will ignore it. **Only do this on a personal machine you control.**

## Installed Components

### CLI packages (`PACKAGES` array)
```
ack, age, autoconf, automake, awscli, azure-cli, broot,
docker-compose, fluxcd/tap/flux, gh, git, hub, jq, kind,
kubernetes-cli, markdown, minikube, node, npm, opentofu,
podman, pyenv, python, python3, pypy, rename, sops,
ssh-copy-id, the_silver_searcher, tree, vim, wget, xq,
zsh, zsh-completions
```

The script also installs the GNU core utilities (coreutils, gnu-sed, gnu-tar, gnu-indent, gnu-which, grep, findutils) and Homebrew’s latest Bash before the general package list runs.

### GUI apps (`CASKS` array)
```
alfred, flutter, google-chrome, iterm2, macdown, mqttx,
postman, rancher, sourcetree, sublime-text,
visual-studio-code, zoom
```

### Global npm tooling
```
npm install -g marked
```

### macOS defaults
- Fastest key repeat rate
- Require password immediately after the screensaver activates
- Show all filename extensions
- Enable tap-to-click
- Disable natural scrolling

## Customization

All behavior lives inside [osx_bootstrap.sh](osx_bootstrap.sh):

- Modify the `PACKAGES` array to add/remove CLI tools
- Update the `CASKS` array for GUI applications
- Adjust the `defaults write …` commands near the end for macOS preferences
- Comment out the Oh My Zsh / npm sections if you manage shells another way

## Visual Studio Code Extensions

Install every extension in `vsc-extensions.list` with:

```bash
xargs -n 1 code --install-extension < vsc-extensions.list
```

## Troubleshooting

- **Homebrew bootstrap fails** – Install it manually: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- **Cask install errors on Apple Silicon** – Some apps still require Rosetta 2: `softwareupdate --install-rosetta`
- **Xcode toolchain issues** – If you plan to install full Xcode, do it via the App Store first and accept the license before running this script

## References

- [DecampsRenan/dotfiles](https://raw.githubusercontent.com/DecampsRenan/dotfiles/master/macos/setup.sh)
- [dnsmichi/dotfiles](https://github.com/dnsmichi/dotfiles/blob/main/README.md)
- [codeinthehole’s setup guide](https://gist.github.com/codeinthehole/26b37efa67041e1307db)
- [Hacker’s Guide to Setting up Your Mac](http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac)

## License

MIT
