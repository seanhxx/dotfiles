# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }:
{
  home = lib.mkIf pkgs.stdenv.isLinux {
    packages = with pkgs; [
      grim
      slurp
      brightnessctl
      hyprpicker
      wl-clipboard
      wf-recorder # screen recording
      wev # get input events
      waypipe
    ];

    sessionVariables = {
      NIX_LD = toString (
        pkgs.runCommand "ld.so" { } ''
          ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
        ''
      );
      INPUT_METHOD = "fcitx";
      XIM_SERVERS = "fcitx";
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      EDITOR = "vim"; # Added default editor
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      monitor = [
        "DP-2, 2560x1440@60, 0x0, 1.6, transform, 0" # Dell monitor at top with lower resolution
        "eDP-1, 2560x1600@60, 0x900, 1.6, transform, 0" # Laptop with 1.6x scaling for larger fonts
      ];

      workspace = [
        "DP-2, 1" # Assign workspace 1 to Dell
        "eDP-1, 2" # Assign workspace 2 to built-in
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        repeat_rate = 40;
        repeat_delay = 300;
        follow_mouse = 1;
        sensitivity = 1.0;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
        };

      };

      general = {
        gaps_in = 5;
        gaps_out = 15;
        border_size = 2;
        "col.active_border" = "rgba(1affffee)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";

        env = [
          "XCURSOR_SIZE,32"
        ];
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, return, exec, alacritty"
        "$mod, X, exec, albert toggle"
        "$mod, C, killactive"
        "$mod, L, exec, hyprlock"
        "$mod shift, 1, exec, hyprctl dispatch workspace 1" # Switch to workspace 1
        "$mod shift, 2, exec, hyprctl dispatch workspace 2" # Switch to workspace 2
        "$mod shift, 3, exec, hyprctl dispatch workspace 3" # Switch to workspace 3
        "$mod shift, 4, exec, hyprctl dispatch workspace 4" # Switch to workspace 4
        "$mod shift, 5, exec, hyprctl dispatch workspace 5" # Switch to workspace 5
        "$mod shift, 6, exec, hyprctl dispatch workspace 6" # Switch to workspace 6
        "$mod shift, 7, exec, hyprctl dispatch workspace 7" # Switch to workspace 7
        "$mod shift, 8, exec, hyprctl dispatch workspace 8" # Switch to workspace 8
        "$mod shift, 9, exec, hyprctl dispatch workspace 9" # Switch to workspace 9
        "$mod shift, Left, exec, hyprctl dispatch workspace prev hist" # Switch to previous workspace

        # Add these bindings to send windows to specific workspaces with middle mouse button
        "$mod ctrl, 1, movetoworkspace, 1"
        "$mod ctrl, 2, movetoworkspace, 2"
        "$mod ctrl, 3, movetoworkspace, 3"
        "$mod ctrl, 4, movetoworkspace, 4"
        "$mod ctrl, 5, movetoworkspace, 5"
        "$mod ctrl, 6, movetoworkspace, 6"
        "$mod ctrl, 7, movetoworkspace, 7"
        "$mod ctrl, 8, movetoworkspace, 8"
        "$mod ctrl, 9, movetoworkspace, 9"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"

      ];

      exec-once = [
        "albert"
        "netbird-ui"
        "nm-applet" # Network manager tray icon
        "blueman-applet" # Bluetooth manager
        "pasystray" # PulseAudio system tray
      ];

      windowrulev2 = [
        "float,class:^(albert)$"
        "noblur,class:^(albert)$"
        "noshadow,class:^(albert)$"
        "noborder,class:^(albert)$"
        "pseudo,class:^(albert)$"
        "dimaround,class:^(albert)$"
        "opacity 0.9 0.95,class:^(Alacritty)$"
      ];
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

  };

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };

    waybar = {
      enable = true;
      systemd = {
        enable = true;
      };
      style = ./waybar.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 30;
          spacing = 2;

          output = [
            "eDP-1"
            "DP-2"
          ];
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "wlr/taskbar"
            "backlight"
            "pulseaudio"
            "clock"
            "battery"
            "tray"
          ];

          # Add custom settings for the workspaces module
          "hyprland/workspaces" = {
            "on-click" = "activate";
            "on-scroll-up" = "hyprctl dispatch workspace e-1";
            "on-scroll-down" = "hyprctl dispatch workspace e+1";
          };

          # Add this configuration block for the taskbar module
          "wlr/taskbar" = {
            # "on-click" = "minimize-raise"; # Left click activates the window
            "on-click-middle" = "close"; # Middle click closes the window
            # "on-click-right" = "maximize"; # Right click minimizes/restores
            "icon-size" = 16;
            "tooltip" = true;
            "tooltip-format" = "{title}";
            "active-first" = true;
            "all-outputs" = false; # Only show windows from current monitor
          };

          # Add this configuration block for the clock module
          "clock" = {
            "format" = "{:%H:%M}";
            "tooltip-format" = "{:%Y-%m-%d | %A | %B %d, %Y}";
            "tooltip" = true;
          };

          # Add this configuration block for the tray module
          "tray" = {
            "spacing" = 10;
            "icon-size" = 18;
            "show-passive-items" = true;
          };

        };
      };
    };
  };
}
