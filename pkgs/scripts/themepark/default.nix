{ stdenv, writeShellScriptBin }:

let
  brightsideScript = writeShellScriptBin "brightside" ''
    if command -v emacsclient >/dev/null; then
      emacsclient -n -e "(mapc #'disable-theme custom-enabled-themes)" -e "(load-theme init-default-light-theme t)" >/dev/null
    fi
    if command -v kitty >/dev/null; then
      colors_file="$XDG_CONFIG_HOME/kitty/colors-light.conf"
      kitty @ set-colors -a "$colors_file"
      ln -fs "$colors_file" "$XDG_CONFIG_HOME/kitty/colors.conf"
    fi
  '';
  darksideScript = writeShellScriptBin "darkside" ''
    if command -v emacsclient >/dev/null; then
      emacsclient -n -e "(mapc #'disable-theme custom-enabled-themes)" -e "(load-theme init-default-dark-theme t)" >/dev/null
    fi
    if command -v kitty >/dev/null; then
      colors_file="$XDG_CONFIG_HOME/kitty/colors-dark.conf"
      kitty @ set-colors -a "$colors_file"
      ln -fs "$colors_file" "$XDG_CONFIG_HOME/kitty/colors.conf"
    fi
  '';
in stdenv.mkDerivation {
  name = "themepark";

  buildInputs = [ brightsideScript darksideScript ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${brightsideScript}/bin/brightside $out/bin
    ln -s ${darksideScript}/bin/darkside $out/bin
  '';
}
