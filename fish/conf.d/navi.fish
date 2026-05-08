# navi — interactive cheatsheet picker.
# Ctrl+G opens the picker; selected snippet is inserted at the cursor.

if status is-interactive
    if command -q navi
        navi widget fish | source
    end
end
