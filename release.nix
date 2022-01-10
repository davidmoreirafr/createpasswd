{ supportedSystems ? [ "x86_64-linux" ] }:
with import <nixpkgs/pkgs/top-level/release-lib.nix>( { inherit supportedSystems; } );

let
  deriv = target: env: packages: envConfigurePhase:
    let
      pkgs = import <nixpkgs> {
        system = target;
      };
    in
      env.mkDerivation rec {
        name = "createpasswd";
        src = ./.;
        buildInputs = [pkgs.ninja] ++ packages;
        configurePhase = envConfigurePhase +
        ''
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


  deriv_gcc = target: env:
    let
      pkgs = import <nixpkgs> {
        system = target;
      };
    in
      deriv target env [pkgs.gcc] "";

  deriv_clang = target: env:
    let
      pkgs = import <nixpkgs> {
        system = target;
      };
    in
      deriv target env [pkgs.clang]
        ''
          sed -ie 's/g++/clang++/' build.ninja
        '';

in {
  clang5 = deriv_clang "x86_64-linux" pkgs.clang5Stdenv;
  clang6  = deriv_clang "x86_64-linux" pkgs.clang6Stdenv;
  clang7  = deriv_clang "x86_64-linux" pkgs.clang7Stdenv;
  clang8  = deriv_clang "x86_64-linux" pkgs.clang8Stdenv;
  clang9  = deriv_clang "x86_64-linux" pkgs.clang9Stdenv;
  clang10 = deriv_clang "x86_64-linux" pkgs.clang10Stdenv;
  clang11 = deriv_clang "x86_64-linux" pkgs.clang11Stdenv;
  clang12 = deriv_clang "x86_64-linux" pkgs.clang12Stdenv;

  gcc48 = deriv_gcc "x86_64-linux" pkgs.gcc48Stdenv;
  gcc49 =deriv_gcc "x86_64-linux" pkgs.gcc49Stdenv;
  gcc6 =deriv_gcc "x86_64-linux" pkgs.gcc6Stdenv;
  gcc7 = deriv_gcc "x86_64-linux" pkgs.gcc7Stdenv;
  gcc8 = deriv_gcc "x86_64-linux" pkgs.gcc8Stdenv;
  gcc9  = deriv_gcc "x86_64-linux" pkgs.gcc9Stdenv;
  gcc10 = deriv_gcc "x86_64-linux" pkgs.gcc10Stdenv;
  gcc11 = deriv_gcc "x86_64-linux" pkgs.gcc11Stdenv;
}
