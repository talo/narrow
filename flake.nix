{
  inputs = {
    goatnixpkgs.url = "github:TheAncientGoat/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, goatnixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    goatpkgs = import goatnixpkgs { inherit system; };
  in {
    devShell = with pkgs;
    mkShell {
      buildInputs = [
        goatpkgs.nim
        goatpkgs.nrpl
        goatpkgs.nimlsp
        goatpkgs.arrow-c-glib
      ];
      nativeBuildInputs = [
        boost
        goatpkgs.arrow-c-glib
      ];
    };
  });
}
