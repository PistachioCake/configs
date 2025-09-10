{ config, lib, ... }:
let
  inherit (lib) mkIf elem;
in
{
  config = mkIf (elem "rushilu" config.pica.system.users) {
    users.users.rushilu = {
      isNormalUser = true;

      extraGroups = [ "wheel" ];
      gender = {
        description = "N/A";
        pronouns = "they/them";
      };

      hashedPassword = "$y$j9T$EEBcUoD5PfC09EVNdY7di.$y86uUZkkHODRqKR9oXqVdxqT6Xk0dQRYtRIBbbpfxX.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwH5x4fa2x7vB+cTIV1sEk1MDy/RKWDaFSQ+qwkDgRi"
      ];
    };

    nix.settings.trusted-users = [ "rushilu" ];
  };
}
