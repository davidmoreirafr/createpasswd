{
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
, supportedCompilers ? [ "gcc10" "gcc9" ]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  compiler_conversion = comp:
    if comp == "gcc10" then
      pkgs.gcc10
    else
      pkgs.gcc9;
  build_function = target: (comp:
    let
      pkgs = import <nixpkgs> {
        system = "x86_64-linux";
      };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = [pkgs.ninja comp];
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
      }
  );
in {
  build = pkgs.lib.genAttrs ["gcc10" "gcc9"]
    (comp: (
      pkgs.lib.genAttrs supportedSystems
        (target: build_function (compiler_conversion comp))
    )
#    (
#      pkgs.lib.genAttrs supportedSystems
#        comp: (
#          target: build_function target (compiler_conversion)
#        )
#          #build_function (compiler_conversion comp)
    );
}
