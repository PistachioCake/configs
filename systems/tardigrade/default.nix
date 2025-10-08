{ inputs, config, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disk-config.nix
    ./users.nix
  ];

  pica = {
    profiles = {
      server.enable = true;
    };

    services = {
      minecraft-server = {
        enable = true;
        unifiedmetrics.enable = true;
        bluemap = {
          enable = true;
          domain = "mc.${config.networking.domain}";
        };
      };

      nginx.enable = true;

      pocket-id = {
        enable = true;
        domain = "login.${config.networking.domain}";
      };
    };

    metrics = {
      enable = true;
      scrape = [
        {
          job_name = "tardigrade_node_exporter";
          static_configs = [
            {
              # TODO: define these attributes as defaults in modules/nixos/metrics.nix, and use them here
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
      ];

      grafana = {
        enable = true;
        domain = "stats.${config.networking.domain}";
        path = "/grafana";
      };
    };
  };

  networking.domain = "pistachiocake.xyz";
  system.stateVersion = "23.11";
}
