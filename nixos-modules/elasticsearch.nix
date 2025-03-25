{ pkgs, ... }:
{

  # Add systemd service extensions for Elasticsearch
  systemd.services.elasticsearch = {
    serviceConfig = {
      # Permit elasticsearch to lock memory (required for bootstrap.memory_lock)
      LimitMEMLOCK = "infinity";

      # Create log directory with proper permissions
      LogsDirectory = "elasticsearch";

      # Ensure directories exist and have proper permissions
      StateDirectory = "elasticsearch";
    };
  };

  services = {
    #-------------------------------------------------------------------------
    # SEARCH AND ANALYTICS SERVICES
    #-------------------------------------------------------------------------
    # Search engines and data stores for development

    # Elasticsearch search engine and analytics database
    elasticsearch = {
      enable = true;
      package = pkgs.elasticsearch7; # Use version 7.x specifically

      # Development mode with single node
      single_node = true;

      # Cluster identification
      cluster_name = "zammad";

      # Network configuration for local-only access
      listenAddress = "127.0.0.1";
      port = 9200; # HTTP API port
      tcp_port = 9300; # Inter-node communication port

      # Explicitly define data directory
      dataDir = "/var/lib/elasticsearch";

      # Additional plugins
      plugins = [
        pkgs.elasticsearch7Plugins.ingest-attachment # Document processing plugin
      ];

      # Java memory settings to limit resource usage
      extraJavaOptions = [
        "-Xms512m" # Initial heap size
        "-Xmx512m" # Maximum heap size
      ];

      # Additional Elasticsearch configuration
      extraConf = ''
        # Node identity
        node.name: zammad_node1

        # Security settings
        xpack.security.enabled: false

        # Path configurations
        path.logs: /var/log/elasticsearch

        # Network discovery
        discovery.seed_hosts: ["127.0.0.1"]

        # Performance optimization - prevent swapping
        bootstrap.memory_lock: true
      '';
    };

  };
}
