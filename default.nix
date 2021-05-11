let
  pkgs = import <nixpkgs> {};
  build_function = platform:
    let
      pkgs = import <nixpkgs> {};
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = (with pkgs; [
          ninja
          gcc
        ]); # comment

        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1
        '';
      };

  jobs = {
    build1 = build_function "toto1";
    build2 = build_function "toto2";
  };
in
  jobs
