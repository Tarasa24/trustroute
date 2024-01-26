{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [ 
      ruby
      nodejs yarn 
      overmind
      redis
    ];

    shellHook = ''
      export DB_USER=postgres
      export DB_PASSWORD=postgres

      codium .
    '';
  }
