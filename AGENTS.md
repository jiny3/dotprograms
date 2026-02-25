# AGENTS.md

## Project Overview

This is a **Bash-based dotfiles/program management repository** ("dotprograms") for
provisioning Arch Linux and macOS systems. It contains no application source code --
only shell scripts that install/uninstall system programs and tools across 5 categories:
`system/`, `terminal/`, `desktop/`, `apps/`, and `dev/`.

Documentation (README, description files, comments) is written in **Chinese (Simplified)**.

## Repository Structure

```
dotprograms/
├── install.sh              # Master install script (detects OS, installs all programs)
├── system/                 # System-level tools (paru, brew, fcitx5, font, etc.)
├── terminal/               # Terminal environment (zsh, neovim, tmux, ghostty, etc.)
├── desktop/                # Wayland desktop components (Arch-only: niri, flatpak, etc.)
├── apps/                   # GUI applications (Arch-only: discord, steam, etc.)
└── dev/                    # Developer tools (go, uv)
```

Each program directory contains: `description`, `install_arch.sh`, `uninstall_arch.sh`,
and optionally `install_mac.sh` / `uninstall_mac.sh` for cross-platform programs.

## Commands

### Full Installation

```bash
./install.sh
```

Detects the OS automatically. On Arch, installs everything. On macOS, installs only
programs that have `install_mac.sh`.

### Install/Uninstall a Single Program

```bash
# Install
bash terminal/neovim/install_arch.sh
bash terminal/neovim/install_mac.sh

# Uninstall
bash terminal/neovim/uninstall_arch.sh
```

### Build / Lint / Test

There is **no build system, linter, or test framework** configured. This is a pure
shell script repository. If you want to validate scripts, use `shellcheck`:

```bash
# Lint a single script
shellcheck terminal/neovim/install_arch.sh

# Lint all scripts
find . -name '*.sh' -exec shellcheck {} +
```

## Shell Script Style Guide

### Shebang and Strict Mode

- Every `.sh` file starts with `#!/bin/bash`
- The master `install.sh` uses strict mode: `set -euo pipefail`
- Individual program scripts do NOT use `set -euo pipefail`

### Package Installation Patterns

**Arch Linux:**
```bash
#!/bin/bash
paru -S --noconfirm --needed <package-name>       # install
paru -Rns --noconfirm <package-name>               # uninstall
```

**macOS:**
```bash
#!/bin/bash
brew install <package-name>           # CLI tool
brew install --cask <package-name>    # GUI app
```

**Multiple packages** -- use backslash continuation:
```bash
paru -S --noconfirm --needed bat \
    eza \
    fd \
    fzf
```

### Comments

- Use `#` comments for non-obvious logic
- Comments explaining dependencies or rationale are in Chinese or English
- Example: `# luarocks: image.nvim required`
- Example: `# 添加 Flathub 仓库（如果尚未添加）`

### Variables and Functions (install.sh conventions)

- Use `readonly` for constants: `readonly RED='\033[0;31m'`
- Use `local` for function-scoped variables: `local os_type="$1"`
- Use namerefs (`local -n`) for passing arrays by reference
- Quote all variable expansions: `"${variable}"`
- Use `[[ ]]` for conditionals (not `[ ]`)
- Use `$(command)` for command substitution (not backticks)
- Functions use lowercase_snake_case naming

### Logging and Error Handling

`install.sh` provides `info()`, `success()`, `error()`, `warn()` -- all print to stderr.

- Functions return non-zero on failure (`return 1`)
- Main script exits with code 1 if any program fails to install
- Use `command -v` to check if a command exists
- Use conditional checks before operations: `[[ -f "${path}" ]]`, `[[ -x "${path}" ]]`

### File Permissions

All `.sh` scripts must be executable (`chmod +x`). The master installer checks for
this and will error if a script lacks execute permission.

## Adding a New Program

1. Create directory under the correct category: `mkdir -p terminal/mynewapp`
2. Add `description` file (one line, Chinese): `echo "简短描述" > terminal/mynewapp/description`
3. Add `install_arch.sh` with `#!/bin/bash` shebang and `paru -S --noconfirm --needed` command
4. Add `uninstall_arch.sh` with `#!/bin/bash` shebang and `paru -Rns --noconfirm` command
5. `chmod +x` all `.sh` files
6. Add `install_mac.sh` / `uninstall_mac.sh` only if the program supports macOS

## Platform Rules

- `desktop/` and `apps/` categories are **Arch Linux only** -- never add `install_mac.sh`
  to these directories
- `system/`, `terminal/`, and `dev/` may support both platforms
- The master installer priority order: `paru`/`brew` first, then `flatpak`, then everything else

## Git Conventions

- **Commit messages:** Short, lowercase, imperative style
  - `add <program-name>` for new programs
  - `fix <description>` for bug fixes
  - `update` or `update <target>` for modifications
- **Branch:** `main`
- **Remote:** GitHub (`jiny3/dotprograms`)

## Key Gotchas

- No CI/CD pipeline exists -- changes are not automatically validated
- No `.editorconfig` -- maintain consistency manually (spaces, not tabs; LF line endings)
- The `description` file is plain text with no shebang and no trailing newline required
- Scripts that need post-install setup (e.g., changing default shell, adding repos)
  include that logic directly in the install script
