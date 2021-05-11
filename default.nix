{
  supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
, supportedCompilers ? [ "gcc10" "gcc9" "gcc8" "gcc7" ]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  compiler_conversion = comp:
    if comp == "gcc10" then
      pkgs.gcc10
    else (
      if comp == "gcc9" then
        pkgs.gcc9
      else (
        if comp == "gcc8" then
          pkgs.gcc8
        else
          pkgs.gcc7
      )
    );
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
          pkgs.bash
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
  build = pkgs.lib.genAttrs supportedSystems (target: 
      pkgs.lib.genAttrs supportedCompilers (comp:
        build_function target (compiler_conversion comp)
      )
  );
}
