{
  inputs,
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (lib.lists) optional;
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
      extraConfig = {
        unifiedmetrics = mkServiceOption "Unified Metrics" {
          port = 9100;
          domain = null;
        };
      };
    };
  };

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      openFirewall = true;

      managementSystem = {
        systemd-socket.enable = true;       
      };

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
        files = {
          plugins = pkgs.linkFarmFromDrvs "plugins" (
            optional cfg.unifiedmetrics.enable (
              pkgs.fetchurl {
                url = "https://github.com/Cubxity/UnifiedMetrics/releases/download/v0.3.x-SNAPSHOT/unifiedmetrics-platform-bukkit-0.3.10-SNAPSHOT.jar";
                sha256 = "0i529wsjgciwg8dxvmvrz51z6s0nzbqaxhmq9xqgriffnmxrl11b";
              }
            )
          );
          "plugins/unifiedmetrics/config.yml" = {
            value = {
              server = {
                name = "global";
              };
              metrics = {
                enabled = true;
                driver = "prometheus";
                collectors = {
                  systemGc = true;
                  systemMemory = true;
                  systemProcess = true;
                  systemThread = true;
                  server = true;
                  world = true;
                  tick = true;
                  events = true;
                };
              };
            };
          };
          "plugins/unifiedmetrics/driver/prometheus.yml" = {
            value = {
              mode = "HTTP";
              http = {
                inherit (cfg.unifiedmetrics) host port;
                authentication = {
                  scheme = "NONE";
                };
              };
            };
          };
        };
      };
    };
  };
}
