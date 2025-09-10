{ config, ... }:
{
  imports = [
    ./hardware.nix
    ./users.nix
  ];

  pica = {
    profiles = {
      server.enable = true;
    };

    services = {
      minecraft-server.enable = true;
      nginx.enable = true;
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
    };
  };

  networking.domain = "pistachiocake.xyz";
  system.stateVersion = "23.11";
}
