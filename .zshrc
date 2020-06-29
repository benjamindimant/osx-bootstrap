# Define colors
autoload -U colors && colors

# Command prompt
export PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}%::%{$fg[cyan]%}%(5~|%-1~/.../%3~|%4~)%{$reset_color%}% $ "
export CLICOLOR=1
export LSCOLORS=GxFxBxDxCxegedabagacad
alias ls='ls -GFh'
