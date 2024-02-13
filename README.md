# nix

### enable experimental features
```shell
$ mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### install git to host machine
```shell
$ nix profile install nixpkgs#git --extra-experimental-features nix-command flakes
$ nix profile install nixpkgs#direnv
```

### update packages
```shell
$ nix-channel --add https://nixos.org/channels/nixpkgs-unstable
$ nix-channel --update
$ nix flake update .
```


