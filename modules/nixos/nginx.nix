{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    mkIf
    types
    ;
  inherit (self.lib) mkServiceOption;
  cfg = config.pica.services.nginx;
in
{
  options.pica.services = {
    nginx = mkServiceOption "nginx" { domain = config.networking.domain; };
  };

  # we want to use DNS-01 validation for our certificates. we configure this in security.acme.certs below, but
  # we must also set options.services.nginx.virtualHosts.* = { enableACME = true; acmeRoot = null; }.
  # see https://nixos.org/manual/nixos/stable/#module-security-acme-config-dns-with-vhosts
  options.services.nginx.virtualHosts = mkOption {
    type = types.attrsOf (
      types.submodule {
        config = {
          useACMEHost = mkDefault cfg.domain;
          # enableACME = mkDefault true;
          # acmeRoot = mkDefault null;
          # redirect http to https for all connections
          forceSSL = mkDefault true;
        };
      }
    );
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80 # HTTP
      443 # HTTPS
    ];

    age.secrets.cloudflare_api_key.file = "${self}/secrets/cloudflare_api_key.age";

    # a hack becuase things go wrong here??
    systemd.services.nginx-config-reload.serviceConfig.User = "nginx";
    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      # set up a default 404 for unknown subdomains
      virtualHosts."_" = {
        default = true;
        locations."/".return = 404;
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "rushil.udani@gmail.com";
        dnsProvider = "cloudflare";
        environmentFile = config.age.secrets.cloudflare_api_key.path;
      };

      certs.${cfg.domain} = {
        domain = "*.${cfg.domain}";
      };
    };
  };
}
