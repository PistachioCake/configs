{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pica.networking;
in
{
  options.pica.networking = {
    enable = mkEnableOption "Networking";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.networkmanager.settings.connectivity.uri =
      "http://nmcheck.gnome.org/check_network_status.txt";
  };
}
