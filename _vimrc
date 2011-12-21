set nocompatible

set tags=./tags;/.;
set tags+=/usr/include/boost/tags

set makeprg=scons

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab 

set guioptions-=T
set vb t_vb=

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

if has("gui_running")
    colorscheme ir_black
endif

set backup
set backupdir=~/.vim/backup
set clipboard+=unnamed
set directory=~/.vim/tmp

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python
autocmd BufNewFile,BufRead *.py set tabstop=4
autocmd BufNewFile,BufRead *.py set softtabstop=4
autocmd BufNewFile,BufRead *.py set shiftwidth=4
autocmd BufNewFile,BufRead *.py set smarttab

set laststatus=2
set statusline="%f%y%=#%n %l/%L%,%c%V"
set title

" Disable this if it causes issues...
set autochdir
