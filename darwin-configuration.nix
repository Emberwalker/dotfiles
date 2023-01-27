{ config, pkgs, ... }:

{
  environment.darwinConfig = "$HOME/dotfiles/darwin-configuration.nix";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      config.services.skhd.package
      config.services.yabai.package
      pkgs.vim
    ];

  # macOS Defaults
  ## Common components
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;  # Full keyboard control
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;  # Disable long-press popover
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;  # Show file extensions
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;  # Don't default to save-to-iCloud
  system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;  # Tap to click on trackpads
  system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;  # Trackpad right-click
  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;

  ## Default expand save/print pages
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

  ## Disable typing helpers
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

  ## Dock
  system.defaults.dock.autohide = true;
  system.defaults.dock.show-recents = true;

  ## Disable hot corners
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;

  ## Finder
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.FXDefaultSearchScope = "SCcf";  # Default to searching current folder
  system.defaults.finder.FXPreferredViewStyle = "clmv";  # Default to column view

  ## Screenshot tool
  system.defaults.screencapture.type = "png";

  ## Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  ## Trackpad
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;
  system.defaults.trackpad.ActuationStrength = 0;  # Silent clicks

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Enable the Nix Daemon (required for macOS)
  services.nix-daemon.enable = true;

  # skhd + Yabai
  services.skhd.enable = true;
  services.skhd.package = pkgs.skhd;
  services.skhd.skhdConfig = ''
    # focus window
    alt - h : yabai -m window --focus west
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - l : yabai -m window --focus east

    # swap window
    shift + alt - h : yabai -m window --swap west
    shift + alt - j : yabai -m window --swap south
    shift + alt - k : yabai -m window --swap north
    shift + alt - l : yabai -m window --swap east

    # move window
    shift + cmd - h : yabai -m window --warp west
    shift + cmd - j : yabai -m window --warp south
    shift + cmd - k : yabai -m window --warp north
    shift + cmd - l : yabai -m window --warp east

    # balance size of windows
    shift + alt - 0 : yabai -m space --balance

    # make floating window fill screen
    shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1

    # make floating window fill left-half of screen
    shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1

    # make floating window fill right-half of screen
    shift + alt - right  : yabai -m window --grid 1:2:1:0:1:1

    # move window
    shift + ctrl - a : yabai -m window --move rel:-20:0
    shift + ctrl - s : yabai -m window --move rel:0:20
    shift + ctrl - w : yabai -m window --move rel:0:-20
    shift + ctrl - d : yabai -m window --move rel:20:0

    # increase window size
    shift + alt - a : yabai -m window --resize left:-20:0
    shift + alt - s : yabai -m window --resize bottom:0:20
    shift + alt - w : yabai -m window --resize top:0:-20
    shift + alt - d : yabai -m window --resize right:20:0

    # decrease window size
    shift + cmd - a : yabai -m window --resize left:20:0
    shift + cmd - s : yabai -m window --resize bottom:0:-20
    shift + cmd - w : yabai -m window --resize top:0:20
    shift + cmd - d : yabai -m window --resize right:-20:0

    # set insertion point in focused container
    ctrl + alt - h : yabai -m window --insert west
    ctrl + alt - j : yabai -m window --insert south
    ctrl + alt - k : yabai -m window --insert north
    ctrl + alt - l : yabai -m window --insert east

    # punt window to other screens
    ctrl + cmd - z  : yabai -m window --display prev
    ctrl + cmd - c  : yabai -m window --display next
    ctrl + alt + cmd - 1  : tabai -m window --display 1
    ctrl + alt + cmd - 2  : tabai -m window --display 2
    ctrl + alt + cmd - 3  : tabai -m window --display 3

    # rotate tree
    alt - r : yabai -m space --rotate 90

    # mirror tree y-axis
    alt - y : yabai -m space --mirror y-axis

    # mirror tree x-axis
    alt - x : yabai -m space --mirror x-axis

    # toggle desktop offset
    alt - a : yabai -m space --toggle padding; yabai -m space --toggle gap

    # toggle window parent zoom
    alt - d : yabai -m window --toggle zoom-parent

    # toggle window fullscreen zoom
    alt - f : yabai -m window --toggle zoom-fullscreen

    # toggle window native fullscreen
    shift + alt - f : yabai -m window --toggle native-fullscreen

    # toggle window border
    shift + alt - b : yabai -m window --toggle border

    # toggle window split type
    alt - e : yabai -m window --toggle split

    # float / unfloat window and center on screen
    alt - t : yabai -m window --toggle float;\
              yabai -m window --grid 4:4:1:1:2:2

    # change layout of desktop
    ctrl + alt - a : yabai -m space --layout bsp
    ctrl + alt - d : yabai -m space --layout float
  '';

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.config = {
    mouse_follows_focus = "off";
    focus_follows_mouse = "off";
    window_placement = "second_child";
    window_topmost = "off";
    window_opacity = "off";
    window_opacity_duration = "0.0";
    window_shadow = "on";
    window_border = "on";
    window_border_width = "2";
    active_window_border_color = "0xff775759";
    normal_window_border_color = "0xff505050";
    insert_window_border_color = "0xffd75f5f";
    active_window_opacity = "1.0";
    normal_window_opacity = "0.9";
    split_ratio = "0.5";
    auto_balance = "off";
    mouse_modifier = "fn";
    mouse_action1 = "move";
    mouse_action2 = "resize";

    layout = "bsp";
    top_padding = 5;
    bottom_padding = 5;
    left_padding = 5;
    right_padding = 5;
    window_gap = 5;
  };
  services.yabai.extraConfig = ''
    yabai -m rule --add app="^System Preferences$" manage=off
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
