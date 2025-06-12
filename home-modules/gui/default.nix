# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./common.nix ];

  # ===== DISPLAY ENVIRONMENT CONFIGURATION =====

  # Desktop environment integration
  qt.enable = true;

  # GTK configuration
  gtk = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    gtk4.extraConfig = {
      gtk-cursor-blink = false;
      gtk-recent-files-limit = 20;
    };
  };

  # Input method configuration
  i18n = lib.mkIf pkgs.stdenv.isLinux {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-rime
      ];
    };
  };

  # Cursor configuration
  home = lib.mkIf pkgs.stdenv.isLinux {
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      x11.enable = true;
      size = 32;
    };

    sessionVariables = {
      STARSHIP_LOG = "error";
    };

    # ===== PACKAGES =====
    packages = with pkgs; [
      # GUI Applications
      ## Browsers
      google-chrome
      microsoft-edge

      ## Office & Productivity
      onlyoffice-bin
      libreoffice-qt
      hunspell

      ## Communication & Collaboration
      slack
      zoom-us
      tdesktop # Telegram desktop client
      feishu-lark

      ## System GUI Tools
      albert # Application launcher
      ledger-live-desktop
      (warp-terminal.override { waylandSupport = true; })
      netbird-ui
      gpg-tui

      ## Remote Desktop & Administration
      termius # SSH client with GUI
      freerdp # Remote desktop client

      # CLI Development Tools
      ## Language Support & Tools
      delve # Go debugger
      bun
      yarn2nix
      ruby
      solana-cli
      solc-select
      yaml-language-server

      ## Version Control & Development
      lazygit
      lazydocker
      gitleaks
      nixd
      shellcheck
      shfmt

      ## Database Tools
      litecli
      mongosh
      mycli
      my2sql
      redis
      pgcli

      # System Utilities
      ## Hardware Tools
      usbutils
      v4l-utils
      yubikey-manager
      yubico-piv-tool

      ## Network Tools
      sshpass
      lego

      # Media & Document Processing
      ffmpeg-full
      graphviz
      mdcat
      qrencode

      # System Management
      libsecret
      nix-melt
      nixpacks
      vulnix
      powertop
      tlp

      # System Information
      neofetch
      glxinfo
      lshw
      hwinfo
    ];
  };

  # ===== APPLICATION ASSOCIATIONS =====

  xdg = {
    enable = true;
    #TODO screen capture seems only works in nixos modules, but here for xdg-open
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      # Add this configuration to address the warning about xdg-desktop-portal 1.17+
      config = {
        common = {
          default = "*";
        };
      };
    };
    mime = {
      enable = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "text/x-csharp" = [ "rider.desktop" ];
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_MISC_DIR = "${config.home.homeDirectory}/Misc";
        XDG_TEST_DIR = "${config.home.homeDirectory}/Test";
        XDG_GIT_DIR = "${config.home.homeDirectory}/Git";
        XDG_PRIVATE_DIR = "${config.home.homeDirectory}/Private";
        XDG_WORKSPACE_DIR = "${config.home.homeDirectory}/Workspace";
      };
    };
  };

  # Application-specific settings
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # ===== PROGRAM CONFIGURATIONS =====

  programs = {
    # GUI Applications
    vscode.enable = true;
    wofi.enable = true;
    mpv.enable = true;

    # Terminal Emulators
    alacritty = {
      enable = true;
      settings = {
        font = {
          size = 10;
          normal.family = "JetBrainsMono Nerd Font";
          bold.family = "JetBrainsMono Nerd Font";
          italic.family = "JetBrainsMono Nerd Font";
          bold_italic.family = "JetBrainsMono Nerd Font";
        };
        cursor.style = {
          shape = "Beam";
          blinking = "Always";
        };
        keyboard.bindings = [
          {
            key = "Space";
            mods = "Control|Shift";
            mode = "~Search";
            action = "ToggleViMode";
          }
          {
            key = "Return";
            mods = "Command|Shift";
            action = "SpawnNewInstance";
          }
        ];
      };
    };

    # System Utilities
    nh = {
      enable = true;
      flake = "/home/seanhxx/dotfiles";
    };
    noti.enable = true;
    password-store.enable = true;
  };

  # ===== SYSTEM SERVICES =====

  services = lib.mkIf pkgs.stdenv.isLinux {
    # GUI Services
    pasystray.enable = true;
    blueman-applet.enable = true;

    # Power Management
    poweralertd.enable = true;

    # Disk Management
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "always";
    };

    # Notifications
    dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = "16x16";
      };
      settings.global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "JetBrainsMono Nerd Font";
        line_height = 4;
        format = "<b>%s</b>\\n%b";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -i -p dunst";
      };
    };
  };
}
