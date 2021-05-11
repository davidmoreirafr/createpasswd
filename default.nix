{
  supportedSystems ? ["x86_64-linux"]
  , supportedCompilers ? [ "gcc10" "gcc9" ]
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
        buildInputs = (with pkgs; [
          ninja
          gcc9
        ]);

        configurePhase = ''
          ninja -vt clean
        '';
        buildPhase = ''
          ninja -j1      
        '';
      };
in {
  build = pkgs.lib.genAttrs supportedCompilers
    (my_compiler2:
      let
        in
          build_function
  );
}
