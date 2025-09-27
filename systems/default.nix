{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    perClass = class: {
      modules = [ "${self}/modules/${class}" ];
    };
    shared.modules = [
      "${self}/modules/pica" # generic options used in many places
      "${self}/users"
      inputs.agenix.nixosModules.default
    ];

    hosts = {
      tardigrade = {
        path = ./tardigrade;
        arch = "aarch64";
        class = "nixos";
      };

      leopard = {
        path = ./leopard;
        arch = "x86_64";
        class = "nixos";
      };
    };
  };
}
