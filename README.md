# nix

### enable experimental features
```shell
$ echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
```

### install git to host machine
```shell
$ nix profile install nixpkgs#git --extra-experimental-features nix-command flakes
```
