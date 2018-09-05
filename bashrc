# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Add to history instead of overriding it
shopt -s histappend

# History length
HISTSIZE=
HISTFILESIZE=

# Window size sanity check
shopt -s checkwinsize

# User/root variables definition
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Colored XTERM promp
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Colored prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Prompt
if [ -n "$SSH_CONNECTION" ]; then
export PS1="\[$(tput setaf 1)\]┌─╼ \[$(tput setaf 7)\][\j][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼ \[$(tput setaf 7)\][ssh]\"; else echo \"\[$(tput setaf 1)\]└╼ \[$(tput setaf 7)\][ssh]\"; fi) \[$(tput setaf 7)\]"
else
export PS1="\[$(tput setaf 1)\]┌─╼ \[$(tput setaf 7)\][\j][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼\"; else echo \"\[$(tput setaf 1)\]└╼\"; fi)  \[$(tput setaf 7)\]"
fi
function elite {
PS1="\[\033[31m\]\332\304\[\033[34m\](\[\033[31m\]\u\[\033[34m\]@\[\033[31m\]\h\
\[\033[34m\])\[\033[31m\]-\[\033[34m\](\[\033[31m\]\$(date +%I:%M%P)\
\[\033[34m\]-:-\[\033[31m\]\$(date +%m)\[\033[34m\033[31m\]/\$(date +%d)\
\[\033[34m\])\[\033[31m\]\304-\[\033[34m]\\371\[\033[31m\]-\371\371\
\[\033[34m\]\372\n\[\033[31m\]\300\304\[\033[34m\](\[\033[31m\]\W\[\033[34m\])\
\[\033[31m\]\304\371\[\033[34m\]\372\[\033[00m\]"
PS2="> "
}


# trap 'echo -ne "\e[0m"' DEBUG

# I this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="${debian_chroot:+($debian_chroot)}\u: \w\a\]\n$PS1"
#     ;;
# *)
#     ;;
# esac

# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Auto-completion 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
if [ "$(uname)" == "Darwin" ]; then
    if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
        . /opt/local/etc/profile.d/bash_completion.sh
    fi
fi

# Advanced directory creation
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Entrez un nom pour ce dossier"
  elif [ -d $1 ]; then
    echo "\`$1' existe déjà"
  else
    mkdir $1 && cd $1
  fi
}

# Go back with ..
b() {
    str=""
    count=0
    while [ "$count" -lt "$1" ];
    do
        str=$str"../"
        let count=count+1
    done
    cd $str
}

# Color man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

# Auto cd
# shopt -s autocd

# ls after a cd
function cd()
{
 builtin cd "$*" && ls
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

translate(){ wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/'; }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/george/devel/archives/gcloud/google-cloud-sdk/path.bash.inc' ]; then source '/Users/george/devel/archives/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/george/devel/archives/gcloud/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/george/devel/archives/gcloud/google-cloud-sdk/completion.bash.inc'; fi

eval "$(direnv hook bash)"
eval $(thefuck --alias)

export PATH="/Applications/CMake.app/Contents/bin":"$PATH"
export GNUPGHOME="/home/v0yag3r/.gnupg"
export EDITOR="vim"
export REACT_EDITOR="vim"
export VISUAL="vim"
export TERM="xterm-256color"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# alias which="type -path"
# alias up="cd ../"
alias c=clear
alias h=history
alias cds="pushd ./ && cd"
alias cdtmp="pushd ./ && cd $(mktemp -d)"
alias back="popd"
alias full_monty="cd ~/devel/arcadia/full-monty"
alias log_branch="git branch | grep '*' | awk '{print \$2}'"
alias docker-stats="docker stats $(docker ps --format={{.Names}})"
alias iphone_down="sudo ifconfig en5 down"

alias gf="git fetch"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias gch="git checkout"
alias gco="git commit -am"
alias gls="git log --oneline --graph --decorate -n5 && git status"
alias gfgc="git fetch && git checkout"


export PATH="$HOME/Library/Python/2.7/bin:$HOME/local/bin:$HOME/.yarn/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
