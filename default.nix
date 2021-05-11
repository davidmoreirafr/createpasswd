let
  pkgs = import <nixpkgs> {};
  jobs = rec {
    build = { system ? builtins.currentSystem }:
      let
        pkgs = import <nixpkgs> {inherit system; };
      in
        pkgs.releaseTools.nixBuild {
          name = "createpasswd";
          src = ./.;
          buildInputs = (with pkgs; [
            ninja
            gcc
          ]);

          configurePhase = ''
          ninja -vt clean
        '';
          buildPhase = ''
          ninja
        '';
        };
  };
in
  jobs
