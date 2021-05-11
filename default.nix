let
  pkgs = import <nixpkgs> {};
  jobs = {
    build = let
      pkgs = import <nixpkgs> {};
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
