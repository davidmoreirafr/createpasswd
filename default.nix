{
  supportedSystems ? [ "x86_64-darwin" "x86_64-linux" ]
, supportedCompilers ? [ "gcc10" "gcc9" "gcc8" "gcc7" "gcc6" "gcc49" "gcc48" ]
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
        else (
          if comp == "gcc7" then
            pkgs.gcc7
          else (
            if comp == "gcc6" then
              pkgs.gcc6
            else (
              if comp == "gcc49" then
                pkgs.gcc49
              else
                pkgs.gcc48
            )
          )
        )
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
          pkgs.ninja
          pkgs.which
          comp
        ];
        configurePhase = ''
          ninja -vt clean
          uname -a
          which g++ ||:
          which gcc ||:
        '';
        buildPhase = ''
          ninja -j1 -k 100
        '';
      };
  genCompilers = names: f:
    listToAttrs (map (n: (f n)) names)
      ;
in {
  build = pkgs.lib.genAttrs supportedSystems (target:
    genCompilers [pkgs.gcc10] (comp:
      ##pkgs.lib.genAttrs [pkgs.gcc10] (comp:
        build_function target (compiler_conversion comp)
      )
  );
}
