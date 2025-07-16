# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Repository Overview

This is a Nix flake-based configuration repository managing both NixOS and
Darwin (macOS) systems using home-manager. The configuration follows a modular
architecture with clear separation between system configurations, home
configurations, and application-specific settings.

## Common Commands

### Development Environment

- `nix develop` - Enter development shell with all tools and LSPs configured
- `nix fmt` - Format all files using treefmt (runs nixfmt, stylua, shfmt, etc.)
- `nix flake check` - Run all pre-commit hooks and checks

### System Updates

- **macOS**: `nix run .#update -- <hostname>` - Update flake inputs and rebuild
  system
- **NixOS**: `nix run .#update` - Update all flake inputs and rebuild system
- **Individual**: `nix flake update <input>` - Update specific flake input

### Building and Switching

- **NixOS**: `sudo nixos-rebuild switch --flake .` - Apply configuration changes
- **Darwin**: `darwin-rebuild switch --flake .#<hostname> --impure` - Apply
  macOS configuration

### Secret Management

- `agenix -e secrets/<secret-file>.age` - Edit encrypted secrets
- `agenix -r` - Rekey all secrets after changing recipients

## Architecture Overview

### Directory Structure

- `/flake/parts/` - Flake modules defining system configurations and development
  environment
- `/hosts/` - Machine-specific configurations (desktop, laptop, work_darwin)
- `/settings/` - Shared configuration modules:
  - `common/` - Cross-platform configurations
  - `darwin/` - macOS-specific settings
  - `home/` - Home-manager configurations organized by platform and application
- `/secrets/` - Age-encrypted secrets managed with agenix

### Key Technologies

- **Nix Flakes** with flake-parts for modular organization
- **Home-manager** for user environment management
- **Agenix** for secret management
- **Treefmt** for multi-language formatting
- **Pre-commit hooks** for code quality checks

### Notable Configurations

- **Neovim**: Complex setup using dpp.vim plugin manager with custom
  Lua/TypeScript configurations in `settings/home/common/config/nvim/`
- **Window Manager**: XMonad configuration for Linux in
  `settings/home/linux/config/xmonad/`
- **Shell**: Zsh with p10k theme and sheldon plugin manager
- **Terminal**: Wezterm with custom configuration
- **MCP Integration**: Model Context Protocol servers for Claude AI assistance

### Development Tools Available in Shell

- Language servers: lua-language-server, vscode-json-languageserver,
  haskell-language-server
- Formatters: nixfmt, stylua, shfmt, hlint, yamlfmt, jsonfmt
- Linters: statix, deadnix, denolint, yamllint
- Utilities: tombi (TOML formatter), node2nix, git

### CI/CD

- **GitHub Actions**: Automated Claude code reviews on PRs
- **Renovate**: Daily dependency updates with automatic lock file maintenance
