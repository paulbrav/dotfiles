#!/bin/bash

# Setup script for dotfiles
# This script creates symlinks from the home directory to the dotfiles in ~/dotfiles

# Variables
# Use the directory where the script is located as the dotfiles repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$SCRIPT_DIR/dotfiles_backup_$(date +%Y%m%d%H%M%S)"
GDB_DIR="$HOME/.gdb"
EMACS_DIR="$HOME/.emacs.d"
CONFIG_DIR="$HOME/.config"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Introduction
echo -e "${BLUE}Setting up dotfiles from ${DOTFILES_DIR}${NC}"
echo -e "${YELLOW}Any existing dotfiles will be backed up to ${BACKUP_DIR}${NC}"
echo

# Create necessary directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$GDB_DIR/python"
mkdir -p "$EMACS_DIR/backups"
mkdir -p "$EMACS_DIR/auto-save-list"
mkdir -p "$CONFIG_DIR/nvim" # Neovim
mkdir -p "$CONFIG_DIR/aichat" # AIChat
echo -e "${GREEN}✓ Created required directories${NC}"

# Create Neovim config directory
mkdir -p "$HOME/.config/nvim"
echo -e "${GREEN}✓ Ensured Neovim config directory exists (~/.config/nvim)${NC}"

# List of files/folders to symlink in homedir
dotfiles=(
    .aliases
    .bashrc
    .bash_profile
    .dircolors
    .gitconfig
    .inputrc
    .profile
    .screenrc
    .tmux.conf
    .vimrc
    .Xresources
    .emacs
    .spacemacs
    .gdbinit
    .nanorc
)

# Function to create symlink
create_symlink() {
    local file=$1
    local source="${DOTFILES_DIR}/${file}"
    local target="${HOME}/${file}"
    
    # Skip if the source file doesn't exist
    if [ ! -e "$source" ]; then
        echo -e "${YELLOW}Skipping ${file} - not found in ${DOTFILES_DIR}${NC}"
        return
    fi
    
    # If the file exists and is not a symlink or is a symlink that points to a different location
    if [ -e "$target" ] || [ -L "$target" ]; then
        # Make backup
        mv "$target" "${BACKUP_DIR}/${file}"
        echo -e "${YELLOW}Backed up existing ${file} to ${BACKUP_DIR}/${file}${NC}"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Created symlink for ${file}${NC}"
}

