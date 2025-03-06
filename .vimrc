" Basic .vimrc configuration
" Enable syntax highlighting
syntax on

" Set color scheme
colorscheme desert

" Show line numbers
set number

" Enable mouse support
set mouse=a

" Set tab width to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Enable auto-indentation
set autoindent
set smartindent

" Highlight search results
set hlsearch
set incsearch

" Enable file type detection
filetype plugin indent on

" Show matching brackets
set showmatch

" Enable line wrapping
set wrap

" Use system clipboard
set clipboard=unnamedplus

" Show cursor position
set ruler

" Enable command-line completion
set wildmenu
set wildmode=list:longest,full

" Disable backup files
set nobackup
set nowritebackup
set noswapfile

" Set encoding
set encoding=utf-8

" Allow backspacing over autoindent, line breaks, and start of insert
set backspace=indent,eol,start 