{ supportedSystems ? [
  "x86_64-linux"
]}:
with import <nixpkgs/pkgs/top-level/release-lib.nix>(
  {
    inherit supportedSystems;
  }
);

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
          pkgs.file
        ];

        configurationPhase = ''
          ninja -t clean
        '';
        buildPhase = ''
          echo == Build phase ==
          ninja -v
          echo == End of Build phase ==
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp ./_builddir/createpasswd $out/bin
        '';
      };
in {
  gcc10 = deriv "x86_64-linux" pkgs.gcc10Stdenv;
  gcc11 = deriv "x86_64-linux" pkgs.gcc11Stdenv;
}

#let
#  pkgs = import <nixpkgs> {};
#
#  jobs = rec {
#
#    tarball =
#      pkgs.releaseTools.sourceTarball {
#        name = "hello-tarball";
#        src = <hello>;
#        buildInputs = (with pkgs; [ gettext texLive texinfo ]);
#      };
#
#    build =
#      { system ? builtins.currentSystem }:
#
#      let pkgs = import <nixpkgs> { inherit system; }; in
#      pkgs.releaseTools.nixBuild {
#        name = "hello";
#        src = jobs.tarball;
#        configureFlags = [ "--disable-silent-rules" ];
#      };
#  };
#in
#  jobs
#
