{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      config = {
        common = {
          default = "*";
        };
      };
      wlr = {
        enable = true;
      };
      lxqt = {
        enable = true;
      };
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
