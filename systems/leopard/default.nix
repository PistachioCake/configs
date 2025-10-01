{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getName;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
    ./hardware.nix
    ./users.nix
  ];

  pica = {
    profiles = {
      laptop.enable = true;
      graphical.enable = true;
    };

    printing.enable = true;
    networking.enable = true;
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  security.polkit.enable = true; # for sway

  # Turn on tablet drivers
  hardware.opentabletdriver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # Install programs
  # programs.steam.enable = true;
  # programs.firefox.enable = true;
  # programs.direnv.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "libfprint-2-tod1-goodix"
    ];

  system.stateVersion = "24.05";
}