# Function to create symlink for VS Code settings
create_vscode_settings_symlink() {
    local vscode_settings_dir_linux="$HOME/.config/Code/User"
    local vscode_settings_dir_macos="$HOME/Library/Application Support/Code/User"
    local cursor_settings_dir_linux="$HOME/.config/cursor/User" # Typical Cursor path
    local cursor_settings_dir_macos="$HOME/Library/Application Support/Cursor/User" # Typical Cursor path
    local vscode_settings_file="settings.json"
    local source_file="${DOTFILES_DIR}/vscode/${vscode_settings_file}"
    local targets=()

    # Determine target directories based on OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        targets+=("${vscode_settings_dir_linux}/${vscode_settings_file}")
        targets+=("${cursor_settings_dir_linux}/${vscode_settings_file}")
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        targets+=("${vscode_settings_dir_macos}/${vscode_settings_file}")
        targets+=("${cursor_settings_dir_macos}/${vscode_settings_file}")
    else
        echo -e "${YELLOW}Warning: Unsupported OS detected ($OSTYPE). Attempting Linux paths for VS Code/Cursor settings.${NC}"
        targets+=("${vscode_settings_dir_linux}/${vscode_settings_file}")
        targets+=("${cursor_settings_dir_linux}/${vscode_settings_file}")
    fi

    echo
    echo -e "${BLUE}Setting up VS Code / Cursor global settings...${NC}"

    # Check if source exists
    if [ ! -f "$source_file" ]; then
        echo -e "${YELLOW}Skipping VS Code/Cursor settings - Source file ${source_file} not found.${NC}"
        return
    fi

    # Process each target path
    for target_file in "${targets[@]}"; do
        local target_dir
        target_dir=$(dirname "$target_file")
        local editor_name="VS Code"
        if [[ "$target_dir" == *"cursor"* ]]; then
            editor_name="Cursor"
        fi
        
        # Check if the base directory might exist (heuristic)
        # Don't attempt to link if the parent config dir (e.g., ~/.config/cursor) doesn't seem present
        if [ ! -d "$(dirname "$target_dir")" ]; then
             echo -e "${YELLOW}Skipping ${editor_name} setup - Base directory $(dirname "$target_dir") not found.${NC}"
             continue
        fi

        # Create the target directory if it doesn't exist
        mkdir -p "$target_dir"

        # Backup existing settings.json if it exists and isn't already the correct symlink
        if [ -e "$target_file" ] || [ -L "$target_file" ]; then
            if [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$source_file" ]; then
                echo -e "${GREEN}✓ ${editor_name} settings.json already linked correctly to ${source_file}.${NC}"
                continue # Already done for this target
            else
                local backup_target="${BACKUP_DIR}/${editor_name,,}_${vscode_settings_file}" # e.g., cursor_settings.json
                mv "$target_file" "$backup_target"
                echo -e "${YELLOW}Backed up existing ${editor_name} settings to ${backup_target}${NC}"
            fi
        fi

        # Create the symlink
        ln -s "$source_file" "$target_file"
        echo -e "${GREEN}✓ Created symlink for ${editor_name} global settings.json -> ${source_file}${NC}"
    done

    echo -e "${YELLOW}Note: You might need to restart VS Code and/or Cursor for all settings to apply.${NC}"
}

# Create symlinks
for file in "${dotfiles[@]}"; do
    create_symlink "$file"
done

# Setup Neovim symlink
echo
echo -e "${BLUE}Setting up Neovim configuration...${NC}"
NVIM_SOURCE="${DOTFILES_DIR}/init.lua"
NVIM_TARGET="${HOME}/.config/nvim/init.lua"
BACKUP_NVIM_TARGET="${BACKUP_DIR}/init.lua"

if [ -e "$NVIM_SOURCE" ]; then
    if [ -e "$NVIM_TARGET" ] || [ -L "$NVIM_TARGET" ]; then
        mv "$NVIM_TARGET" "$BACKUP_NVIM_TARGET"
        echo -e "${YELLOW}Backed up existing Neovim init.lua to ${BACKUP_NVIM_TARGET}${NC}"
    fi
    ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
    echo -e "${GREEN}✓ Created symlink for Neovim init.lua${NC}"
else
    echo -e "${YELLOW}Skipping Neovim setup - init.lua not found in ${DOTFILES_DIR}${NC}"
fi

# Setup AIChat symlink
echo
echo -e "${BLUE}Setting up AIChat configuration...${NC}"
AICHAT_SOURCE="${DOTFILES_DIR}/config/aichat/config.yaml"
AICHAT_TARGET="${CONFIG_DIR}/aichat/config.yaml"
BACKUP_AICHAT_TARGET="${BACKUP_DIR}/aichat_config.yaml"

# Check if the target file exists and warn about potential manual edits/keys
if [ -f "$AICHAT_TARGET" ] && [ ! -L "$AICHAT_TARGET" ]; then
    echo -e "${YELLOW}Warning: Existing file found at ${AICHAT_TARGET}.${NC}"
    echo -e "${YELLOW}This script will back it up to ${BACKUP_AICHAT_TARGET} before creating a symlink.${NC}"
    echo -e "${YELLOW}Ensure any sensitive information (like API keys) previously in this file is stored securely (e.g., environment variables), as the symlinked version from your dotfiles should not contain secrets.${NC}"
    read -p "Press Enter to continue or Ctrl+C to abort..." </dev/tty # Read from controlling terminal
fi

if [ -e "$AICHAT_SOURCE" ]; then
    if [ -e "$AICHAT_TARGET" ] || [ -L "$AICHAT_TARGET" ]; then
# Only backup if it's not already the correct symlink
        if [ -L "$AICHAT_TARGET" ] && [ "$(readlink "$AICHAT_TARGET")" == "$AICHAT_SOURCE" ]; then
            echo -e "${GREEN}✓ AIChat symlink already points to the correct location.${NC}"
        else
            mv "$AICHAT_TARGET" "$BACKUP_AICHAT_TARGET"
            echo -e "${YELLOW}Backed up existing AIChat config to ${BACKUP_AICHAT_TARGET}${NC}"
            ln -s "$AICHAT_SOURCE" "$AICHAT_TARGET"
            echo -e "${GREEN}✓ Created symlink for AIChat config.yaml${NC}"
        fi
    else
        ln -s "$AICHAT_SOURCE" "$AICHAT_TARGET"
        echo -e "${GREEN}✓ Created symlink for AIChat config.yaml${NC}"
    fi
else
    echo -e "${YELLOW}Skipping AIChat setup - config/aichat/config.yaml not found in ${DOTFILES_DIR}${NC}"
fi

# Setup VS Code settings symlink
create_vscode_settings_symlink

# Setup GDB pretty printers
echo
echo -e "${BLUE}Setting up GDB pretty printers...${NC}"
if [ ! -f "$GDB_DIR/python/printers.py" ]; then
    wget -q -P "$GDB_DIR/python" https://raw.githubusercontent.com/gcc-mirror/gcc/master/libstdc%2B%2B-v3/python/libstdcxx/v6/printers.py
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Downloaded GDB pretty printers${NC}"
    else
        echo -e "${RED}✗ Failed to download GDB pretty printers${NC}"
    fi
fi

# Create empty .gdbinit.local if it doesn't exist
if [ ! -f "${HOME}/.gdbinit.local" ]; then
    touch "${HOME}/.gdbinit.local"
    echo -e "${GREEN}✓ Created .gdbinit.local for machine-specific GDB settings${NC}"
fi

# Source the new dotfiles
echo
echo -e "${BLUE}Sourcing the new dotfiles...${NC}"
if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
    echo -e "${GREEN}✓ Sourced .bashrc${NC}"
fi

# Create local aliases file if it doesn't exist
if [ ! -f "${HOME}/.aliases.local" ]; then
    touch "${HOME}/.aliases.local"
    echo -e "${GREEN}✓ Created .aliases.local for machine-specific aliases${NC}"
fi

# Add comment about updating aichat if installed via cargo
echo
echo -e "${BLUE}Checking for common tool updates...${NC}"
if command -v cargo &> /dev/null && cargo install --list | grep -q aichat; then
    echo -e "${YELLOW}Note: To update AIChat (installed via cargo), run: cargo install --force aichat${NC}"
fi

# Check if Spacemacs is installed
if [ ! -d "$HOME/.emacs.d" ]; then
    echo
    echo -e "${BLUE}Setting up Spacemacs...${NC}"
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Installed Spacemacs${NC}"
    else
        echo -e "${RED}✗ Failed to install Spacemacs${NC}"
    fi
fi

echo
echo -e "${GREEN}✓ Dotfiles setup complete!${NC}"
echo -e "${YELLOW}Notes:${NC}"
echo -e "${YELLOW}1. You may need to log out and log back in for all changes to take effect.${NC}"
echo -e "${YELLOW}2. For Emacs/Spacemacs, first launch may take a few minutes to install packages.${NC}"
echo -e "${YELLOW}3. For GDB, ensure you have GDB 7.0+ installed for pretty printing support.${NC}"
echo -e "${YELLOW}4. For Neovim, first launch will install plugins defined in init.lua (may take a moment).${NC}"
echo -e "${YELLOW}5. For AIChat, ensure you have installed the tool and set necessary API key environment variables (e.g., ANTHROPIC_API_KEY, GEMINI_API_KEY, OPENAI_API_KEY, MISTRAL_API_KEY, GROQ_API_KEY, PERPLEXITY_API_KEY, etc.) in your local shell config (.bashrc.local, etc.).${NC}"
echo -e "${YELLOW}6. For VS Code/Cursor, global settings have been linked. Restart the application(s) if needed.${NC}" 