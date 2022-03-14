{
  inputs = {
    goatnixpkgs.url = "github:TheAncientGoat/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, goatnixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        goatpkgs = import goatnixpkgs { inherit system; };
        nativeBuildInputs = [ goatpkgs.arrow-c-glib ];
        propagatedBuildInputs = [ pkgs.glib.out goatpkgs.arrow-c-glib ];
        devBuildInputs = [ goatpkgs.nim goatpkgs.nrpl goatpkgs.nimlsp ];
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = devBuildInputs ++ propagatedBuildInputs;
            inherit nativeBuildInputs;
          };
        devShells.narrow = pkgs.mkShell {
          buildInputs = [ self.defaultPackage."${system}" ] ++ devBuildInputs;
        };
        defaultPackage = with pkgs;
          nimPackages.buildNimPackage rec {
            pname = "narrow";
            version = "0.2.0";
            src = fetchFromGitHub {
              owner = "talo";
              repo = pname;
              rev = "7206e306ed32cbd0765b06ac044a70a34a48114b";
              hash = "sha256-pJ7OwUwChklkTwvwzeymqWJE1EehYJINE7/mWsDWdhw=";
            };
            inherit nativeBuildInputs propagatedBuildInputs;
          };
      });
}
