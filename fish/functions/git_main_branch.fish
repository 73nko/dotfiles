function git_main_branch --description 'Print the main branch name (main or master)'
    # Intenta leer desde el remote
    set -l branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if test -n "$branch"
        echo $branch
        return
    end
    # Fallback: comprueba si existe main o master localmente
    if git show-ref --verify --quiet refs/heads/main
        echo main
    else if git show-ref --verify --quiet refs/heads/master
        echo master
    else
        echo main
    end
end
