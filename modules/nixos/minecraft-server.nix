{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.pica.services.minecraft-server;

  system = pkgs.system; # TODO: is there a better way to get the current system?
  mcpkgs = inputs.nix-minecraft.legacyPackages.${system};
in
{
  options.pica.services = {
    minecraft-server.enable = mkEnableOption "A minecraft server";
  };

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      openFirewall = true;
      servers.paper = {
        enable = true;
        # TODO: consider further changing jvmOpts
        jvmOpts = "-Xmx16384M -Xms8192M";
        package = mcpkgs.paperServers.paper-1_21_5-build_103;
      };
    };
  };
}
