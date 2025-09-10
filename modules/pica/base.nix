{ config, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
in
{
  config = mkMerge [
    {
      # Enable the `nix` command, and the flakes feature
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    }

    (mkIf config.pica.profiles.server.enable {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
        };
      };

      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;
    })
  ];
}
