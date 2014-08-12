if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

__has_parent_dir () {
    # Utility function so we can test for things like .git/.hg without firing up a
    # separate process
    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo "-[svn]";
    elif __has_parent_dir ".git"; then
        echo "-[$(__git_ps1 'git %s')]";
    elif __has_parent_dir ".hg"; then
        echo "-[hg $(hg branch)]"
    fi
}

black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
dk_blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
lt_blue=$(tput -Txterm setaf 6)

bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

# Nicely formatted terminal prompt
export PS1='\n\[$bold\]\[$black\][\[$dk_blue\]\@\[$black\]]-[\[$green\]\u\[$yellow\]@\[$green\]\h\[$black\]]-[\[$pink\]\w\[$black\]]\[\033[0;33m\]$(__vcs_name) \[\033[00m\]\[$reset\]\n\[$reset\]\$ '

alias ls='ls -F --color=always'
alias dir='dir -F --color=always'
alias ll='ls -l'
alias cp='cp -iv'
alias rm='rm -i'
alias mv='mv -iv'
alias grep='grep --color=auto -in'
alias ..='cd ..'

alias rm='rm -i'
alias df='df -h'

alias ls="/bin/ls $LS_OPTIONS"
alias ll='ls -l'
alias lsd='ls -ld'
alias la='ls -a'
alias lf='ls -F'
alias lr='ls -alFRt'
alias lx='ls -xF'
alias llar='ls -laFR'
alias lt='ls -lartF'
alias lrt='ls -lrt'
alias t='tree'

alias up='cd ..'
alias web='cd /vagrant'
alias mt='multitail -CS php'

alias bounce='sudo /etc/init.d/nginx restart && sudo /etc/init.d/php5-fpm restart'
alias cache_clear='rm -rf /vagrant/Symfony/app/cache/* /vagrant/Symfony/app/logs/*'
alias grok='/vagrant/puphpet/files/bin/ngrok -authtoken fVVLLIi6noAoJOIfmuLU ephbee ephbee 80'
alias yum='sudo apt-get'
alias dot='cp /vagrant/puphpet/files/dot/.zshrc ~/.zshrc && . ~/.zshrc'
alias pwn='vendor/bin/phpunit'

# DIRS
alias etc='cd /etc/'
