{
  supportedSystems ? ["x86_64-linux"]
  , supportedCompilers ? [ "gcc10" "gcc9" ]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  compiler_conversion = comp:
    (if comp == "gcc10"
     then pkgs.gcc10
     else pkgs.gcc9
    );
  build_function = my_compiler:
    let
      pkgs = import <nixpkgs> {
        system = "x86_64-linux";
      };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = [pkgs.ninja my_compiler];
#        buildInputs = (with pkgs; [
#          "ninja"
#          gcc9
#        ]);
#
        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1
        '';
      };
in {
  build = pkgs.lib.genAttrs ["gcc10" "gcc9"]
    (comp: build_function (compiler_conversion comp)
    );
}
