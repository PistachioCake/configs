{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pica.printing;
in
{
  options.pica.printing = {
    enable = mkEnableOption "Printing";
  };

  config = mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable IPP Everywhere printing (see nixos wiki)
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
