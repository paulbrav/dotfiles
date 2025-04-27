# Dotfiles

This repository contains my personal dotfiles for various command-line tools and applications.

## What are dotfiles?

Dotfiles are configuration files in Unix-like systems that customize your environment. They are called "dotfiles" because their filenames begin with a dot (e.g., `.bashrc`, `.vimrc`), which makes them hidden files in Unix-like operating systems.

## Included Configurations

This repository includes configurations for:

- **Shell**: `.bashrc`, `.bash_profile`, `.profile`, `.aliases`
- **Text Editor**: `.vimrc`, `.nanorc`
- **IDE/Editor**: VS Code (`vscode/settings.json`)
- **Version Control**: `.gitconfig`
- **Terminal Multiplexer**: `.tmux.conf`, `.screenrc`
- **Terminal/Console**: `.inputrc`, `.dircolors`, `.Xresources`
- **Debugging**: `.gdbinit`
- **Neovim**: `init.lua` (via `~/.config/nvim/init.lua` symlink)
- **AI Chat CLI**: `aichat` (via `~/.config/aichat/config.yaml` symlink)

## Installation

To install these dotfiles on a new system:

1. Clone this repository to your home directory:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
```

2. Run the setup script:
```bash
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Create symlinks from your home directory to the dotfiles in this repository
- Back up any existing dotfiles to `~/dotfiles_backup_[timestamp]`
- Set up GDB with pretty printers and a local configuration file.
- Set up Neovim by symlinking the `init.lua` configuration file.
- Set up AIChat by symlinking the `config.yaml` configuration file.
- Set up VS Code global settings by symlinking the `vscode/settings.json` file.
- Source your new `.bashrc` to apply changes immediately

## Application Specific Setup

### VS Code / Cursor

The setup script configures global VS Code and Cursor settings by:
- Identifying the standard user settings directories for both editors (e.g., `~/.config/Code/User` and `~/.config/cursor/User` on Linux; `~/Library/Application Support/Code/User` and `~/Library/Application Support/Cursor/User` on macOS).
- Ensuring these directories exist.
- Symlinking the `vscode/settings.json` file from this repository to the global `settings.json` within each detected editor's configuration directory.

**Key settings include:**
- **General**: Trim trailing whitespace, insert final newline, format on save.
- **Remote SSH**: Disables file locking (`remote.SSH.useFlock: false`) to potentially resolve issues with certain SSH targets (like Stanford's Myth machines).
- **C/C++**: Indentation (4 spaces), rulers (120 chars) based on Stanford CS107 guide (note: C++ defaults to 4 spaces here for consistency with the provided C guide, deviating from Google C++ style's 2 spaces).
- **Python**: Indentation (4 spaces), rulers (120 chars), default formatter set to Ruff (`charliermarsh.ruff`), format/fix/organize imports on save using Ruff, based on Google Style Guide and user preferences (Ruff, MyPy).

**Requirements:**
- For Python formatting/linting, ensure the [Ruff VS Code extension](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff) is installed (works in Cursor too).
- For Python type checking, ensure the [MyPy Type Checker extension](https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker) is installed (works in Cursor too) and configured (often via `pyproject.toml`).
- For C/C++, consider installing the [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack) (works in Cursor too).

### GDB

The setup script configures GDB by:
- Symlinking the main `.gdbinit` file.
- Downloading standard C++ library pretty printers to `~/.gdb/python/printers.py` (if not already present).
- Creating an empty `~/.gdbinit.local` file for machine-specific GDB commands that won't be tracked by git.

### Neovim (nvim)

The setup script configures Neovim by:
- Ensuring the `~/.config/nvim` directory exists.
- Symlinking the `init.lua` file from this repository to `~/.config/nvim/init.lua`.
- **Note:** The first time you run `nvim` after setup, the `lazy.nvim` plugin manager will automatically install the plugins specified in `init.lua`. This might take a moment.

### AIChat

The setup script configures [AIChat](https://github.com/sigoden/aichat), an all-in-one LLM CLI tool, by:
- Ensuring the `~/.config/aichat` directory exists.
- Symlinking the `config.yaml` file from this repository (`config/aichat/config.yaml`) to `~/.config/aichat/config.yaml`.

**Installation:**

You need to install `aichat` separately. Follow the instructions on the [AIChat GitHub Releases page](https://github.com/sigoden/aichat/releases) or use a package manager if available (e.g., `brew install aichat`, `cargo install aichat`, `pacman -S aichat`).

**Configuration:**

- The linked `config.yaml` is pre-configured to use a local Ollama instance (edit the IP `192.268.164.19` in `config/aichat/config.yaml` if needed, or preferably set an environment variable like `AICHAT_OLLAMA_HOST`).
- **API Keys:** For cloud providers like Anthropic (Claude), Google (Gemini), OpenAI, Mistral, Groq, or Perplexity, **do not hardcode keys in the config file**. Instead, set the relevant environment variables in your *local*, *uncommitted* shell configuration (e.g., `~/.bashrc.local`, `~/.zshrc.local`, etc.).

  **Example `~/.bashrc.local` (or equivalent - DO NOT COMMIT THIS FILE):**
  ```bash
  #!/bin/bash
  # Local, machine-specific shell configuration - NOT committed to Git.

  # AIChat API Keys
  export ANTHROPIC_API_KEY="your_anthropic_api_key"
  export GEMINI_API_KEY="your_gemini_api_key"
  export OPENAI_API_KEY="your_openai_api_key"
  export MISTRAL_API_KEY="your_mistral_api_key"
  export GROK_API_KEY="your_grok_api_key"
  export PERPLEXITY_API_KEY="your_perplexity_api_key"

  # Optional: If using env var for Ollama host instead of hardcoding in config.yaml
  # export AICHAT_OLLAMA_HOST="http://192.168.1.XX:11434"
  ```
  Remember to create this file if it doesn't exist and source it in your main shell config (e.g., add `source ~/.bashrc.local` to the end of `~/.bashrc`). Adjust the filename and sourcing method based on your shell (bash, zsh, fish, etc.).

  `aichat` will automatically pick up these standard environment variables when you uncomment the corresponding client sections in `config/aichat/config.yaml`.

**Updating:**

If you installed `aichat` using `cargo`, you can update it by running:
```bash
cargo install --force aichat
```
Check the [AIChat GitHub Releases](https://github.com/sigoden/aichat/releases) page for updates if you used another installation method.

## Customization