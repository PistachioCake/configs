{
  imports = [
    ./hardware.nix
  ];

  pica = {
    profiles = {
      server.enable = true;
    };
  };
}
