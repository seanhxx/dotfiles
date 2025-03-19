{
  #-----------------------------------------------------------------------------
  # BASIC CONFIGURATION
  #-----------------------------------------------------------------------------
  # Enable flakes and nix-command without requiring CLI flags
  # This makes nix commands work without having to specify --experimental-features
  nixConfig.extra-experimental-features = "nix-command flakes";

  # Human-readable description of this configuration
  description = "Flake to manage seanhxx's NixOS configuration";

  #-----------------------------------------------------------------------------
  # INPUT SOURCES
  #-----------------------------------------------------------------------------
  inputs = {
    # Core Nixpkgs - Base package repositories
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Bleeding edge packages
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11"; # Stable release for reliability
    systems.url = "github:nix-systems/default"; # Default system definitions

    # Hardware support - Specialized configurations for different hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware-specific optimizations

    # Nix utilities and organization tools - Core infrastructure for the flake
    flake-utils = {
      # Utility functions for working with flakes
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems"; # Use our systems definition to avoid duplication
    };
    flake-parts.url = "github:hercules-ci/flake-parts"; # Modular flake structure
    flake-compat.url = "github:edolstra/flake-compat"; # Backward compatibility for non-flake users

    # Extended package collections - Additional software sources
    nur.url = "github:nix-community/NUR"; # Nix User Repository for community packages
    xiongchenyu6 = {
      # Personal NUR packages from xiongchenyu6
      url = "github:xiongchenyu6/nur-packages";
      inputs = {
        # Pin inputs to match our versions
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # System and configuration management - Core system tools
    impermanence.url = "github:nix-community/impermanence"; # State management for ephemeral systems
    home-manager = {
      # User environment management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use our nixpkgs to avoid conflicts
    };
    sops-nix = {
      # Secret management integration
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      # Declarative disk partitioning
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Environment and platform support - OS-specific integrations
    srvos = {
      # Server optimization packages and modules
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      # Windows Subsystem for Linux support
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    # Development tools - Programming and development environment
    nix-alien = {
      # Run unpatched dynamic binaries on NixOS
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    vscode-server = {
      # Remote VSCode server integration
      url = "github:nix-community/nixos-vscode-server";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Configuration framework - High-level system configuration
    ez-configs = {
      # Simplified config management framework
      url = "github:ehllie/ez-configs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  #-----------------------------------------------------------------------------
  # OUTPUTS
  #-----------------------------------------------------------------------------
  # Define what this flake provides to the Nix ecosystem
  outputs =
    {
      self, # Reference to this flake
      nixpkgs, # Main package collection
      flake-parts, # For modular flake composition
      ...
    }@inputs: # Capture all inputs for use throughout
    with nixpkgs; # Bring nixpkgs into scope
    with lib; # Import library functions for convenience
    let
      # Import shared variables from external file
      shares = import ./shares.nix { inherit lib; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Use flake-parts for modular structure
      imports = [
        inputs.ez-configs.flakeModule # Import ez-configs for simplified host management
      ];

      # Define which systems to support (build architectures)
      systems = [
        "x86_64-linux" # Standard 64-bit Intel/AMD
        "aarch64-linux" # ARM 64-bit (e.g., Raspberry Pi 4)
      ];

      # Host configuration using ez-configs framework
      ezConfigs = {
        globalArgs = { inherit inputs shares; }; # Pass inputs and shared vars to all configurations
        root = ./.; # Set root directory for configuration
        nixos.hosts = {
          work = {
            # Define "work" host configuration
            userHomeModules = [
              "root" # Include root user configuration
              "seanhxx" # Include personal user configuration
            ];
          };
        };
      };

      # Per-system development environment configuration
      perSystem =
        { pkgs, ... }:
        {
          packages = { }; # Define any additional packages here

          # Development shell for working on this configuration
          devShells.default = pkgs.mkShell {
            # Development tools available in the shell
            buildInputs = with pkgs; [
              sops # Secret management CLI tools
              ssh-to-age # Convert SSH keys to age format for sops
              nixfmt-rfc-style # Consistent formatting for Nix code
              nixd # Nix language server for editor integration
              yq-go # YAML processing from shell
              nixos-anywhere # Remote NixOS deployment tool
            ];
            # Setup environment when entering shell
            shellHook = ''
              export $(sops -d ./secrets/common.env | xargs)  # Load encrypted environment variables
            '';
          };
        };
    };
}
