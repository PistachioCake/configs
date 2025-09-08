{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    perClass = class: {
      modules = [ "${self}/modules/${class}" ];
    };
    shared.modules = [
      "${self}/modules/pica" # generic options used in many places
    ];

    hosts = {
      tardigrade = {
        path = ./tardigrade;
        arch = "aarch64";
        class = "nixos";
      };
    };
  };
}
