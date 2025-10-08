{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.pica.services.tailscale;
in
{
  options.pica.services = {
    tailscale.enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ];
    };
  };
}
