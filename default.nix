{ supportedSystems ? [ "x86_64-darwin" "x86_64-linux" ] }:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  build_function = target: compiler: boost:
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
          pkgs.file
          compiler
          boost
        ];
        configurePhase = ''
          uname -a
          env
          env
          which g++
          find /nix/store/
          file $(which g++)
          ninja -vt clean
        '';
        buildPhase = ''
          g++ createpasswd.cc -o createpasswd.o
          ninja -j1 -k 100
        '';
      };

  myGenAttrs = basename: names: f:
    pkgs.lib.listToAttrs (map (n:
      pkgs.lib.nameValuePair
        "${basename}_${builtins.concatStringsSep "_" (builtins.splitVersion n.version)}"
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
    pkgs.boost155
    pkgs.boost159
    pkgs.boost160
    pkgs.boost165
    pkgs.boost166
    pkgs.boost167
    pkgs.boost168
    pkgs.boost170
    pkgs.boost171
    pkgs.boost172
  ];
in {
  build = pkgs.lib.genAttrs supportedSystems (target:
    myGenAttrs "gcc" supportedCompilers (compiler:
      myGenAttrs "boost" supportedBoost (boost:
        build_function target compiler boost)
    )
  );
}
