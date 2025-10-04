{
  inputs,
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    concatLists
    ;
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
        terra.enable = mkEnableOption "Terra";
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
        package = mcpkgs.paperServers.paper-1_21_9;
        # TODO: make serverProperties declarative by uncommenting the below values
        # serverProperties = {
        #   server-port = cfg.port;
        #   motd = "Now running on tardigrade!";
        #   white-list = true;
        #   max-players = 20;
        # };
        files = mkMerge [
          {
            plugins = pkgs.linkFarmFromDrvs "plugins" (concatLists [
              (optional cfg.unifiedmetrics.enable (
                pkgs.fetchurl {
                  url = "https://github.com/Cubxity/UnifiedMetrics/releases/download/v0.3.x-SNAPSHOT/unifiedmetrics-platform-bukkit-0.3.10-SNAPSHOT.jar";
                  sha256 = "0i529wsjgciwg8dxvmvrz51z6s0nzbqaxhmq9xqgriffnmxrl11b";
                }
              ))
              (optional cfg.terra.enable (
                pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/FIlZB9L0/versions/Ufl71nST/Terra-bukkit-6.6.6-BETA+451683aff-shaded.jar";
                  sha256 = "05gi1bgmq5plqx141sagbfrx6jqmjlc9l6b3y6hx6csl4xm5v693";
                }
              ))
            ]);
          }
          {
            "world/datapacks" = pkgs.linkFarmFromDrvs "datapacks" [
              (pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gWO6Zqey/versions/hf7LJyzD/vanilla-refresh-1.4.28.zip";
                sha256 = "0pa9ir07yb9mmxs9m1n4n9gmca31man96pm4qfrl4a3bb4jsg96m";
              })
            ];
          }
          (mkIf cfg.terra.enable {
            "plugins/Terra/packs" = pkgs.linkFarmFromDrvs "packs" [
              (pkgs.fetchurl {
                url = "https://github.com/Rearth/Origen/releases/download/v2.2.0/origen-v2.2.0.zip";
                sha256 = "0rabvls5sv7jh3sr59wbdnjnxkz7hqv05m08gl0v1r2z32gprhhy";
              })
            ];
          })
          (mkIf cfg.unifiedmetrics.enable {
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
          })
        ];
      };
    };
  };
}
