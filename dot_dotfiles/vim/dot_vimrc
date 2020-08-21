"
"    ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄  
"   ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█  
"    ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄ 
"     ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"      ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"      ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"      ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒   
"        ░░   ▒ ░░      ░     ░░   ░ ░        
"         ░   ░         ░      ░     ░ ░      

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Visual Setting
set number

" Encoding
set ttyfast
set binary

" Tabs, May be overwritten by autocmd rules
set shiftwidth=2
set softtabstop=0
set tabstop=2
set expandtab

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
else
  set autoindent    " always set autoindenting on
endif " has("autocmd")

let mapleader=","
" Copy in Normal mode to xclip
nmap <leader>y "+yE
" Copy in Visual mode to xclip
vmap <leader>y "+y

" for vim 8
if (has("termguicolors"))
  set termguicolors
  " This is only necessary if you use "set termguicolors".
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Colors
source ~/.vim/colorscheme

" Plugins
source ~/.vim/plugin-configs.vim

" If there are a custom lightline setting by theme
let x = "~/.vim/lightline-theme.vim"

if filereadable(expand(x))
  execute 'source' x
endif
