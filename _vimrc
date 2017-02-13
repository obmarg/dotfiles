set nocompatible

" Disable filetype for vundle
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'Bogdanp/pyrepl.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'juvenn/mustache.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'groenewege/vim-less'
Plugin 'kana/vim-smartinput'
Plugin 'sjl/gundo.vim'
Plugin 'klen/python-mode'
Plugin 'tpope/vim-cucumber'
Plugin 'AndrewRadev/linediff.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-markdown'
Plugin 'vim-scripts/OmniCppComplete'
Plugin 'majutsushi/tagbar'
Plugin 'guns/vim-clojure-static'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-repeat'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-obsession'
Plugin 'scrooloose/syntastic'
Plugin 'nono/vim-handlebars'
Plugin 'wavded/vim-stylus'
Plugin 'airblade/vim-gitgutter'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-dispatch'
Plugin 'elzr/vim-json'
Plugin 'rking/ag.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-eunuch'
Plugin 'elixir-lang/vim-elixir'
Plugin 'honza/vim-snippets'
Plugin 'saltstack/salt-vim'
Plugin 'tpope/vim-git'
Plugin 'raichoo/haskell-vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'tpope/vim-fireplace'
Plugin 'raichoo/purescript-vim'

call vundle#end()
filetype plugin indent on

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

set noswapfile

" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

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

" Use scons for cpp
autocmd filetype cpp setlocal makeprg=scons

" Add doxygen style comments for cpp & idl files
autocmd filetype cpp setlocal comments-=:// comments+=://!,://
autocmd filetype idl setlocal comments-=:// comments+=://!,://
autocmd filetype idl setlocal formatoptions+=ctroq

" Wrap markdown files at 79 characters
autocmd filetype markdown set textwidth=79

" SCons files = python
autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

" Python formatting rules
au filetype python setl softtabstop=4
au filetype python setl shiftwidth=4
au filetype python setl smarttab
" Syntastic highlights 79 char long lines as wrong, so lets limit to 78
au filetype python setl textwidth=78

" Smart indent fucks up lines starting with #
au filetype python setl nosmartindent
au filetype coffee setl nosmartindent

" Rolepoint specific python file 'building'
au filetype python setlocal makeprg=nosetests
au filetype python setlocal efm=%f:%l:\ fail:\ %m,%f:%l:\ error:\ %m
au filetype python nnoremap <C-CR> :make<CR>

" Coffeescript, Ruby & XML - 2 space indents
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
au filetype ruby setl shiftwidth=2 expandtab
au filetype xml setl shiftwidth=2 expandtab
au filetype xsd setl shiftwidth=2 expandtab

" Use 2 space indents in html & css files
au filetype html setl ts=2 shiftwidth=2
au filetype css setl ts=2 shiftwidth=2

" Use tabs in stylus files
au filetype stylus setl noexpandtab

" Use mustache formatting for ractive files
autocmd BufRead,BufNewFile *.rac setl filetype=mustache

" Load matchit plugin
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

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
" <leader>n as shortcut to :b
" <leader>1... for buffer number
map <leader>l :ls<CR>
map <leader><leader> :b #<CR>
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

" Map some quickfix list navigation commands
" <leader>. for next
" <leader>m for previous
map <leader>. :cn<CR>
map <leader>m :cp<CR>

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

" Map Ctrl-A/Ctrl-E to home/end
" (but not in normal, as there it has a use)
vnoremap <C-A> ^
vnoremap <C-E> $
inoremap <C-A> <C-O>^
inoremap <C-E> <C-O>$

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

autocmd FileWritePre    * :call StripWhitespace()
autocmd FileAppendPre   * :call StripWhitespace()
autocmd FilterWritePre  * :call StripWhitespace()
autocmd BufWritePre     * :call StripWhitespace()

" Map tag list to <leader>e
nmap <leader>e :TlistToggle<CR>

" Alt-O should switch to alternative file
nnoremap <A-o> :A<CR>

" Alt-G should go to definition
nnoremap <A-g> <C-]>

" Cmd-Enter should eval current clojure form
nnoremap <D-Return> :Eval<CR>

" Setup some python mode settings
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_lint_checker = "pyflakes,pep8,mccabe"
let g:pymode_lint_ignore = "W391,E201,E202,E225,E126,E123"
let g:pymode_rope_completion = 0
" E225 - Whitespace around operators (messes up for should-dsl)
" E125 - Over-indented continuation line
" E126 - Closing brace doesn't match indentation of opening brace

nnoremap <F5> :GundoToggle<CR>

let g:Powerline_symbols='unicode'

" Vim-clojure-static settings
let g:clojure_align_multiline_strings=1

"
" Rainbow parenthesis settings
"
let g:rbpt_loadcmd_toggle = 0

" Enable rainbow parens for clojure.
" May want it for others in future, not sure
au FileType clojure RainbowParenthesesActivate
au FileType clojure RainbowParenthesesLoadRound
au FileType clojure RainbowParenthesesLoadSquare
au FileType clojure RainbowParenthesesLoadBraces

" Alternative colors for rainbow parens
" Thanks to vim-clojure & light table for the colors
" These go from inner-most to outermost
let g:rbpt_max = 15
let g:rbpt_colorpairs = [
    \ ['magenta',     'orange'],
    \ ['cyan',        'yellow'],
    \ ['green',       'greenyellow'],
    \ ['yellow',      '#9B30FF'],
    \ ['red',         '#FF00FF'],
    \ ['magenta',     'orange'],
    \ ['cyan',        'yellow'],
    \ ['green',       'greenyellow'],
    \ ['yellow',      '#9B30FF'],
    \ ['red',         '#FF00FF'],
    \ ['magenta',     '#836fff'],
    \ ['cyan',        '#00ffff'],
    \ ['green',       '#00ff7f'],
    \ ['yellow',      '#00ff00'],
    \ ['DarkGrey',    '#668799'],
    \ ]

if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }
endif

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let g:syntastic_python_checkers = ['flake8']

" UtilSnips configuration
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-s>"
let g:UltiSnipsJumpBackwardTrigger="<c-a>"

let g:dash_map = {
    \ 'python'      : 'python2 flask werkzeug jinja',
    \ 'javascript'  : 'javascript lodash backbone underscore',
    \ 'html'        : 'html css'
    \ }

autocmd FileType elixir
        \ let b:endwise_addition = 'end' |
        \ let b:endwise_words = 'case,cond,bc,lc,inlist,inbits,if,unless,try,receive,function,fn' |
        \ let b:endwise_pattern = '^\s*\zs\%(do\|case\|cond\|bc\|lc\|inlist\|inbits\|if\|unless\|try\|receive\|function\|fn\)\>\%(.*[^:]\<end\>\)\@!' |
        \ let b:endwise_syngroups = 'elixirKeyword'

autocmd FileType gitcommit set spell
