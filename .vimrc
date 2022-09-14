"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" --> General Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable
set incsearch                   " Incremental search
set hidden                      " Needed to keep multiple buffers open
set nobackup                    " No auto backups
set noswapfile                  " No swap
set t_Co=256                    " Set if term supports 256 colors.
set number relativenumber       " Display line numbers
set hlsearch 
set incsearch
set autoindent 
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" --> Cursor Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" --> Status Line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Setting up the Color Scheme for Status Line
let g:lightline = {
      \ 'colorscheme': 'darcula',
      \ }

" This will always show the statusline  
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=4                " One tab == four spaces.
set tabstop=4                   " One tab == four spaces.

