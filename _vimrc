set nocompatible

filetype plugin indent on

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

" /g mode on :s substitutions by default
set gdefault

set foldenable
set foldmarker={,}
set foldmethod=marker
set foldlevel=100
set foldopen=block,hor,mark,percent,quickfix,tag

set backspace=2

" Should always have at least 5 lines above & below cursor
set scrolloff=5

" Set new splits to go right/below. No idea why this isn't default
set splitright
set splitbelow 

" UTF-8 encoding by default
set encoding=utf-8

set number

syntax on

set laststatus=2
set statusline="%f%y%=#%n %l/%L%,%c%V"
set title

" Hide buffers rather than closing.
set hidden

" Lots of history
set history=2000
set undolevels=2000

" Ignore some file types
set wildignore+=*.swp,*.bak,*.pyc,*.class,*.o,*.so,*.a,*.zip,*.exe,*.obj

" Enable wildcard menu, rather than completing.
" list matches, then longest common part then all
set wildmenu
set wildmode=list:longest,full

set nobackup
set clipboard+=unnamed
set directory=$HOME/.vim/tmp

" Highlight lines > 80 characters (this doesn't work for gvim)
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%81v.\+/

" Fonts and color schemes
if has('gui_win32')
    set guifont=Ubuntu_Mono:h13:cANSI
endif

if has('gui_macvim')
    set guifont=Monaco:h13
endif

if &t_Co >= 256 || has("gui_running")
    colorscheme jellybeans
else
	set bg=dark
endif

" Set up tag locations
set tags=./tags;/.;
autocmd filetype cpp setlocal tags+=/usr/include/boost/tags

" Add doxygen style comments for cpp files
autocmd filetype cpp setlocal comments-=:// comments+=://!,://

" Wrap markdown files at 79 characters
autocmd filetype markdown set textwidth=79

" SCons files = python
autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

" Python formatting rules
au filetype python setl softtabstop=4
au filetype python setl shiftwidth=4
au filetype python setl smarttab

" Smart indent fucks up lines starting with #
au filetype python setl nosmartindent

" Coffeescript, Ruby & XML - 2 space indents
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
au filetype ruby setl shiftwidth=2 expandtab
au filetype xml setl shiftwidth=2 expandtab
au filetype xsd setl shiftwidth=2 expandtab

" Use tabs in html & css files
au filetype html setl noexpandtab ts=2 shiftwidth=2
au filetype css setl noexpandtab ts=2 shiftwidth=2

call pathogen#infect()
call pathogen#helptags()

" Remap leader to comma to save cross platform confusion
let mapleader = ","
" And map \ to previous character search
noremap \ ,

" Hotkey for pasting without fucking up formatting
set pastetoggle=<F2>

" Uncomment this for mouse support 
" set mouse=a

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

" Map some buffer navigation keys.
" <leader>l for list
" <leader><leader> for toggle
" <leader>. for next
" <leader>m for previous
" <leader>n as shortcut to :b
" <leader>1... for buffer number
map <leader>l :ls<CR>
map <leader><leader> :b #<CR>
map <leader>. :bn<CR>
map <leader>m :bp<CR>
map <leader>n :b
map <leader>1 :b 1<CR>
map <leader>2 :b 2<CR>
map <leader>3 :b 3<CR>
map <leader>4 :b 4<CR>
map <leader>5 :b 5<CR>
map <leader>6 :b 6<CR>
map <leader>7 :b 7<CR>
map <leader>8 :b 8<CR>
map <leader>9 :b 9<CR>

" Clear highlighted searches
nmap <silent> <Leader>/ :nohlsearch<CR>

" Map Ctrl-S to shortcut for splitting lines on comma and )
" I'm not yet sure how usefull this will actually be.
" Might need a more intelligent solution.
" For a start it's impoossible to use 4,s (as the count just acts on the
" search)
map <leader>s /[(,)]/e+1<leader>/i<CR><ESC>

" w!! will sudo write a file
cmap w!! w !sudo tee % >/dev/null

" Yank from cursor to end of line
nnoremap Y y$

" Indent/unident block (,]) (,[)
nnoremap <leader>] >i{<CR>
nnoremap <leader>[ <i{<CR>

" Insert newline
map <leader><Enter> o<ESC>

" Map %% to current file path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Strip trailing whitespace (,ss)
function! StripWhitespace ()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace ()<CR>

" Map tag list to <leader>e
nmap <leader>e :TlistToggle<CR>

" Alt-O should switch to alternative file
nnoremap <A-o> :A<CR>

" Alt-G should go to definition
nnoremap <A-g> <C-]>

" Setup some python mode settings
let g:pymode_indent = 0
let g:pymode_lint_checker = "pyflakes,pep8,mccabe"
let g:pymode_lint_ignore = "W391,E201,E202,E225,E126,E123"
" E225 - Whitespace around operators (messes up for should-dsl)
" E125 - Over-indented continuation line
" E126 - Closing brace doesn't match indentation of opening brace

nnoremap <F5> :GundoToggle<CR>

let g:Powerline_symbols='unicode'
