#!/bin/sh

# Global Domain
defaults write -globalDomain AppleShowAllFiles -bool YES
defaults write -globalDomain AppleInterfaceStyle -string Dark
defaults write -globalDomain AppleKeyboardUIMode -int 3  # Full keyboard control
defaults write -globalDomain ApplePressAndHoldEnabled -bool NO  # Disable long-press popover
defaults write -globalDomain AppleShowAllExtensions -bool YES
defaults write -globalDomain NSDocumentSaveNewDocumentsToCloud -bool NO
defaults write -globalDomain com.apple.mouse.tapBehavior -int 1  # Tap to click on trackpad
defaults write -globalDomain com.apple.trackpad.enableSecondaryClick -bool YES  # Trackpad right-click
defaults write -globalDomain AppleICUForce24HourTime -bool YES

defaults write -globalDomain NSNavPanelExpandedStateForSaveMode -bool YES
defaults write -globalDomain NSNavPanelExpandedStateForSaveMode2 -bool YES
defaults write -globalDomain PMPrintingExpandedStateForPrint -bool YES
defaults write -globalDomain PMPrintingExpandedStateForPrint2 -bool YES

defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool NO
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool NO
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -bool NO
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool NO
defaults write -globalDomain NSAutomaticSpellingCorrectionEnabled -bool NO

# Dock
defaults write com.apple.dock autohide -bool YES
defaults write com.apple.dock show-recents -bool NO

## Disable desktop hot corners
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool YES
defaults write com.apple.finder ShowStatusBar -bool YES
defaults write com.apple.finder ShowPathbar -bool YES
defaults write com.apple.finder AppleShowAllExtensions -bool YES
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool YES
defaults write com.apple.finder FXDefaultSearchScope -string SCcf  # Search in current folder
defaults write com.apple.finder FXPreferredViewStyle -string clmv  # Column view

# Screenshot
defaults write com.apple.screencapture "type" -string png

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool YES
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool YES
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool YES
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0  # Silent clicking

echo "Killing Dock to reload configuration..."
killall Dock
echo "Done."
