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
  build_function = target: comp:
    let
      pkgs = import <nixpkgs> {
        system = target;
      };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = [
          pkgs.ninja
          comp
        ];
        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1
        '';
      };
in {
  build = pkgs.lib.genAttrs [ "foo" ]
    (target: 
      pkgs.lib.genAttrs [ "gcc10" "gcc9" ]
        (comp:
          build_function "foo" pkgs.gcc10
                #(compiler_conversion comp)))
    )

    );
}
