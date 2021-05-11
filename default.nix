let
  pkgs = import <nixpkgs> {};
  jobs = rec {
    { system ? builtins.currentSystem }:
    let
      pkgs = import <nixpkgs> {inherit system; };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ../createpasswd;
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
