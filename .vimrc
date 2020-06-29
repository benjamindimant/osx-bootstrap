" Colors
colorscheme murphy
syntax on

" UI config
set number
set showmatch

" Indentations
set shiftwidth=2
set autoindent
set smartindent
set expandtab
set softtabstop=2
set textwidth=80

set showmode
set showcmd
set wildmenu
set ruler
runtime ftplugin/man.vim
set nowrap
set ignorecase
set smartcase
set incsearch
set path==.,..,/usr/include/**,/usr/share/**

" Autocomplete brackets
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" Autocomplete brackets
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

" Get rid of delay on ^[O
set timeout timeoutlen=5000 ttimeoutlen=100

" Autoreload vim
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost .vimrc source ~/.vimrc
augroup END " }

" Tab numbering
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif

" netrw configs
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20

" https://stackoverflow.com/questions/5006950/setting-netrw-like-nerdtree
com!  -nargs=* -bar -bang -complete=dir  Lexplore  call netrw#Lexplore(<q-args>, <bang>0)

fun! Lexplore(dir, right)
  if exists("t:netrw_lexbufnr")
  " close down netrw explorer window
  let lexwinnr = bufwinnr(t:netrw_lexbufnr)
  if lexwinnr != -1
    let curwin = winnr()
    exe lexwinnr."wincmd w"
    close
    exe curwin."wincmd w"
  endif
  unlet t:netrw_lexbufnr

  else
    " open netrw explorer window in the dir of current file
    " (even on remote files)
    let path = substitute(exists("b:netrw_curdir")? b:netrw_curdir : expand("%:p"), '^\(.*[/\\]\)[^/\\]*$','\1','e')
    exe (a:right? "botright" : "topleft")." vertical ".((g:netrw_winsize > 0)? (g:netrw_winsize*winwidth(0))/100 : -g:netrw_winsize) . " new"
    if a:dir != ""
      exe "Explore ".a:dir
    else
      exe "Explore ".path
    endif
    setlocal winfixwidth
    let t:netrw_lexbufnr = bufnr("%")
  endif
endfun

" https://unix.stackexchange.com/questions/134759/running-a-vim-key-combination-on-startup
" noremap <silent> <C-M> :Lex <CR>
" autocmd VimEnter * :Lex
" autocmd VimEnter * wincmd l " automatically move to the right window
noremap <silent> <F2> :Lex <CR>

" https://stackoverflow.com/questions/14665170/netrw-open-files-into-tabs-in-opposite-vertical-window
" " hide netrw top message
" let g:netrw_banner=0
" " tree listing by default
" let g:netrw_liststyle=3
" " hide vim swap files
" let g:netrw_list_hide='.*\.swp$'
" " open files in left window by default
" let g:netrw_chgwin=1
" " remap shift-enter to fire up the sidebar
" nnoremap <silent> <S-CR> :rightbelow 20vs<CR>:e .<CR>
" " the same remap as above - may be necessary in some distros
" nnoremap <silent> <C-M> :rightbelow 20vs<CR>:e .<CR>
" " remap control-enter to open files in new tab
" nmap <silent> <C-CR> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>
" " the same remap as above - may be necessary in some distros
" nmap <silent> <NL> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>
" 
" autocmd VimEnter * rightbelow 20vs
" autocmd VimEnter * e .

augroup myvimrc
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END
