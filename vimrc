syntax enable
set nocompatible
set encoding=utf-8
scriptencoding utf-8
set ambiwidth=single
set mouse=nicr
set autoread                        "auto reaload vimrc"
filetype plugin indent on
set smartindent
set background=light
set t_Co=256
set number
set relativenumber
set ruler                           " show the cursor position all the time
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

set cursorline
set nocursorcolumn
hi cursorline   cterm=NONE ctermbg=black guibg=black
hi cursorcolumn cterm=NONE ctermbg=black guibg=black
set showcmd                         " display incomplete commands
set foldenable                      "auto folding enabled
set fdm=marker

set hidden                        " Allow backgrounding buffers without writing them, and remember marks/undo for backgrounded buffers
set showcmd

"" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set softtabstop=2                 "
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

"" List chars, this can be toggled with leader+l, default is on
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
set ignorecase                    " searches are case insensitive
set showmatch
set smartcase                     " ... unless they contain at least one capital letter
set pastetoggle=<F2>
set scrolloff=3                   " provide some context when editing

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make setlocal noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile,BufWritePre *.{md,markdown,mkd,txt}
        \ call SetupWrapping() |
        \ colorscheme blackboard |
        \ call s:lightline_update()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=json

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  "auto save views and folds
   autocmd BufWinLeave *.* mkview
   autocmd BufWinEnter *.* silent loadview

   " set 80 width for perl
   au FileType perl setlocal textwidth=80
   au FileType perl setlocal cc=80

   " augroup LightLineColorscheme
   "   autocmd!
   "   autocmd ColorScheme * call s:lightline_update()
   " augroup end
 endif

if has('gui_running')
  hi Visual guifg=Gray guibg=Blue gui=none
  set guifont=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline:h14
  "hi Todo guifg=#40ffff guibg=#606060
  "LIGHTLINE
else
  " something for console Vim only
endif

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>

let mapleader=","

" find merge conflict markers
" nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>


if has("macunix")
  nmap <silent> <Leader>d :!open dict://<cword><CR><CR>
  nmap <silent> <Leader>m :!open wais://1/<cword><CR><CR>
endif

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

if has("statusline") && !&cp
  set laststatus=2              " always show the status bar
endif

let g:CommandTMaxHeight=10
hi StatusLine ctermfg=Blue  ctermbg=White

" highlight an out of range ip
match errorMsg /\v(25[6-9]|2[6-9]\d|[3-9]\d\d)\.\d{1,3}[.]\d{1,3}[.]\d{1,3}|
                 \\d{1,3}\.(25[6-9]|2[6-9]\d|[3-9]\d\d)[.]\d{1,3}[.]\d{1,3}|
                 \\d{1,3}\.\d{1,3}\.(25[6-9]|2[6-9]\d|[3-9]\d\d)\.\d{1,3}|
                 \\d{1,3}\.\d{1,3}\.\d{1,3}\.(25[6-9]|2[6-9]\d|[3-9]\d\d)/

highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" " " " useful (re)maps
nmap <leader>l :set list!<CR>

" escribir con sudo
cabbrev W!! w !sudo tee %

imap jk <ESC>
imap jj <ESC>
imap hh <ESC>
imap kk <ESC>

" magic search
nnoremap / /\v
nnoremap ? ?\v

" next highlight always centered
nmap n nzz
nmap N Nzz

" space for toggle folding {{{
nnoremap <Space> za
" space copy to select in visual
vnoremap <Space> y
" }}}
" search the word selected in visual mode
vnoremap / y/\v<C-R>"<CR>

" window movement
nnoremap <Down>   <C-w>j
nnoremap <Up>     <C-w>k
nnoremap <Left>   <C-w>h
nnoremap <Right>  <C-w>l

nnoremap <S-Down>   <C-w>J
nnoremap <S-Up>     <C-w>K
nnoremap <S-Left>   <C-w>H
nnoremap <S-Right>  <C-w>L

" move btween tabs
nnoremap <leader>n :tabn<CR>
nnoremap <leader>p :tabp<CR>

" toggle cursorline and column
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" " " " PARTY TAIM  " " " "
fun! SetupWrapping()
    set wrap
    set wrapmargin=2
    set textwidth=120
    set nocursorline nocursorcolumn
    set linebreak
    set nolist
    set spell
endfun


"TODO expand this,to linux friendly
" open url with leader + w
map <leader>w :call HandleURI()<CR>
fun! HandleURI()
let s:uri = matchstr(getline("."), '\vhttps?:\/\/[^ >,;]+')
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

fun! s:RevealInFinder()
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
endfun

command! Reveal call <SID>RevealInFinder()

fun! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    call lightline#colorscheme()
  catch
  endtry
endfun

" " " OK THE PARTY IS OVER :( " " " "

" " " plugin configurations " " "

call pathogen#infect()
call pathogen#helptags()

"LIGHTLINE
"trying pure unicode instead of powerline
"
set noshowmode  " remove -- INSER -- line below"

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly ? "✖︎" : ""}',
      \   'filename': expand("%")
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineBranchName'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '❯', 'right': '❮' }
\ }
fun! LightlineBranchName()
  return gitbranch#name() == '' ? '' : 'ᚠ ' . gitbranch#name()
endfun

" load solarized after pathogen
colorscheme solarized

" " Multiword search
" http://vim.wikia.com/wiki/Talk:Highlight_multiple_words
" http://vim.wikia.com/wiki/Highlight_multiple_words

" matchadd() priority -1 means 'hlsearch' will override the match.
" function! DoHighlight(hlnum, search_term)
"   call UndoHighlight(a:hlnum)
"   if len(a:search_term) > 0
"     let id = matchadd("hl".a:hlnum, a:search_term, -1)
"     let g:matchadd_ids[a:hlnum] = id
"   endif
" endfunction

" function! UndoHighlight(hlnum)
"   silent! call matchdelete(g:matchadd_ids[a:hlnum])
" endfunction

" function! SetHighlight(hlnum, colour)
"   if len(a:colour) > 0
"     exe "highlight hl".a:hlnum." term=bold ctermfg=".a:colour." guifg=".a:colour
"   endif
" endfunction

" let g:matchadd_ids = {}
" call SetHighlight(1, 'blue')
" call SetHighlight(2, 'green')
" call SetHighlight(3, 'red')
" nnoremap <Leader>ma :<C-u>call DoHighlight(v:count1, expand("<cword>"))<CR>Gvk
" nnoremap <Leader>md :<C-u>call UndoHighlight(v:count1)<CR>
