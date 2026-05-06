#!/usr/bin/env bash
# Reverts everything ~/.config/scripts/macos-tweaks.sh applied.
# Restores macOS defaults by deleting the keys we wrote.
set -uo pipefail

defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null
defaults delete com.apple.dock expose-animation-duration 2>/dev/null
defaults delete com.apple.finder WarnOnEmptyTrash 2>/dev/null
defaults delete NSGlobalDomain NSDocumentSaveNewDocumentsToCloud 2>/dev/null
defaults delete NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null
defaults write NSGlobalDomain _HIHideMenuBar -bool false
defaults delete com.apple.dock autohide 2>/dev/null
defaults delete com.apple.dock autohide-time-modifier 2>/dev/null
defaults delete com.apple.dock autohide-delay 2>/dev/null
defaults delete com.apple.dock magnification 2>/dev/null
defaults delete com.apple.dock show-recents 2>/dev/null
defaults delete com.apple.dock minimize-to-application 2>/dev/null
defaults delete com.apple.dock mineffect 2>/dev/null
defaults delete com.apple.dock launchanim 2>/dev/null
defaults delete com.apple.finder ShowPathbar 2>/dev/null
defaults delete com.apple.finder ShowStatusBar 2>/dev/null
defaults delete com.apple.finder _FXShowPosixPathInTitle 2>/dev/null
defaults delete com.apple.finder AppleShowAllFiles 2>/dev/null
defaults delete com.apple.finder FXPreferredViewStyle 2>/dev/null
defaults delete com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null
defaults delete com.apple.finder QuitMenuItem 2>/dev/null
defaults delete NSGlobalDomain AppleShowAllExtensions 2>/dev/null
defaults delete com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null
defaults delete com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null
defaults delete com.apple.screencapture location 2>/dev/null
defaults delete com.apple.screencapture type 2>/dev/null
defaults delete com.apple.screencapture disable-shadow 2>/dev/null
defaults delete com.apple.screencapture include-date 2>/dev/null
defaults delete NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null
defaults delete NSGlobalDomain KeyRepeat 2>/dev/null
defaults delete NSGlobalDomain InitialKeyRepeat 2>/dev/null
defaults delete com.apple.Spotlight orderedItems 2>/dev/null
defaults delete com.apple.TimeMachine DoNotOfferNewDisksForBackup 2>/dev/null

killall Dock Finder SystemUIServer ControlCenter 2>/dev/null
echo "Reverted. May need logout/login to fully restore."
