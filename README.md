# nix

### enable experimental features
```shell
$ mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### install git to host machine
```shell
$ nix profile install nixpkgs#git --extra-experimental-features nix-command flakes
```

### update packages
```shell
$ nix-channel --update
```


