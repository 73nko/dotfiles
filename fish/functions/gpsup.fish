function gpsup --description 'git push --set-upstream origin <current branch> (oh-my-zsh: gpsup)'
    git push --set-upstream origin (git branch --show-current)
end
