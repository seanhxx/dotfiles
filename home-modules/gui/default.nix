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

  xdg = {
    mimeApps = {
      defaultApplications = {
        # "text/html" = "microsoft-edge.desktop";
        # "text/x-csharp" = [ "rider.desktop" ];
        # "x-scheme-handler/http" = "microsoft-edge.desktop";
        # "x-scheme-handler/https" = "microsoft-edge.desktop";
        # "x-scheme-handler/about" = "microsoft-edge.desktop";
        # "x-scheme-handler/unknown" = "microsoft-edge.desktop";
        "text/html" = "google-chrome.desktop";
        "text/x-csharp" = [ "rider.desktop" ];
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
      };
    };
  };

  qt = {
    enable = true;
  };

  home = lib.mkIf pkgs.stdenv.isLinux {
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      x11 = {
        enable = true;
      };
      size = 32;
    };
    packages = with pkgs; [

      # 1. Text, File & Shell Utilities
      aspell
      aspellDicts.en
      file
      envsubst
      fd
      ripgrep
      shellcheck
      shfmt
      unzip
      wget
      killall
      du-dust
      tealdeer

      # 2. System Monitoring & Hardware Info
      htop
      lshw
      hwinfo
      glxinfo
      neofetch
      tmux

      # 3. Development Tools & IDEs
      # android-studio
      github-copilot-cli
      delve # Go debugger
      litecli
      mongosh
      mycli
      my2sql
      (python3.withPackages (
        _: with python3.pkgs; [
          pip
          aider-chat
        ]
      ))
      bun
      yarn2nix
      ruby
      rustscan
      wakatime

      # 4. Container & Kubernetes Ecosystem
      # kube-capacity
      # kube-prompt
      # kubectl
      # kubectl-tree
      # kubespy
      # kubeshark
      # kustomize
      # krew
      # kconf
      # kube-score
      # kubelogin-oidc
      # calicoctl
      # (kubernetes-helm-wrapped.override { plugins = [ kubernetes-helmPlugins.helm-diff ]; })
      # popeye
      # dive # Docker image analyzer

      # 5. Cloud, Networking & Infrastructure
      cloudflared
      netbird-ui
      fluxcd
      # weave-gitops
      # grpcurl
      # s3cmd
      socat
      sshpass
      dig
      websocat
      glab
      hey

      # 6. Media, Graphics & Design
      # gimp
      # blender
      # godot_4
      # plantuml
      ffmpeg-full
      graphviz

      # 7. Communication, Productivity & Launchers
      albert
      termius
      tdesktop
      # whatsapp-for-linux
      zotero
      ledger-live-desktop

      # 8. Desktop, Windowing & Environment Integration
      # wineWow64Packages.wayland
      # kdePackages.dolphin
      # kdePackages.qtwayland
      # kdePackages.qt6ct
      # libsForQt5.oxygen-icons
      # code-cursor
      vulkan-loader

      # 9. Security, Encryption & Secrets Management
      libsecret
      openssl
      sops
      oath-toolkit
      gitleaks
      solc-select
      yubikey-manager
      yubico-piv-tool
      vulnix
      age

      # 10. Database & Data Management
      redis
      pgcli
      qrencode

      # 11. Miscellaneous/System Integration & Nix Utils
      cmctl
      nix-melt
      nix-index-update
      nixpacks
      nixd
      nvfetcher
    ];
    sessionVariables = {
      STARSHIP_LOG = "error";
    };
  };

  gtk = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    gtk4 = {
      extraConfig = {
        gtk-cursor-blink = false;
        gtk-recent-files-limit = 20;
      };
    };
  };

  i18n = lib.mkIf pkgs.stdenv.isLinux {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          #fcitx5-mozc
          fcitx5-gtk
          fcitx5-chinese-addons
          fcitx5-rime
        ];
      };
    };
  };
  programs = {
    nh = {
      enable = true;
      flake = "/home/seanhxx/dotfiles";
    };
    wofi = {
      enable = true;
    };
    # carapace.enable = true;
    # comodoro.enable = true;
    mpv.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
      ];
    };
    # thunderbird = {
    #   enable = true;
    #   profiles = {
    #     "xiongchenyu6@gmail.com" = {
    #       isDefault = true;
    #       withExternalGnupg = true;
    #     };
    #   };
    # };

    vscode = {
      enable = true;
    };

    chromium = {
      enable = true;
      package = pkgs.microsoft-edge;
    };

    password-store = {
      enable = true;
    };
  };

  services = lib.mkIf pkgs.stdenv.isLinux {
    # safeeyes.enable = true;
    #    ssh-agent.enable = true;

    pasystray = {
      enable = true;
    };
    poweralertd = {
      enable = true;
    };

    dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = "16x16";
      };
      settings = {
        global = {
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

    blueman-applet = {
      enable = true;
    };
    # dropbox = {
    #   enable = false;
    # };
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "always";
    };
    # syncthing = {
    #   enable = true;
    #   tray = {
    #     enable = true;
    #   };
    # };
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
