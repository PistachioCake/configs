{ config, lib, ... }:
let
  inherit (lib) mkDefault mkMerge mkIf;
  cfg = config.pica;
in
{
  config = mkMerge [
    { i18n.defaultLocale = mkDefault "en_US.UTF-8"; }
    (mkIf cfg.profiles.laptop.enable {
      time.timeZone = mkDefault "America/Chicago";
      i18n.extraLocaleSettings = {
        LC_TIME = mkDefault "en_GB.UTF-8"; # week starts on Monday
      };
    })
  ];
}
