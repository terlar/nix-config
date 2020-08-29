{ stdenv, writeShellScriptBin }:

let
  brightsideScript = writeShellScriptBin "brightside" ''
    if command -v emacsclient >/dev/null; then
      emacsclient -n -e "(customize-set-variable 'frame-background-mode 'light)" -e "(customize-set-variable 'custom-enabled-themes custom-enabled-themes)" >/dev/null
    fi
    if command -v kitty >/dev/null; then
      colors_file="$XDG_CONFIG_HOME/kitty/colors-light.conf"
      kitty @ set-colors -a "$colors_file"
      ln -fs "$colors_file" "$XDG_CONFIG_HOME/kitty/colors.conf"
    fi
  '';
  darksideScript = writeShellScriptBin "darkside" ''
    if command -v emacsclient >/dev/null; then
      emacsclient -n -e "(customize-set-variable 'frame-background-mode 'dark)" -e "(customize-set-variable 'custom-enabled-themes custom-enabled-themes)" >/dev/null
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
