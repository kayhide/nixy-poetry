let
  nixpkgs = builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/5aaed40d22f0d9376330b6fa413223435ad6fee5.tar.gz;
    sha256 = "0bs8sr92lzz7mdrlv143draq3j7l42dj69w3px1x31qcr3n5pgcv";
  };

  inherit (pkgs) lib stdenv;

  lib-path = with pkgs; lib.makeLibraryPath [
    glib
    stdenv.cc.cc
  ];

  python-overlay = self: super:
    {
      my-python3 =
        super.python3.withPackages (p: with p; [
          pip
          setuptools
          virtualenv
          wheel
        ]);
    };

  # poetry-overlay = self: super:
  #   {
  #     my-poetry = self.poetry.override { python = self.my-python; } ;
  #   };

  pkgs = import nixpkgs {
    overlays = [
      python-overlay
      # poetry-overlay
    ];
  };


in

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    poetry
  ];

  shellHook = ''
    export "LD_LIBRARY_PATH=${lib-path}"
  '';
}
