{ lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

  /**
    Create a set of options that (roughly) correspond to a service.

    # Arguments:

    name
    : the name of the service

    args
    : an attrset containing default values and other needed options

    args can contain the following attributes:
    - port, host, and domain:
        used to populate the default values of the respective options.
        if they are not provided, they will default to 0, "127.0.0.1", and "", respectively.
        if they are set to null, they suppress the creation of the repective option.
    - extraConfig: merged into the set of options. use this to include other options.

    # Examples
    Create the options `nginx.enable`, `nginx.port`, `nginx.host`, and `nginx.domain` with
    ```
      options.nginx = mkServiceOption "nginx" {}
    ```

    Remove the `domain` option and add a new `user` option with
    ```
      options.example = mkSmkServiceOption "example" {
        domain = null;
        extraConfig = {
          user = mkOption {
            # ...
          }
        }
      }
    ```
  */
  mkServiceOption =
    name:
    {
      port ? 0,
      host ? "127.0.0.1",
      domain ? "",
      extraConfig ? { },
    }:
    {
      enable = mkEnableOption "Enable the ${name} service";

      ${if isNull host then null else "host"} = mkOption {
        type = types.str;
        default = host;
        description = "The host for the ${name} service";
      };

      ${if isNull port then null else "port"} = mkOption {
        type = types.port;
        default = port;
        description = "The port for the ${name} service";
      };

      ${if isNull domain then null else "domain"} = mkOption {
        type = types.str;
        default = domain;
        defaultText = "networking.domain";
        description = "Domain name for the ${name} service";
      };
    }
    // extraConfig;
in
{
  flake.lib = { inherit mkServiceOption; };
}
