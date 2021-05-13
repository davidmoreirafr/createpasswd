{
  supportedSystems ? [ "x86_64-darwin" "x86_64-linux" ]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  build_function = target: comp: boost:
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
          boost
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
  myGenAttrs = names: f:
    pkgs.lib.listToAttrs
      (
        map
          (
            n:
            pkgs.lib.nameValuePair
              (
                let
                  version
                  =
                    builtins.concatStringsSep
                      "_"
                      (builtins.splitVersion n.version);
                      #(builtins.split "\\." n.version);
                in
                  "gcc_${version}"
              )
              (f n))
          names);

  supportedCompilers = [
    pkgs.gcc10
    pkgs.gcc9
    pkgs.gcc8
    pkgs.gcc7
    pkgs.gcc6
    pkgs.gcc49
    pkgs.gcc48
  ];
  supportedBoost = [
    boost155
    boost159
    boost160
    boost165
    boost166
    boost167
    boost168
    boost170
    boost171
    boost172
  ];
in {
  build = pkgs.lib.genAttrs supportedSystems (target:
    myGenAttrs supportedCompilers (comp:
      myGenAttrs supportedBoost (boost:
        build_function target comp boost)
    )
  );
}
