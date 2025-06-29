color desert
syntax on

set expandtab      " Use spaces instead of tabs
set tabstop=4      " A tab character is displayed as 4 spaces
set shiftwidth=4   " Auto-indent uses 4 spaces
set softtabstop=4  " Number of spaces inserted when pressing Tab in Insert mode

set number                         " Include line numbers
highlight LineNr ctermfg=darkgrey  " Default line numbers are bright yellow :/

set colorcolumn=80,120               " Vertical ruler at 80 and 120 chars
highlight ColorColumn ctermbg=black  " Vertical ruler colour
                                     " Available colours -> help: ctermbg)

" Enable project-local .vimrc files
set exrc    " Allow sourcing of .vimrc file from vim's current directory
set secure  " Restrict dangerous commands in local .vimrc files

