set nocompatible

filetype plugin indent on

set tags=./tags;/.;
set tags+=/usr/include/boost/tags

set makeprg=scons

set autoindent
set smartindent
set copyindent  "Check this is good enough
set shiftround  "Round to shiftwidth with > and <
set tabstop=4
set shiftwidth=4
set expandtab 

set guioptions-=T " Remove the toolbar from GUI
set vb t_vb=

set showmatch   " Show matching parenthesis etc.

set hlsearch
set incsearch
set ignorecase
set infercase

set foldenable
set foldmarker={,}
set foldmethod=marker
set foldlevel=100
set foldopen=block,hor,mark,percent,quickfix,tag

set backspace=2

syntax on

highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%81v.\+/

set guifont=Lucida_Console:h11:cANSI

if &t_Co >= 256 || has("gui_running")
    colorscheme ir_black
else
	set bg=dark
endif

set backup
set backupdir=~/.vim/backup
set clipboard+=unnamed
set directory=~/.vim/tmp

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python
autocmd BufNewFile,BufRead *.py set softtabstop=4
autocmd BufNewFile,BufRead *.py set shiftwidth=4
autocmd BufNewFile,BufRead *.py set smarttab

set laststatus=2
set statusline="%f%y%=#%n %l/%L%,%c%V"
set title

" Disable this if it causes issues...
set autochdir

" Hide buffers rather than closing.
set hidden

" Lots of history
set history=2000
set undolevels=2000

" Ignore some filetypes
set wildignore=*.swp,*.bak,*.pyc,*.class

call pathogen#infect()

" Hotkey for pasting without fucking up formatting
set pastetoggle=<F2>

" Uncomment this for mouse support 
" set mouse=a

" This next one sounds good, but unsure of.  Removes need for shift
" when running commands.  Going to fuck with my muscle memory though...
" nnoremap ; :

" I might kill myself for this, but disable arrow keys:
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Moving down on wrapped lines now goes to next row rather than line
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Clear highlighted searches
nmap <silent> ,/ :nohlsearch<CR>

" w!! will sudo write a file
cmap w!! w !sudo tee % >/dev/null

nmap <leader>e :TlistToggle<CR>
