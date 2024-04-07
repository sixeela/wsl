# Basic WSL configuration with systemd support
![Pipeline status](https://github.com/sixeela/wsl/actions/workflows/ansible-lint.yml/badge.svg)

# Installed packages after execution
- Fedora 39
- zsh (with oh-my-zsh) with following plugins: gitfast, zsh-autosuggestions, zsh-syntax-highlighting, terraform, kubectl, kubectx, zoxide, command-not-found, fzf, gitignore, helm, sudo
- pageant interconnect with Windows (with ssh configuration)
- yq
- kubectl
- kubens
- kubectx
- k9s
- glab
- git with basic configuration
- nodejs
- golang

# Requirements
- WSL2
- Windows Terminal
- Pageant (PuTTy CAC) for connection to servers

# Configure

## Prerequisites
```
wsl --install --no-distribution
```

```
Set-ExecutionPolicy RemoteSigned
```

## Setup 

Launch Powershell script in order to get and deploy latest Fedora version available
```sh
./scripts/install-fedora.ps1
```
Once the command as been issued, launch WSL distribution:
```sh
wsl --distribution Fedora-39
```
In the distribution, type following command (it will asks for several informations and install all required packages):
```sh
./script/post-install.sh
```

## Terminal customization

As we installed `Powerlevel10k`, it's mandatory to add the **needed fonts** according to the [documentation.](https://github.com/romkatv/powerlevel10k/blob/master/README.md)

It's possible to change the terminal configuration with the command `p10k configure`.

## Pageant

Once everything as been set-up correctly, restart WSL (open CMD > wsl --shutdown).
To start ssh_agent (only need to be done once, and at each WSL shutdown):
```sh
enable_ssh_agent
```
To start gpg_agent (only need to be done once, and at each WSL shutdown):
```sh
enable_gpg_agent
```
