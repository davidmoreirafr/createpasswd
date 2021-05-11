{
  supportedSystems ? ["x86_64-linux"]
  , supportedCompilers ? ["gcc10" "gcc9"]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
  #inherit supportedSystems;
});
let
  build_function = platform:
    let
      pkgs = import <nixpkgs> {
        system = "x86_64-linux";
      };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = (with pkgs; [
          ninja
        ]); # comment

        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1      
        '';
      };

#  jobs = {
#    build1 = build_function "x86_64-linux";
#    build2 = build_function "x86_64-darwin";
#  };
in {
  build = pkgs.lib.genAttrs supportedCompilers (compiler:
    let

    in
      build_function compiler
  );
}

