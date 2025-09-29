{
  imports = [
    ./root.nix
    ./rushilu.nix
  ];

  config = {
    users.mutableUsers = false;
  };
}
