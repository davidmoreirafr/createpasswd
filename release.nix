{ supportedSystems ? [ "x86_64-linux" ] }:
with import <nixpkgs/pkgs/top-level/release-lib.nix>( { inherit supportedSystems; } );

let
  deriv = target: env:
    let
      pkgs = import <nixpkgs> {
        system = target;
      };
    in
      env.mkDerivation rec {
        name = "createpasswd";
        src = ./.;
        buildInputs = [
          pkgs.ninja
          pkgs.gcc
        ];

        configurationPhase = ''
          ninja -t clean
        '';
        buildPhase = ''
          ninja -v
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp ./_builddir/createpasswd $out/bin
        '';
      };
in {
  gcc9  = deriv "x86_64-linux" pkgs.gcc9Stdenv;
  gcc10 = deriv "x86_64-linux" pkgs.gcc10Stdenv;
  gcc11 = deriv "x86_64-linux" pkgs.gcc11Stdenv;
}
