# pay-respects - fast command correction (Rust replacement for thefuck)
# Usage: mistype a command, then press F to fix it
if command -q pay-respects
    pay-respects fish --alias f | source
end
