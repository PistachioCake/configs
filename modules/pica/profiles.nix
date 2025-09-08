{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.pica = {
    profiles = {
      server.enable = mkEnableOption "A generic server";
    };
  };
}
