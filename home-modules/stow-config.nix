_: {
  home = {
    persistence."/home/seanhxx/dotfiles/stow-managed/" = {
      removePrefixDirectory = true;
      allowOther = false;
      directories = [
        "albert/.local/share/albert"
        "config/.config/albert"
      ];
    };
  };
}
