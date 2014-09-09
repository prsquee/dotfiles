syntax enable
set nocompatible
set encoding=utf-8
set ambiwidth=single
set mouse=nicr
"set cm=blowfish

filetype plugin indent on
set smartindent
set background=dark
set t_Co=256
set number
set relativenumber
set ruler                           " show the cursor position all the time
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

color base16-solarized

set cursorline
hi cursorline guibg=#333334
hi CursorColumn guibg=#333333
set showcmd                         " display incomplete commands
set foldenable                      "auto folding enabled
set fdm=marker

set hidden                          " Allow backgrounding buffers without writing them, and remember marks/undo for backgrounded buffers
set showcmd

"" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set softtabstop=2                 " 
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
" List chars, this can be toggled with leader+l
set listchars=""                  " Reset the listchars
set listchars=tab:▸\ 
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=nbsp:.
set listchars+=eol:¬              " end of line char

"" Searching
set magic                         " \v advance magic here
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set showmatch
set smartcase                     " ... unless they contain at least one capital letter
set pastetoggle=<F2>
set scrolloff=3                   " provide some context when editing

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make setlocal noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown 
              \| call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=json

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  "reload vimrc on save
  au BufWritePost ~/.vimrc   so ~/.vimrc

  " auto update cluster.conf version number
  au BufWritePre,FileWritePre cluster.conf ks|call ClusterVersionPlusPlus()|'s
  au BufWritePre,FileWritePre *.txt   ks|call LastMod()|'s

  "auto save views and folds
   autocmd BufWinLeave *.* mkview
   autocmd BufWinEnter *.* silent loadview

   " set 78 width for perl 
   au FileType perl setlocal textwidth=78
   au FileType perl setlocal cc=+1
endif

if has('gui_running')
  colorscheme base16-solarized
  
  " set guifont=Terminus:h16
  " set guifont=Source\ Code\ Pro\ for\ Powerline:16
  " set guifont=Anonymous\ Pro\ for\ Powerline:h16
  set guifont=Fixedsys\ Excelsior\ 3.01:h16
  set noantialias
  "hi Todo guifg=#40ffff guibg=#606060
  " set lines=50 columns=96 linespace=0
  let g:airline_powerline_fonts=0
"else
  " something for console Vim
endif

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>

let mapleader=","

" find merge conflict markers
" nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

command! KillWhitespace :normal :%s/ *$//g<CR><c-o><CR>


set history=100
if $TMUX == ''
  set clipboard+=unnamed
endif
" set clipboard=unnamed

" Save your backups 
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.

if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" swap files
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" set undofile
" set backup
" set backupdir=~/.vim/backup//,.
" set directory=~/.vim/tmp//,/var/tmp//,/tmp//,.        " where to put swap files.
" set spellfile=~/.vim/spell/dict.add                  " added words for spell check
" set nospell
" set spell spelllang=en_us,es



if has("statusline") && !&cp
  set laststatus=2              " always show the status bar

  " Start the status line
  " %F = full path |  %f = just the filename, what are the rest for?
  " %h help file flag
  " %m modified flag
  " %r readonly flag
  "
  " %< force truncation
  set statusline=
  set statusline+=%F%m%r%h%w%<
  set statusline+=%=[%{&ff}]
  set statusline+=[%{strlen(&fenc)?&fenc:'none'}]
  set statusline+=%y


  " stuff aligned to the left with %= 
  " set statusline+=[Col:%02v]
  set statusline+=[%l/%L]
  "[ascii][hex] code
"  set statusline+=\ [\%03.3b][0x\%02.2B]
"  set statusline+=\ Buf:#%n 

 set statusline+=[%{FileSize()}]
 fun! FileSize()
     let bytes = getfsize(expand("%:p"))
     if bytes <= 0
         return ""
     endif
     if bytes < 1024
         return bytes . "b"
     else
         return (bytes / 1024) . "Kb"
     endif
 endfun
endif

let g:CommandTMaxHeight=10
hi StatusLine ctermfg=Blue  ctermbg=White

