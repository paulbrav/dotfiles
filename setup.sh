#!/bin/bash

# Setup script for dotfiles
# This script creates symlinks from the home directory to the dotfiles in ~/dotfiles

# Variables
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d%H%M%S)"

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

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}✓ Created backup directory${NC}"

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

echo
echo -e "${GREEN}✓ Dotfiles setup complete!${NC}"
echo -e "${YELLOW}Note: You may need to log out and log back in for all changes to take effect.${NC}" 