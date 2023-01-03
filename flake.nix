{
  description = "~glorifiedgluer's website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          inherit (pkgs)
            emacs-nox
            emacsPackagesFor
            hugo
            hut

            lib
            mkShell
            stdenv
            ;
        in
        {
          packages.default =
            let
              customEmacs = (emacsPackagesFor emacs-nox).emacsWithPackages
                (epkgs: with epkgs.melpaPackages; [
                  ox-hugo
                ]
                ++ (with epkgs.elpaPackages; [
                  org
                ]));
            in
            stdenv.mkDerivation {
              name = "glorifiedgluercom";
              src = lib.cleanSource ./.;

              buildInputs = [
                customEmacs
                hugo
              ];

              configurePhase = ''
                emacs $(pwd) --batch -load export.el
              '';

              buildPhase = ''
                hugo
              '';

              installPhase = ''
                mkdir -p $out
                cp -r public/* $out
              '';
            };

          devShells.default = mkShell {
            buildInputs = [
              hut
              hugo
            ];
          };
        });
}
