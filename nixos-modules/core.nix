# Core NixOS Configuration
#
# This module defines the fundamental system settings and forms the base
# for all system configurations.
{ pkgs, lib, ... }:
{
  #-----------------------------------------------------------------------------
  # BASIC SYSTEM CONFIGURATION
  #-----------------------------------------------------------------------------

  # Allow proprietary software (needed for certain drivers and applications)
  nixpkgs.config = {
    # allowBroken = true;  # Enable only if you need to install broken packages
    allowUnfree = true; # Allow proprietary software installations
  };

  # System state version - DO NOT CHANGE after initial setup
  # This is used by NixOS to handle backwards compatibility
  system.stateVersion = "24.11";

  # Time zone configuration
  time.timeZone = "Asia/Singapore";

  # Internationalization and localization settings
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8" # Chinese (Simplified)
      "en_US.UTF-8/UTF-8" # English (US)
    ];
    # Consider adding input method settings for Chinese input if needed
  };

  #-----------------------------------------------------------------------------
  # NETWORK CONFIGURATION
  #-----------------------------------------------------------------------------

  networking = {
    # Set domain for the system - used for hostname resolution
    domain = "seanhxx.work";

    # Enable nftables firewall backend (modern replacement for iptables)
    # More secure and performant than legacy iptables
    nftables.enable = true;

    # Additional networking options to consider:
    # networkmanager.enable = true;  # Enable NetworkManager for network management
    # firewall = {
    #   enable = true;               # Enable the firewall
    #   allowedTCPPorts = [ 22 80 ]; # Open specific TCP ports
    # };
  };

  #-----------------------------------------------------------------------------
  # ENVIRONMENT CONFIGURATION
  #-----------------------------------------------------------------------------

  environment = {
    # PPP configuration for network connections
    # ipcp-accept-remote allows the system to accept remote IP address offers
    # This is useful for certain VPN and PPP dialup configurations
    etc = {
      "ppp/options".text = ''
        ipcp-accept-remote
      '';
    };

    # Consider adding system-wide packages here:
    # systemPackages = with pkgs; [
    #   vim
    #   git
    #   wget
    #   curl
    # ];
  };

  #-----------------------------------------------------------------------------
  # SHELL & PROGRAM CONFIGURATION
  #-----------------------------------------------------------------------------

  programs = {
    # Enable ZSH system-wide as an alternative to bash
    zsh.enable = true;

    # Other useful program options to consider:
    # ssh.startAgent = true;      # Auto-start SSH agent
    # gnupg.agent.enable = true;  # Enable GnuPG agent
    # vim.defaultEditor = true;   # Use vim as default editor
  };

  #-----------------------------------------------------------------------------
  # NIX PACKAGE MANAGER CONFIGURATION
  #-----------------------------------------------------------------------------

  nix = {
    # Process priority settings for nix daemon to prevent system slowdowns during builds
    daemonCPUSchedPolicy = "idle"; # Lower CPU priority for nix-daemon
    daemonIOSchedClass = "idle"; # Lower I/O priority for nix-daemon

    # Store optimization settings for better storage efficiency
    optimise = {
      automatic = true; # Automatically optimize the nix store
    };

    # Garbage collection settings to prevent store from growing too large
    gc = {
      automatic = true; # Run GC automatically
      randomizedDelaySec = "1h"; # Add random delay to prevent spike loads
      options = "--delete-older-than 1d"; # Keep only 1 day of history
      # dates = "weekly";             # Alternative: run on a schedule
    };

    # Enable distributed builds for faster compilation across multiple machines
    distributedBuilds = lib.mkDefault true;

    # Advanced Nix settings
    settings =
      let
        # Get GitHub access token from environment
        # This is needed for fetching private repositories
        githubAccessToken = builtins.getEnv "Github_Access_Token";
      in
      if githubAccessToken == "" then
        throw "Github_Access_Token environment variable is not set"
      else
        {
          # Configure GitHub access for private repositories
          access-tokens = "github.com=${githubAccessToken}";

          # Enable automatic store optimization
          auto-optimise-store = true;

          # Enable Nix experimental features
          accept-flake-config = true; # Accept flake-specific configuration
          allow-import-from-derivation = true; # Allow IFD for more flexible expressions
          experimental-features = [
            "nix-command" # Enable enhanced nix command line tools
            "flakes" # Enable flakes for reproducible development
            "ca-derivations" # Content-addressed derivations for better caching
            "parse-toml-timestamps" # TOML timestamp parsing support
          ];

          # User permissions for Nix operations
          trusted-users = [
            "seanhxx" # Allow these users to perform privileged operations
          ];
          allowed-users = [
            "root" # Standard system users
            "seanhxx" # Your personal user
          ];

          # Binary caches for faster builds - avoid building from source
          substituters = [
            "https://xiongchenyu6.cachix.org" # Personal/team cache
            # "https://cache.nixos.org"          # Default NixOS cache (implicit)
          ];
          trusted-public-keys = [
            "xiongchenyu6.cachix.org-1:mpOGlINmMwc2gb3xb1BjVmhzR8BYWzWYlg4xlTiBr7Q="
          ];
        };
  };

  # Consider adding these sections as needed:
  # - users.users.<name> - User configurations
  # - services.<service> - Service configurations
  # - hardware.<device> - Hardware-specific settings
}
