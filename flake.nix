{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    flake-compat
  } @ inputs:
    let
      inherit (nixpkgs) lib;
      inherit (lib) recursiveUpdate;
      inherit (flake-utils.lib) eachDefaultSystem defaultSystems;

      nixpkgsFor = lib.genAttrs defaultSystems (system: import nixpkgs {
        inherit system;
      });
    in
    (eachDefaultSystem (system:
      let
        pkgs = nixpkgsFor.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python310
            poetry
            ta-lib

            #(poetry2nix.mkPoetryApplication {
            #  projectDir = self;
            #})

            #(poetry2nix.mkPoetryEnv {
            #  projectDir = self;
            #  overrides = poetry2nix.overrides.withDefaults (self: super: {
            #  #   cryptography = super.cryptography.overridePythonAttrs (old: {
            #  #     CRYPTOGRAPHY_DONT_BUILD_RUST = 1;
            #  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [ super.setuptools-rust ];
            #  #   });
            #  #   enrich = super.enrich.overridePythonAttrs (old: {
            #  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [ super.toml ];
            #  #   });
            #  #   munch = super.munch.overridePythonAttrs (old: {
            #  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [ super.pbr ];
            #  #   });
            #  #   python-swiftclient = super.python-swiftclient.overridePythonAttrs (old: {
            #  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [ super.pbr ];
            #  #   });
            #  #   requestsexceptions = super.requestsexceptions.overridePythonAttrs (old: {
            #  #     propagatedBuildInputs = old.propagatedBuildInputs ++ [ super.pbr ];
            #  #   });
            #    types-filelock = super.types-filelock.overridePythonAttrs (old: rec {
            #      buildInputs = [
            #        python310.pkgs.setuptools
            #      ];
            #    });
            #    blosc = super.blosc.overridePythonAttrs (old: rec {
            #      version = "1.11.1";
            #      src = super.fetchPypi {
            #        inherit (old) pname;
            #        inherit version;
            #        sha256 = "sha256-wiEZsnuuEGOml/Y5AotCLVWBGwiAw/wBScvep5HQsnY=";
            #      };
            #      buildInputs = [
            #        python310.pkgs.scikit-build
            #        python310.pkgs.setuptools
            #      ];
            #    });
            #  });
            #})
          ];

          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/
          '';
        };
      }
    ));
}
