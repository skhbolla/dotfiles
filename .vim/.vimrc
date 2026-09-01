" ============================================================================
" 1. SYSTEM INITIALIZATION
" ============================================================================
set nocompatible
filetype plugin indent on
syntax on

let mapleader = " "
" ============================================================================
" 2. PLUGIN MANAGEMENT (Vim-Plug)
" ============================================================================
call plug#begin('~/.vim/plugged')

" Core IDE & Navigation
Plug 'neoclide/coc.nvim', {'branch': 'release'}       " Autocomplete / LSP Engine
Plug 'preservim/nerdtree'                             " File Explorer Sidebar
Plug 'voldikss/vim-floaterm'                          " Toggleable Floating Terminal
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }   " Fuzzy Finder CLI
Plug 'junegunn/fzf.vim'                               " Vim Wrapper for FZF

" Language & Syntax Support
Plug 'sheerun/vim-polyglot'                           " Universal Syntax Pack

" Coding Productivity Tools
Plug 'tpope/vim-commentary'                           " Code commenting (gcc / gc)
Plug 'tpope/vim-surround'                             " Wrap text in quotes/brackets
Plug 'jiangmiao/auto-pairs'                           " Automatic bracket closure

" UI Aesthetics
Plug 'sainnhe/sonokai'                                " Color scheme
Plug 'vim-airline/vim-airline'                        " Informative Status Line
Plug 'ryanoasis/vim-devicons'                         " File icons (Requires Nerd Font)

call plug#end()

" ============================================================================
" 3. CORE EDITOR SETTINGS
" ============================================================================
" Display & Interface
set number relativenumber       " Hybrid line numbering (relative + absolute)
set signcolumn=yes              " Always display the sign column for LSP icons
set termguicolors               " True color support in modern terminals
set mouse=a                     " Enable full mouse integration
set hidden                      " Allow background buffers without writing to disk
set updatetime=300              " Faster LSP diagnostic update frequency (default 4000ms)

" Split Management
set splitright                  " Open vertical splits to the right
set splitbelow                  " Open horizontal splits below the current file

" Searching Intelligence
set ignorecase                  " Case-insensitive search queries...
set smartcase                   " ...unless an uppercase character is typed
set hlsearch                    " Keep match highlighting visible

" Global Indentation (Fallback defaults)
set expandtab                   " Insert spaces instead of hard tabs
set tabstop=4                   " Visual width of a tab character
set shiftwidth=4                " Number of spaces used for auto-indentation

" Code Folding & Performance Fixes
set foldmethod=indent           " Fast, lightweight indentation folding
set foldlevelstart=999          " Leave folds open by default when a file opens
set scrolloff=8                 " Keep 8 lines visible above/below cursor margin
set sidescrolloff=8             " Keep 8 columns visible left/right cursor margin

" ============================================================================
" 4. LANGUAGE-SPECIFIC CONFIGURATION (Overrides)
" ============================================================================
augroup LanguageOverrides
  autocmd!
  " Go Language Rules (Strict physical tabs + auto-organize imports on save)
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" ============================================================================
" 5. THEME & VISUAL CONFIGURATION
" ============================================================================
" Sonokai Design Setup
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_better_performance = 1
colorscheme sonokai

" Airline Status Bar
let g:airline_theme = 'sonokai'

" Floating Terminal Dimensions
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

" ============================================================================
" 6. POWER-USER KEYBINDINGS & NAVIGATION
" ============================================================================
" General Mapping Fixes
nnoremap <silent> <Esc> :noh<CR> " Clear active search highlights by hitting Esc

" Safe Terminal Escape (Prevents breaking interactive CLI apps like lazygit/htop)
tnoremap <C-Esc> <C-\><C-n>

" Window Navigation (Move between splits using Ctrl + hjkl instead of Ctrl-w + hjkl)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File Explorer Toggle (Freed up Ctrl-n for native Vim operations)
nnoremap <leader>e :NERDTreeToggle<CR>

" Fast Buffer Management (Crucial since we have 'set hidden' active)
nnoremap <leader>q :bd<CR>        " Close current buffer/file without closing window
nnoremap <S-Tab> :bnext<CR>       " Shift-Tab cycles to the next open file

" Floating Terminal Toggle
nnoremap <silent> <leader>t :FloatermToggle<CR>
tnoremap <silent> <leader>t <C-\><C-n>:FloatermToggle<CR>

" Fuzzy Finder Navigation
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>

" ============================================================================
" 7. COC.NVIM / LSP CONFIGURATION & MAPPINGS
" ============================================================================
" Intelligent Auto-Completion (Tab Engine)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Enter Key Confirmation Policy
" 1. Confirms ONLY when a choice is explicitly chosen from menu
" 2. Otherwise acts as a standard carriage return
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Source Code Navigation Mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Mass Refactoring
nmap <leader>rn <Plug>(coc-rename)

" Documentation Context Lookup (Press K on a keyword)
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

