#
# Nginx Configuration Module
#
# This module configures Nginx as a reverse proxy for web applications
# with specific optimizations for WebSocket support and proper header forwarding.
# It includes both the web server configuration and log rotation setup.
#
{ pkgs, lib, ... }:
{
  services = {
    #-----------------------------------------------------------------------------
    # NGINX WEB SERVER CONFIGURATION
    #-----------------------------------------------------------------------------
    # Main Nginx server settings, optimized for proxy use cases with proper
    # logging and connection handling

    nginx = {
      # Core settings
      enable = true; # Enable the Nginx service
      statusPage = true; # Enable /nginx_status for monitoring
      recommendedProxySettings = true; # Use recommended proxy headers and settings

      # Connection and performance tuning
      eventsConfig = ''
        # Maximum number of simultaneous connections per worker process
        worker_connections 20000;     # Set high for websocket-heavy applications
      '';

      # Global HTTP configuration
      appendHttpConfig = ''
        # Custom log format with timing and request details
        log_format nginx '\$remote_addr - \$remote_user [\$time_local] '
                        '"\$request" \$status \$body_bytes_sent \$request_time '
                        '"\$http_referer" "\$http_user_agent"';

        # Log file paths for centralized log management
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
      '';

      #-------------------------------------------------------------------------
      # VIRTUAL HOST CONFIGURATIONS
      #-------------------------------------------------------------------------
      # Server blocks for different applications and domains

      virtualHosts = {
        "localhost" = {
          # Basic server configuration for Zammad
          # Note: Replace "localhost" with your actual domain in production

          locations = {
            #---------------------------------------------------------------------
            # MAIN WEB APPLICATION PROXY
            #---------------------------------------------------------------------
            # Routes standard HTTP traffic to the main web application

            "/" = {
              # Proxy to the Zammad Rails application
              proxyPass = "http://localhost:3000"; # Zammad web UI server
              proxyWebsockets = false; # Standard HTTP for main app

              # Header and proxy configuration for proper request handling
              extraConfig = ''
                # Forward the original host header to the backend
                proxy_set_header Host $host;
                        
                # Forward the client IP for proper logging
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      
                # Forward the scheme (http/https) for proper URL generation
                proxy_set_header X-Forwarded-Proto $scheme;

                # Essential for CSRF protection to work correctly
                proxy_set_header X-Forwarded-Host $host;

                # Set proper SSL related headers if using SSL
                proxy_set_header X-Forwarded-Ssl on;

                # IMPORTANT: Cookie handling
                proxy_cookie_path / "/; HTTPOnly; Secure; SameSite=Strict";

                # Security-related headers
                proxy_hide_header X-Powered-By;

                # Increase buffer size for headers
                proxy_buffer_size 128k;
                proxy_buffers 4 256k;
                proxy_busy_buffers_size 256k;
              '';
            };

            #---------------------------------------------------------------------
            # WEBSOCKET PROXY
            #---------------------------------------------------------------------
            # Special configuration for real-time updates via WebSockets

            "/ws" = {
              # Proxy to the Zammad WebSocket server
              proxyPass = "http://localhost:6042"; # Zammad websocket server
              proxyWebsockets = true; # Enable WebSocket support

              # Advanced configuration for WebSocket support
              extraConfig = ''
                # Additional headers for proper request routing
                proxy_set_header Host $host;
                proxy_set_header CLIENT_IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                # Extended timeout for long-running WebSocket connections
                proxy_read_timeout 86400;           # 24 hours for long-lived connections
              '';
            };
          };
        };
      };
    };

    #-----------------------------------------------------------------------------
    # LOG ROTATION CONFIGURATION
    #-----------------------------------------------------------------------------
    # Automatic log rotation to prevent disk space issues from large log files

    logrotate = {
      settings = {
        nginx = {
          # Paths to log files that should be rotated
          files = [ "/var/log/nginx/*.log" ];

          # Rotation frequency - logs rotated daily to limit file size
          frequency = "daily";

          # Additional settings to consider:
          # rotate = 14;             # Keep logs for 14 days
          # compress = true;         # Compress old logs
          # delaycompress = true;    # Don't compress most recent rotated log
          # postrotate = "...";      # Commands to run after rotation (e.g., reload nginx)
        };
      };
    };
  };
}
