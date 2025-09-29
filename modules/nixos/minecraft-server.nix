{
  inputs,
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib) mkServiceOption;
  cfg = config.pica.services.minecraft-server;

  system = pkgs.system; # TODO: is there a better way to get the current system?
  mcpkgs = inputs.nix-minecraft.legacyPackages.${system};
in
{
  options.pica.services = {
    minecraft-server = mkServiceOption "Minecraft Server" {
      port = 25565;
      domain = null;
    };
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
        package = mcpkgs.paperServers.paper-1_21_8;
        # TODO: make serverProperties declarative by uncommenting the below values
        # serverProperties = {
        #   server-port = cfg.port;
        #   motd = "Now running on tardigrade!";
        #   white-list = true;
        #   max-players = 20;
        # };
      };
    };
  };
}
