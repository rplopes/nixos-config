# NixOS Config

My NixOS configuration files.

## Set up

First, clone the repo:

```sh
$ git clone git@github.com:rplopes/nixos-config.git ~/.nixos-config
```

Copy the hardware configuration to the repo, overwriting the repo's version:

```sh
$ cp /etc/nixos/hardware-configuration.nix ~/.nixos-config
```

Then, replace the existing NixOS configuration directory with a symlink to this repo:

```sh
$ sudo mv /etc/nixos /etc/nixos.backup
$ sudo ln -s ~/.nixos-config /etc/nixos
```

Finally, don't forget to apply the changes:

```sh
$ sudo nixos-rebuild switch
```
