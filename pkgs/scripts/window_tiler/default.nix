{ stdenv, substituteAll, python3, libXinerama, libX11, wmctrl, xdotool, xwininfo
}:

stdenv.mkDerivation {
  name = "window_tiler";

  src = ./.;

  buildInputs = [
    (python3.withPackages (ps: with ps; [ screeninfo click ]))
    libXinerama
    libX11
    wmctrl
    xdotool
    xwininfo
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      wmctrl = "${wmctrl}/bin/wmctrl";
      xdotool = "${xdotool}/bin/xdotool";
      xwininfo = "${xwininfo}/bin/xwininfo";
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp window_tiler.py $out/bin/window_tiler
    chmod +x $out/bin/window_tiler
  '';
}
