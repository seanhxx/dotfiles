# Edit
{
  inputs,
  lib,
  ezModules,
  config,
  pkgs,
  mylib,
  shares,
  ...
}:
{
  imports = with inputs; [
    ./hardware-configuration.nix
    ezModules.root
    ezModules.seanhxx
    ezModules.misc
    ezModules.client-cli
    ezModules.gui
    ezModules.core
    ezModules.greetd
    # #ezModules.datadog-agent
    ezModules.virtualisation
    nixos-hardware.nixosModules.lenovo-legion-16ach6h
    srvos.nixosModules.desktop
    vscode-server.nixosModules.default
    srvos.nixosModules.mixins-trusted-nix-caches
    srvos.nixosModules.mixins-nix-experimental
    srvos.nixosModules.mixins-tracing
    xiongchenyu6.nixosModules.falcon-sensor
  ];

  sops.secrets."falcon/cid" = { };

  # Enable users/freeman gui
  system.nixos.tags = [
    "nvidia"
    "gui"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    nvidia = {
      forceFullCompositionPipeline = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false;
      prime.offload.enable = false;
    };
  };

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot = {
        configurationLimit = 12;
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  networking =
    let
      file-path = builtins.split "/" (toString ./.);
      hostName = lib.last file-path;
    in
    {
      inherit hostName;
      firewall = {
        enable = false;
        allowedTCPPorts = [
          89
          179
          5002
        ];
        allowedUDPPorts = [
          89
          179
          5353
          6696
          33434
        ];
        interfaces.wg_mail.allowedTCPPorts = [
          22
          8080
        ];
      };

      networkmanager = {
        enable = true;
        wifi = {
          powersave = true;
        };
      };
      enableIPv6 = true;
      useDHCP = lib.mkDefault true;
    };

  services = {
    falcon-sensor = {
      enable = true;
      cidFile = config.sops.secrets."falcon/cid".path;
      traceLevel = "debug";
    };
    greetd = {
      settings = {
        initial_session = {
          user = "seanhxx";
          command = lib.mkDefault "Hyprland";
        };
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mysql80; # Use MySQL 8.0, or pkgs.mariadb for MariaDB

      # Basic settings
      dataDir = "/var/lib/mysql"; # Default location

      # User configuration - create a user matching your system user
      ensureUsers = [
        {
          name = "seanhxx";
          ensurePermissions = {
            "seanhxx.*" = "ALL PRIVILEGES";
            "*.seanhxx" = "ALL PRIVILEGES";
          };
        }
      ];

      # Create an initial database
      ensureDatabases = [ "seanhxx" ];

      # Initial root password can be set with mysql.initialPassword
      # Do NOT use this in production as it's stored in the Nix store!
      # initialPassword = "change-me";

      # Performance and configuration settings
      settings = {
        mysqld = {
          # General settings
          character-set-server = "utf8mb4";
          collation-server = "utf8mb4_unicode_ci";

          # Basic performance tuning
          innodb_buffer_pool_size = "128M";
          max_connections = 100;

          # Security
          local-infile = 0;

          # Networking (listen only on localhost)
          bind-address = "127.0.0.1";
        };
      };
    };

    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "seanhxx";
          ensureDBOwnership = true;
          ensureClauses = {
            superuser = true;
          };
        }
      ];
      ensureDatabases = [ "seanhxx" ];
    };

    netbird = {
      enable = true;
    };

    elasticsearch = {
      enable = true;
      # Use the package you have available (e.g., pkgs.elasticsearch or pkgs.elasticsearch7)
      package = pkgs.elasticsearch7;

      # Configure a single-node cluster for development
      single_node = true;

      # Basic configuration
      cluster_name = "work-cluster";

      # Network settings
      listenAddress = "127.0.0.1"; # Listen on localhost only
      port = 9200; # Default HTTP port
      tcp_port = 9300; # Default transport port

      # Add the ingest-attachment plugin here
      plugins = [
        pkgs.elasticsearch7Plugins.ingest-attachment
      ];

      # Optional: Performance tuning
      extraJavaOptions = [
        "-Xms512m"
        "-Xmx512m"
      ];

      # Additional configuration if needed
      extraConf = ''
        xpack.security.enabled: false
        path.logs: /var/log/elasticsearch
        discovery.seed_hosts: ["127.0.0.1"]
      '';
    };

    redis = {
      servers = {
        default = {
          enable = true;
          port = 6379;
          bind = "127.0.0.1";
          databases = 16; # Default number of databases
          appendOnly = true; # Enable AOF persistence
          appendFsync = "everysec"; # Fsync every second for durability

          # Optional settings that you might want:
          # requirePassFile = "/run/secrets/redis-password";
          # openFirewall = false;  # Don't open ports in firewall by default

          # Performance tuning
          settings = {
            "maxmemory" = "256mb";
            "maxmemory-policy" = "allkeys-lru"; # Eviction policy
          };
        };
      };
    };
  };

  home-manager = {
    users = {
      "seanhxx" = {
        programs = {
          waybar = {
            settings = {
              network = {
                interface = "wlp4s0";
              };
            };
          };
        };
      };
    };
  };
}
