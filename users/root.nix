{ config, ... }:
let
  cfg = config.pica.system;
in
{
  config = {
    users.users.root.openssh.authorizedKeys = config.users.users.${cfg.mainUser}.openssh.authorizedKeys;
  };
}
