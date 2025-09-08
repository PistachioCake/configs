{ self, inputs, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
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
