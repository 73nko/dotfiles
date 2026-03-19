# FZF integration (requires fzf >= 0.48 for --fish)
if command -q fzf
    fzf --fish 2>/dev/null | source
end
