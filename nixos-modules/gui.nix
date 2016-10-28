# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  qt = {
    enable = true;
  };
  xdg.icons.enable = true;

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        serif = [ "JetBrainsMono Nerd Font" ];
      };
    };

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  security = {
    tpm2 = {
      enable = true;
      abrmd.enable = true;
      pkcs11.enable = true;
      tctiEnvironment = {
        enable = true;
        interface = "tabrmd";
      };
    };
  };

  services = {
    usbmuxd.enable = true;

    usbguard = {
      enable = false;
      IPCAllowedUsers = [
      ];
      rules = '''';
    };

    dbus = {
      enable = true;
    };

    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };

  };

  programs = {
    dconf = {
      enable = true;
    };
    yubikey-touch-detector = {
      enable = true;
    };
    nm-applet = {
      enable = true;
    };
    wireshark = {
      enable = true;
    };
  };
}
