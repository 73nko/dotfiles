# rustup / cargo PATH setup.
# Newer rustup versions don't ship env.fish, so source it only if present.
# Either way, make sure ~/.cargo/bin is on PATH if it exists.
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
else if test -d "$HOME/.cargo/bin"
    fish_add_path --path --prepend "$HOME/.cargo/bin"
end
