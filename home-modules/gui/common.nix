{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    packages = with pkgs; [
      # 1. Nix Ecosystem Tools
      nix-index-update # Package content index
      nvfetcher # Version update helper

      # 2. CLI Tools
      ## File and Text Management
      fd # Find alternative
      file # File type identifier
      ripgrep # Grep alternative
      wget # Download files
      unzip # Extract archives
      aspell # Spell checker
      aspellDicts.en # English dictionary
      envsubst # Env variable substitution
      lnav # Log file navigator

      ## System Management
      htop # Process viewer
      tmux # Terminal multiplexer
      killall # Process killer
      du-dust # Disk usage analyzer
      ncdu # Disk usage visualizer
      tealdeer # Command examples
      sysz # Systemd unit manager
      kmon # Kernel module manager

      ## Network Tools
      dig # DNS lookup
      socat # Socket utility
      websocat # WebSocket client
      cloudflared # Cloudflare tunnel
      rustscan # Fast port scanner
      hey # HTTP load tester

      ## Security Tools
      openssl # SSL toolkit
      sops # Secrets management
      oath-toolkit # OATH authentication
      age # File encryption
      cmctl # Certificate manager
      cryptsetup

    ];
  };

  programs = {
  };
}
