let
  build_function = platform:
    let
      pkgs = import <nixpkgs> {
        system = platform;
      };
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
    build1 = build_function "x86_64-linux";
    build2 = build_function "x86_64-darwin";
  };
in
  jobs
