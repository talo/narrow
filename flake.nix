{
  inputs = {
    goatnixpkgs.url = "github:TheAncientGoat/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self, nixpkgs, goatnixpkgs, flake-utils
  }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    goatpkgs = import goatnixpkgs { inherit system; };
    buildInputs = [
      pkgs.glib.out
      goatpkgs.arrow-c-glib
    ];
    nativeBuildInputs = [
      goatpkgs.arrow-c-glib
    ];
  in {
    devShell = with pkgs;
    mkShell {
      buildInputs = buildInputs ++ [
        goatpkgs.nim
        goatpkgs.nrpl
        goatpkgs.nimlsp
      ];
      inherit nativeBuildInputs;
    };
    defaultPackage = with pkgs; buildNimPackage rec {
      pname = "narrow";
      version = "0.2.0";
      src = fetchFromGitHub {
        owner = "talo";
        repo = pname;
        rev = version;
        hash = "sha256-w64ENRyP3mNTtESSt7CDDxUkjYSfziNVVedkO4HIuJ8=";
      };
      inherit buildInputs nativeBuildInputs;
    };
  });
}
