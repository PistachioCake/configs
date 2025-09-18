let
  tardigrade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYKixY95z08/B06s53e3gqvU18CSBQ0aQcGzY08o0fg";
  rushilu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwH5x4fa2x7vB+cTIV1sEk1MDy/RKWDaFSQ+qwkDgRi";
in
{
  "cloudflare_api_key.age".publicKeys = [
    tardigrade
    rushilu
  ];
}
