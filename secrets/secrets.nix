let
  tardigrade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTLST0ClW/VF3hoVWsc/GXTPfgs5qAFc3olQfX7svHy";
  rushilu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwH5x4fa2x7vB+cTIV1sEk1MDy/RKWDaFSQ+qwkDgRi";
in
{
  "cloudflare_api_key.age".publicKeys = [
    tardigrade
    rushilu
  ];
}
