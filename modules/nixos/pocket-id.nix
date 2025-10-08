{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (self.lib) mkServiceOption;
  cfg = config.pica.services.pocket-id;
in
{
  options.pica.services = {
    pocket-id = mkServiceOption "Pocket ID" {
      # defaults taken from https://pocket-id.org/docs/configuration/environment-variables
      port = 1411;
      extraConfig = {
        webfinger.enable = mkEnableOption "Webfinger";
      };
    };
  };

  disabledModules = [ "services/security/pocket-id.nix" ];
  imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/services/security/pocket-id.nix" ];

  config = mkIf cfg.enable {
    services.pocket-id = {
      enable = true;
      package = pkgs.unstable.pocket-id;
      settings = {
        APP_URL = "https://${cfg.domain}";
        TRUST_PROXY = true;
        PORT = cfg.port;
        HOST = cfg.host;
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      locations."/" = {
        proxyPass = "http://${toString cfg.host}:${toString cfg.port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_busy_buffers_size 512k;
          proxy_buffers 4 512k;
          proxy_buffer_size 256k;
        '';
      };
    };

    services.nginx.virtualHosts.${config.networking.domain} = mkIf cfg.webfinger.enable {
      locations."/.well-known/webfinger" =
        let
          webfingerResponse = builtins.toJSON {
            subject = "acct:me@${config.networking.domain}";
            links = [
              {
                rel = "http://openid.net/specs/connect/1.0/issuer";
                href = "https://${cfg.domain}";
              }
            ];
          };
        in
        {
          return = "200 '${webfingerResponse}'";
          extraConfig = ''
            default_type application/json;
          '';
        };
    };
  };
}
