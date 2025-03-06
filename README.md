# Dotfiles

This repository contains my personal dotfiles for various command-line tools and applications.

## What are dotfiles?

Dotfiles are configuration files in Unix-like systems that customize your environment. They are called "dotfiles" because their filenames begin with a dot (e.g., `.bashrc`, `.vimrc`), which makes them hidden files in Unix-like operating systems.

## Included Configurations

This repository includes configurations for:

- **Shell**: `.bashrc`, `.bash_profile`, `.profile`, `.aliases`
- **Text Editor**: `.vimrc`
- **Version Control**: `.gitconfig`
- **Terminal Multiplexer**: `.tmux.conf`, `.screenrc`
- **Terminal/Console**: `.inputrc`, `.dircolors`, `.Xresources`

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
- Source your new `.bashrc` to apply changes immediately

## Customization

### Local Customizations

The setup creates a `.aliases.local` file in your home directory for machine-specific aliases that shouldn't be tracked in the repository.

You can also create local versions of other dotfiles that aren't tracked in git:
- `.bashrc.local` for local bash settings
- `.gitconfig.local` for local git settings (like user and email)

### Sensitive Information

Never commit sensitive information (API keys, passwords, private keys) to this repository, especially if it's public.

## Managing Your Dotfiles

### Add a New Dotfile

To add a new dotfile to be managed:

1. Add it to the repository
2. Add it to the `dotfiles` array in `setup.sh`
3. Run the setup script again

### Update Existing Dotfiles

Since these are symlinks, any changes you make to the files in your home directory will automatically update the files in the repository.

Remember to commit and push these changes:

```bash
cd ~/dotfiles
git add .
git commit -m "Update dotfiles"
git push
```

## License

Feel free to use and modify these dotfiles for your own personal use.

---
Based on recommendations from [MIT's Missing Semester](https://missing.csail.mit.edu/). 