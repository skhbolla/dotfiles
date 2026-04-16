" --- Basic Setup ---
set nocompatible
filetype plugin indent on
syntax on
set mouse=a

" --- Plugins (vim-plug) ---
call plug#begin('~/.vim/plugged')

" The Essentials
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocomplete/LSP
Plug 'preservim/nerdtree'                       " File Explorer
Plug 'voldikss/vim-floaterm'                    " Floating Terminal
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy Finder
Plug 'junegunn/fzf.vim'

" Visuals & UI
Plug 'vim-airline/vim-airline'                  " Status Bar
Plug 'ryanoasis/vim-devicons'                   " File Icons

" Programming Power-Tools
Plug 'tpope/vim-commentary'                     " Commenting (gcc)
Plug 'tpope/vim-surround'                       " Quoting/Parenthesis
Plug 'jiangmiao/auto-pairs'                     " Auto-close brackets
Plug 'sheerun/vim-polyglot'                     " Better Syntax for 100+ languages

" Colorscheme
Plug 'sainnhe/sonokai'

call plug#end()

" --- Core Editor Settings ---
set number relativenumber       " Hybrid line numbers
set hidden                      " Switch buffers without saving
set mouse=a                     " Use mouse for scrolling/resizing
set splitright                  " Vertical splits open to the right
set splitbelow                  " Horizontal splits open below
set expandtab                   " Spaces instead of tabs
set shiftwidth=4                " Indent by 4 spaces
set tabstop=4                   " Tab width
set signcolumn=yes              " Always show sign column (for CoC icons)
set ignorecase smartcase        " Search intelligence
set termguicolors               " High-color support

" --- Colorscheme Configuration ---
  
" sonokai-theme
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_better_performance = 1
colorscheme sonokai

" Airline
let g:airline_theme = 'sonokai'

" --- Keybindings (The Standard) ---
let mapleader = " "

" File Navigation (NERDTree)
nnoremap <C-n> :NERDTreeToggle<CR>

" Fuzzy Finder (FZF)
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Floating Terminal
nnoremap <silent> <C-t> :FloatermToggle<CR>
tnoremap <silent> <C-t> <C-\><C-n>:FloatermToggle<CR>
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" --- CoC / LSP Configuration ---
" Standard Tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 1. Only confirm if a selection is actively highlighted
" 2. Otherwise, just behave like a normal Enter key
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Go-To commands (Standard across all power-user configs)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Standard Symbol Rename
nmap <leader>rn <Plug>(coc-rename)

" Documentation (K opens a hover window)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

