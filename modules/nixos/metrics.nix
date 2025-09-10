{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.pica.metrics;
in
{
  options.pica.metrics = {
    enable = mkEnableOption "Record metrics using Prometheus";
    scrape = options.services.prometheus.scrapeConfigs;
    grafana.enable = mkEnableOption "Display metrics using Grafana";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.prometheus = {
        enable = true;

        exporters = {
          node = {
            enable = true;
            port = 9001;
            enabledCollectors = [ "systemd" ];
          };
        };

        port = 9000;
        scrapeConfigs = cfg.scrape;
      };
    })

    (mkIf cfg.grafana.enable {
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 3000;
            enable_gzip = true;

            # TODO: make this subdomain an option
            domain = "stats.${config.networking.domain}";
            enforce_domain = true;
            root_url = "/grafana";
            serve_from_sub_path = true;
          };

          "auth.anonymous" = {
            enabled = true;
            org_name = "Main Org.";
          };
        };
      };

      services.nginx.virtualHosts."stats.${config.networking.domain}" = {
        locations."/grafana" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        locations."/" = {
          return = "301 /grafana";
        };
      };
    })
  ];
}
