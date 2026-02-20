function log --wraps 'git log' --description 'Pretty git log graph'
    git log --color --graph \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' \
        --abbrev-commit $argv
end
