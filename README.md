# NixOS Config

My NixOS configuration files.

## Set up

First, clone the repo:

```sh
$ git clone git@github.com:rplopes/nixos-config.git ~/.nixos-config
```

Then, replace the existing NixOS configuration file with a symlink to the repo's version:

```sh
$ cd /etc/nixos
$ sudo rm configuration.nix
$ sudo ln ~/.nixos-config/configuration.nix .
```

Finally, don't forget to apply the changes:

```sh
$ sudo nixos-rebuild switch
```
