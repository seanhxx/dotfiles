{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    packages = with pkgs; [
      # Dev Tools
      nixd
      yaml-language-server
      lazygit
      lazydocker
      solana-cli
      v4l-utils

      # Terminal Utils
      (warp-terminal.override { waylandSupport = true; })
      mdcat
      lnav
      ncdu
      sysz
      kmon
      gpg-tui
      # ueberzugpp
      # ytfzf
      # termshark

      # Apps
      google-chrome
      microsoft-edge
      slack
      zoom-us
      onlyoffice-bin
      # tectonic
      # xournalpp

      # System & Cloud Tools
      doctl
      gdrive
      freerdp
      lego
      usbutils
      appimage-run
      record_screen
    ];
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        # opacity = 0.9;
        font = {
          size = 10;
          normal = {
            family = "JetBrainsMono Nerd Font";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
          };
        };
        cursor = {
          style = {
            shape = "Beam";
            blinking = "Always";
          };
        };
        keyboard = {
          bindings = [
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
    };

    noti = {
      enable = true;
    };

  };
}
