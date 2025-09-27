{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.pica.profiles;
in
{
  options.pica.profiles = {
    server.enable = mkEnableOption "A generic server";
  };

  config = mkIf cfg.server.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = true;
  };
}
