#!/usr/bin/env zsh
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

setopt promptsubst

autoload -U add-zsh-hook

PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]

# Fancy git output - KILLS opening /Source!!!
#PROMPT='%{$GIT_SUCCESS_COLOR%}%D{%L:%M:%S} %{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}%{$GIT_PROMPT_INFO%}$(git_prompt_info)$(virtualenv_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status) %{$reset_color%}%{$PROMPT_PROMPT%}ᐅ%{$reset_color%} '


# Hacking with debuggy output
#PROMPT='(A)%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%} (B) %$(virtualenv_prompt_info) %{$reset_color%}%{$PROMPT_PROMPT%}ᐅ%{$reset_color%} '
# Disable git - Odd character that make some things pop
#PROMPT='%{$GIT_SUCCESS_COLOR%}%D{%L:%M:%S} %{$PROMPT_SUCCESS_COLOR%}%~%{$GIT_CLEAN_COLOR%} ᐅ %{$reset_color%}'
# Disable git - Normal ASCII chars only
PROMPT='$FG[220]%}%D{%L:%M:%S} %{$PROMPT_SUCCESS_COLOR%}%~%{$GIT_CLEAN_COLOR%} >> %{$reset_color%}'

# %{$FG[082]%}A %{$FG[166]%}B %{$FG[160]%}C %{$FG[220]%}D %{$FG[082]%}E %{$FG[190]%}F %{$reset_color%}

#RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX=" ["
ZSH_THEME_VIRTUALENV_SUFFIX="]"



#PROMPT='%F{green}%2c%F{blue} [%f '
#RPROMPT='$(git_prompt_info) %F{blue}] (1)%F{green}(2)%D{%L:%M:%S} (3)%F{yellow}%D{%p}%f'
#ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
#ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}*%f"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
