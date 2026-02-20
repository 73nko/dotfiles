function ssh --wraps ssh --description 'ssh with TERM=xterm-256color to fix color issues'
    env TERM=xterm-256color command ssh $argv
end
