{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pica.fprintd;
in
{
  options.pica.fprintd = {
    enable = mkEnableOption "Fingerprint reader";
    tod = {
      inherit (options.services.fprintd.tod) enable driver;
    };
  };

  config = mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod = {
        inherit (cfg.tod) enable driver;
      };
    };
  };
}
