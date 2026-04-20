#!/usr/bin/env fish

# Install Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Plugins
fisher install jhillyerd/plugin-git
fisher install IlanCosman/tide@v63