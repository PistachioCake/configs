# PistachioCake's system configurations

Based loosely off of [isabel roses's dotfiles](https://github.com/isabelroses/dotfiles), using her [easy-hosts](https://github.com/tgirlcloud/easy-hosts) tool.

## Directory structure

```mermaid
graph LR
    root[dotfiles] --> flake.nix

    root
    --> modules
    --> flake

    flake.nix -. references .-> flake

    modules
    --> pica
    --> pica/docs@{ shape: docs, label: "Generic options" }

    modules
    --> nixos
    --> nixos/docs@{ shape: docs, label: "Nixos modules" }

    modules
    --> home
    --> home/docs@{ shape: docs, label: "Home Manager modules" }

    nixos/docs -. uses options from .-> pica/docs
    home/docs -. uses options from .-> pica/docs

    root
    --> systems
    --> systems/docs@{ shape: docs, label: "Various system configs" }

    systems -. imports .-> pica/docs
    systems -. imports .-> nixos/docs
    systems -. imports .-> home/docs

    root
    --> users
    --> rushilu
    --> users/docs@{ shape: docs, label: "My user-level configs" }
```

The `modules/pica` directory, and the `pica` namespace, provides generic options that we can hook into in other places. These reference *my* specific configurations that fulfill my usecases; they will not work for other people.
