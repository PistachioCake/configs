{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;
  cfg = config.pica.services.pocket-id;
in
{
  options.pica.services = {
    pocket-id = mkServiceOption "Pocket ID" {
      # defaults taken from https://pocket-id.org/docs/configuration/environment-variables
      port = 1411;
      host = "127.0.0.1";
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
  };
}
