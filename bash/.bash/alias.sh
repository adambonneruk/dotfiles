
#A
#B
#C
alias clip='xclip -selection clipboard'
alias clock='tty-clock -s -c -C 2'
alias cls='clear'
alias ctop='docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'
#D
alias dc='docker-compose'
alias dcu='docker-compose pull && docker-compose up -d --remove-orphans && docker image prune -f'
#E
alias explorer='nemo'
#F
#G
#H
#I
#J
#K
alias graph='git log --oneline --graph --all'
#L
alias l='lslhoctal'
alias la='lslhoctal -a'
alias lg='lazygit'
alias ll='ls -lah'
alias lll='ls -lh'
alias ls='ls --color=auto'
#M
alias md5='md5sum --ignore-missing -c'
#N
#O
#P
alias packages='dpkg -l | awk '\''{print $2}'\'' | tail -n +6'
alias py='python3'
#Q
#R
#S
alias sha1='sha1sum --ignore-missing -c'
alias sha2='sha256sum --ignore-missing -c'
alias sha5='sha512sum --ignore-missing -c'
alias start='~/.bash/logon.sh'
#T
#U
#V
#X
#Y
#Z
