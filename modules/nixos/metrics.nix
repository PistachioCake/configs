{
  lib,
  config,
  options,
  self,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  inherit (self.lib) mkServiceOption;
  cfg = config.pica.metrics;
in
{
  options.pica.metrics = {
    enable = mkEnableOption "Record metrics using Prometheus";
    scrape = options.services.prometheus.scrapeConfigs;

    grafana = mkServiceOption "Grafana" {
      extraConfig = {
        path = mkOption {
          type = types.str;
          default = "/grafana";
          description = "The URL path for the Grafana service";
          example = null;
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.prometheus.exporters.node = {
        enable = true;
        port = 9001;
        enabledCollectors = [ "systemd" ];
      };

      services.prometheus = {
        enable = true;
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

            domain = "${cfg.grafana.domain}";
            enforce_domain = true;
            root_url = cfg.grafana.path;
            serve_from_sub_path = true;
          };

          "auth.anonymous" = {
            enabled = true;
            org_name = "Main Org.";
          };
        };
      };

      services.nginx.virtualHosts.${cfg.grafana.domain} =
        let
          grafana_location = {
            proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        in
        if cfg.grafana.path == null then
          { locations."/" = grafana_location; }
        else
          {
            locations.${cfg.grafana.path} = grafana_location;

            locations."/" = {
              return = "301 ${cfg.grafana.path}";
            };
          };
    })
  ];
}
