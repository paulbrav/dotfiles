#!/bin/bash

# Setup script for dotfiles
# This script creates symlinks from the home directory to the dotfiles in ~/dotfiles

# Variables
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"
GDB_DIR="$HOME/.gdb"
EMACS_DIR="$HOME/.emacs.d"

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
mkdir -p "$HOME/.config/nvim"
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