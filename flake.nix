{
  description = "Development environments on your infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        formatter = pkgs.nixpkgs-fmt;
        gdk = pkgs.google-cloud-sdk.withExtraComponents ([
          pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
        ]);

        devShellPackages = with pkgs; [
          curl
          gdk
          getopt
          git
          gh
          gnumake
          gnused
          google-cloud-sql-proxy
          helmfile
          htop
          jq
          k6
          k9s
          kubectl
          kubectx
          (pkgs.wrapHelm pkgs.kubernetes-helm {
            plugins = [
              pkgs.kubernetes-helmPlugins.helm-secrets
              pkgs.kubernetes-helmPlugins.helm-diff
              pkgs.kubernetes-helmPlugins.helm-unittest
            ];
          })
          less
          # Needed for many LD system libs!
          libuuid
          nano
          openssh
          openssl
          shellcheck
          shfmt
          # strace is not available on OSX
          (if pkgs.stdenv.hostPlatform.isDarwin then null else strace)
          terraform
          wget
          yq-go
          zip
        ];
      in
      {
        defaultPackage = formatter;
        devShell = pkgs.mkShell {
          buildInputs = devShellPackages;
          shellHook = ''
            shopt -s histappend
            PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
            PS1='\[\033[01;32m\][\D{%m-%d×%H:%M:%S}]nix-cloud\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        '';
        };
      }
    );
}