" highlight a wrong ip addr:
match errorMsg /\v(2[5][6-9]|2[6-9]\d|[3-9]\d\d)[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}|
                 \\d{1,3}[.](2[5][6-9]|2[6-9]\d|[3-9]\d\d)[.]\d{1,3}[.]\d{1,3}|
                 \\d{1,3}[.]\d{1,3}[.](2[5][6-9]|2[6-9]\d|[3-9]\d\d)[.]\d{1,3}|
                 \\d{1,3}[.]\d{1,3}[.]\d{1,3}[.](2[5][6-9]|2[6-9]\d|[3-9]\d\d)/

highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59


" " " " useful (re)maps 
nmap <leader>l :set list!<CR>
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
" escribir con sudo 
cabbrev W!! w !sudo tee %

imap jk <ESC>
imap jj <ESC>
imap hh <ESC>
imap kk <ESC>
"imap kl <ESC> "conflic with the words pickle ducklings klingon klaus

" magic search
nnoremap / /\v
nnoremap ? ?\v

" next highlight always centered
nmap n nzz
nmap N Nzz

" space for win
noremap <Space> :
"imap <S-Space> <ESC>
" space copy select
vmap <Space> y

" usar las flechitas para mover entre ventanas
" nnoremap <Down>   <C-w>j
nnoremap <Up>     <C-w>k
nnoremap <Left>   <C-w>h
nnoremap <Right>  <C-w>l


" usar las flechitas para mover entre ventanas
" nnoremap <Down>   <C-w>j
nnoremap <Up>     <C-w>k
nnoremap <Left>   <C-w>h
nnoremap <Right>  <C-w>l

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" move btween tabs
nnoremap <leader>n :tabn<CR>
nnoremap <leader>p :tabp<CR>

" cleanup trailing whitespaces
nnoremap <silent> <F5> :call StripTrailingWhitespaces()<CR>



" " " " PARTY TAIM  " " " " 
fun! s:setupWrapping()
    set wrap
    set wrapmargin=2
    set textwidth=72
endfun


fun! LastMod()
  if line("$") > 20
    let l = 20
  else
    let l = line("$")
  endif
  exe "1," . l . "g#Last modified: #s#^(.*Last modified:) .*#\1 " . strftime("%Y %b %d - %H:%m")
endfun

fun! ClusterVersionPlusPlus()
  if &modified
    exe search('config_version','c')
    exe 's/\d\+/\=submatch(0)+1/'
  endif
endfun


"TODO expand this,to linux friendly
" open url with leader + w
map <leader>w :call HandleURI()<CR>
fun! HandleURI()
let s:uri = matchstr(getline("."), 'https?:\/\/[^ >,;]+')
echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
    else
      echo "No URI found in line."
  endif
endfun

fun! StripTrailingWhitespaces()
  "prep: save last search, save cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the stripping
  %s/\s\+$//e
  "cleanup
  let @/=_s
  call cursor(l,c)
endfun

"open in finder

function! s:RevealInFinder()
  if filereadable(expand("%"))
    let l:command = "open -R %"
  elseif getftype(expand("%:p:h")) == "dir"
    let l:command = "open %:p:h"
  else
    let l:command = "open ."
  endif

  execute ":silent! !" . l:command

  " For terminal Vim not to look messed up.
  redraw!
endfunction

command! Reveal call <SID>RevealInFinder()


" " " OK THE PARTY IS OVER :( " " " " 

" pathogen manager
call pathogen#infect()
call pathogen#helptags()

" AIRLINE STUFF "
let g:airline_powerline_fonts=0
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_left_sep = '⮀'
"let g:airline_left_alt_sep = '⮁'
"let g:airline_right_sep = '⮂'
"let g:airline_right_alt_sep = '⮃'
"let g:airline_symbols.branch = '⭠'
"let g:airline_symbols.readonly = '⭤'
"let g:airline_symbols.linenr = '⭡'

" auto open nerdtree 
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <silent> <F15> :NERDTreeToggle<CR>