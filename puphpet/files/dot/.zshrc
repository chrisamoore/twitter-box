set -o vi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cam"

# Gets rid of annoying update prompt and just does it automatically
DISABLE_UPDATE_PROMPT=true

# ZSH_THEME="crcandy"
# Example aliases
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}

git() {
  if [ "$1" = commit ]; then
    echo "WRONG! You shouldn't be committing from vagrant"
  else
    command git "$@"
  fi
}

alias rm='rm -i'
alias df='df -h'

# cd
alias ..='cd ..'

alias api='cd /var/www/twitter-laravel/twitter-api'
alias ui='cd /var/www/twitter-laravel/twitter-ui'
alias l4='cd /var/www/twitter-laravel/twitter-api'

alias mongo_limit='DBQuery.shellBatchSize = 3000'

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

alias home='cd ${HOME}'
alias up='cd ..'
alias web='cd /vagrant'
alias mt='multitail -CS php'
alias l4='cd /var/www/twitter-laravel'
alias blue='cd /var/www/twitter-api-blueprint'
alias ui='cd /var/www/twitter-ui'

alias art='/var/www/twitter-laravel/artisan'

alias test_all='/usr/bin/php /vagrant/twitter-laravel/artisan env:reset -f && /vagrant/twitter-laravel/vendor/bin/phpunit -c /vagrant/twitter-laravel/phpunit.xml && /vagrant/twitter-api-blueprint/bin/run-dredd'

alias bounce='sudo cp /vagrant/puphpet/files/custom/nginx.conf /etc/nginx/conf.d/nginx.conf && sudo nginx -c /etc/nginx/nginx.conf -t && sudo /etc/init.d/nginx restart && sudo /etc/init.d/php5-fpm restart'
alias super_bounce='/usr/bin/php /var/www/twitter-laravel/artisan beanstalkd:clear && sudo cp /vagrant/puphpet/files/custom/supervisord.conf /etc/supervisor/conf.d/supervisord.conf && sudo supervisord -c /etc/supervisor/conf.d/supervisord.conf'
alias pool_bounce='sudo cp -ir /vagrant/puphpet/files/custom/www.conf /etc/php5/fpm/pool.d/www.conf'
alias dot='cp /vagrant/puphpet/files/dot/.zshrc ~/.zshrc && . ~/.zshrc'

function mock(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease specify a resource name."
      else
      api-mock /vagrant/$1-api-blueprint/$2.md --host=127.0.0.1
      fi
    }

function docs(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease specify a resource name."
      else
      aglio -i /vagrant/$1-api-blueprint/$2.md --host=127.0.0.1 --port=4000 -s -t slate
      fi
    }

alias dredd_test='echo "dredd /vagrant/<example>-api-blueprint/<resource>.md http://127.0.0.1:3000"'

# DIRS
alias etc='cd /etc/'

#git
  alias showbranches='git for-each-ref --sort=-committerdate refs/heads/'
  #tagging Reference a Commit
    function tag(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease specify a tag name and a message."
      else
        git blame $1
      fi
      git tag -a $1 -m $2
    }
  #list tags (brief)
   alias describe='git describe --tags'
  #list tag (bexpanded)
    function show(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease specify a tag name."
      else
      git show $1
      fi
    }

  #Remove tag (bexpanded)
    function kill_tag(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease specify a tag name."
      else
      git tag $1 -d
      git push origin :refs/tags/$1
      fi
    }

  #add tags to repo -> then sync
   alias push_tags='git push --tags'

  #stashing
    #list Local Changes
      alias stashes='git stash list'
    #Save Local Changes
     alias stash='git stash save "msg"'

  #blame Who Did What when and where
    function blame(){
      if [ -z $1 ]
      then
        echo -e "\033[1;31mPlease Specify a file."
      else
        git blame $1
      fi
    }
  #branching
    #create new branch
      function branch(){
        if [ -z $1 ]
        then
          echo -e "\033[1;31mPlease specify a branch name."
        else
        git checkout -b $1
        fi
      }
    #switch to branch
      function checkout(){
         if [ -z $1 ]
          then
            echo -e "\033[1;31mPlease specify a branch name."
          else
          git checkout $1
          fi
      }
    #merge branch
      function merge(){
         if [ -z $1 ]
        then
          echo -e "\033[1;31mPlease specify a branch name."
        else
          git merge $1

          fi
        }


  #committing
    #Git pull w/o commit
    alias no_commit='git pull --no-commit'

    function commit(){
       if [ -z $1 ]
        then
          echo -e "\033[1;31mPlease specify a branch name."
        else
        git commit -am "$1"
        echo "Committed to [repoName]"
        fi
      }
  #Statuses
    alias status='git status'
    #Git Log
      function git_log(){
        git log --oneline --graph --all --decorate
      }

RPROMPT='$(battery_charge)'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git, git-extras, battery, brew, cloudapp, colorize, composer, emoji-clock, history, history-substring-search, node, osx, redis-cli, supervisor, vagrant, zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#PATHS
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/vagrant/files/bin:/usr/local/node/node-v0.10.26/bin:
# Sexy Bash Prompt, inspired by "Extravagant Zsh Prompt"
# Screenshot: http://img.gf3.ca/d54942f474256ec26a49893681c49b5a.png
# A big thanks to \amethyst on Freenode
export EDITOR='subl -w'

if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      MAGENTA=$(tput setaf 9)
      ORANGE=$(tput setaf 172)
      GREEN=$(tput setaf 190)
      PURPLE=$(tput setaf 141)
      WHITE=$(tput setaf 256)
    else
      MAGENTA=$(tput setaf 5)
      ORANGE=$(tput setaf 4)
      GREEN=$(tput setaf 2)
      PURPLE=$(tput setaf 1)
      WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*)"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

 #PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"

