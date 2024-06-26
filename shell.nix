{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
      ruby_3_3
      rubyPackages_3_3.ffi rubyPackages_3_3.nokogiri rubyPackages_3_3.sassc
      rubyPackages_3_3.ruby-lsp rubyPackages_3_3.prism
      nodejs yarn
      overmind
      redis
      libstdcxx5 zlib xz libxml2 prism
      gnupg gpgme
    ];

    shellHook = ''
      [ "$IN_NIX_SHELL" = "impure" ] && codium .vscode/trustroute.code-workspace
    '';
  }
