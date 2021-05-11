{
  supportedSystems ? ["x86_64-linux"]
  , supportedCompilers ? ["gcc10" "pkgs.gcc9"]
}:
with  (import <nixpkgs/pkgs/top-level/release-lib.nix> {
  inherit supportedSystems;
});
let
  build_function = my_compiler:
    let
      pkgs = import <nixpkgs> {
        system = "x86_64-linux";
      };
    in
      pkgs.releaseTools.nixBuild {
        name = "createpasswd";
        src = ./.;
        buildInputs = [
          pkgs.ninja
          my_compiler
        ];

        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1      
        '';
      };
in {
  build = pkgs.lib.genAttrs supportedCompilers (my_compiler2:
    build_function my_compiler2
  );
}

