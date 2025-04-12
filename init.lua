-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- List your plugins here
  -- Example: A colorscheme
  { "folke/tokyonight.nvim", priority = 1000, config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },

  -- Add more plugins below
  -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- { "neovim/nvim-lspconfig" },
  -- { "hrsh7th/nvim-cmp" }, -- Autocompletion
  -- { "hrsh7th/cmp-nvim-lsp" },
  -- { "L3MON4D3/LuaSnip" }, -- Snippets

}, {
  -- Configure lazy.nvim options here if needed
  -- ui = {
  --  border = "rounded",
  -- },
})

-- Basic Neovim settings (consider moving to a separate file like lua/core/options.lua)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.fn.system("mkdir -p " .. vim.fn.stdpath("data") .. "/undodir")

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic keymaps (consider moving to a separate file like lua/core/keymaps.lua)
-- Example: Map <leader>pv to open file explorer
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

print("Neovim config loaded!") 