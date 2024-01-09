{
  description = "Development environments on your infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Workaround for: terraform has an unfree license (‘bsl11’), refusing to evaluate.
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        formatter = pkgs.nixpkgs-fmt;
        # Check in https://search.nixos.org/packages to find new packages.
        # Use `nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update`
        # to update the lock file if packages are out-of-date.

        # From https://nixos.wiki/wiki/Google_Cloud_SDK
        gdk = pkgs.google-cloud-sdk.withExtraComponents ([pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]);

        devShellPackages = with pkgs; [
 #         bat
 #         cairo
          curl
 #         drpc.defaultPackage.${system}
 #         gcc
          gdk
          getopt
          git
          gh
          gnumake
          gnused
          go_1_21
          go-migrate
          golangci-lint
          gopls
          gotestsum
 #         helm
          helmfile
          htop
          jq
          k9s
          kubectl
          kubectx
          (pkgs.wrapHelm pkgs.kubernetes-helm { plugins = [ 
            pkgs.kubernetes-helmPlugins.helm-secrets
            pkgs.kubernetes-helmPlugins.helm-diff 
          ]; })
          less
          # Needed for many LD system libs!
          libuuid
          nano
  #        mockgen
  #        nfpm
  #        nodejs
  #        nodePackages.pnpm
  #        nodePackages.prettier
  #        nodePackages.typescript
  #        nodePackages.typescript-language-server
          openssh
          openssl
  #        pango
  #        pixman
  #        pkg-config
  #        postgresql_13
  #        protobuf
  #        protoc-gen-go
  #        ripgrep
  #        sapling
          shellcheck
  #        shfmt
  #        sqlc
          # strace is not available on OSX
          (if pkgs.stdenv.hostPlatform.isDarwin then null else strace)
          terraform
  #        typos
  #        vim
          wget
  #        yarn
          yq-go
          zip
  #        zsh
  #        zstd
        ];
      in
      {
        defaultPackage = formatter; # or replace it with your desired default package.
        devShell = pkgs.mkShell {
	  buildInputs = devShellPackages;
shellHook = ''
    shopt -s histappend
    PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
    export PS1='\[\033[01;32m\][\D{%m-%d×%H:%M:%S}]cloud\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  '';
	};
      }
    );
}
