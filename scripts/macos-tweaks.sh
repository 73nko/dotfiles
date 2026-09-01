#!/usr/bin/env bash
# ============================================================================
# macOS tweaks — Glacier Signal setup (balanced)
# ----------------------------------------------------------------------------
# Goals:
#   1. Faster, snappier UI (kill slow window animations).
#   2. Auto-hide native menu bar so SketchyBar lives alone at the top.
#   3. Sane Finder defaults (show hidden, full path, list view, no .DS_Store
#      on network/USB).
#   4. Faster key repeat for typing.
#   5. Keep transparency / blur ON — they are part of the theme.
#
# Run with:  bash ~/.config/scripts/macos-tweaks.sh
# Each line is reversible — see ~/.config/scripts/macos-tweaks-revert.sh
# ============================================================================
set -uo pipefail

say() { printf "  • %s\n" "$1"; }

echo "==> Window & app animations"
# Window resize: 0.001s instead of default ~0.2s
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
say "NSWindowResizeTime = 0.001"
# Faster Mission Control / window expose
defaults write com.apple.dock expose-animation-duration -float 0.12
say "Mission Control expose animation = 0.12s"
# Don't show Finder's "Are you sure?" warning when emptying trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false
say "Finder empty-trash warning OFF"
# Faster Save sheet animation
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
say "Save sheets default to local disk (not iCloud)"
# Disable smooth scrolling for snappier feel (kept lightly: only for non-trackpad inputs)
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool true
say "Smooth scrolling kept ON (it's nice on the trackpad)"

echo ""
echo "==> Menu bar (auto-hide so SketchyBar owns the top)"
defaults write NSGlobalDomain _HIHideMenuBar -bool true
say "Native menu bar auto-hides"

echo ""
echo "==> Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock autohide-delay -float 0.1
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mineffect -string "scale"   # no genie
defaults write com.apple.dock launchanim -bool false
say "Dock auto-hides, scale effect, no recents, no launch bounce"

echo ""
echo "==> Finder"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder QuitMenuItem -bool true              # cmd-Q quits Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
say "Finder: hidden files, full path, list view, all extensions, no .DS_Store on net/USB"

echo ""
echo "==> Screenshots"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture include-date -bool true
say "Screenshots -> ~/Pictures/Screenshots, PNG, no shadow"

echo ""
echo "==> Keyboard"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false   # no accent-popup, real key-repeat
defaults write NSGlobalDomain KeyRepeat -int 2                        # was 6
defaults write NSGlobalDomain InitialKeyRepeat -int 15                # was 25
say "Key repeat fast, accent popup off (so jjjj works in vim)"
# Keep autocorrect ON for normal typing — comment out if you hate it.
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo ""
echo "==> Trackpad / mouse"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true   # natural scroll on
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
say "Tap-to-click ON, natural scroll ON"

echo ""
echo "==> Spotlight (lighter index, fewer suggestions)"
defaults write com.apple.Spotlight orderedItems -array \
  '{"enabled" = 1; "name" = "APPLICATIONS";}' \
  '{"enabled" = 1; "name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 1; "name" = "DIRECTORIES";}' \
  '{"enabled" = 1; "name" = "PDF";}' \
  '{"enabled" = 1; "name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 0; "name" = "BOOKMARKS";}' \
  '{"enabled" = 0; "name" = "MUSIC";}' \
  '{"enabled" = 0; "name" = "MOVIES";}' \
  '{"enabled" = 0; "name" = "FONTS";}' \
  '{"enabled" = 0; "name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
  '{"enabled" = 0; "name" = "MENU_OTHER";}' \
  '{"enabled" = 0; "name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
say "Spotlight: only Apps + System Prefs + Dirs + PDFs"

echo ""
echo "==> Time Machine: don't auto-prompt for new disks"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
say "TM won't ask to back up every USB stick"

echo ""
echo "==> Activity Monitor: show all processes, sort by CPU"
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
say "Activity Monitor sorts by CPU desc"

echo ""
echo "==> Apply: restart affected services"
killall Dock 2>/dev/null
killall Finder 2>/dev/null
killall SystemUIServer 2>/dev/null
killall ControlCenter 2>/dev/null
say "Dock, Finder, SystemUIServer, ControlCenter restarted"

echo ""
echo "==> Done."
echo "    Some tweaks may need a logout/login to fully kick in."
