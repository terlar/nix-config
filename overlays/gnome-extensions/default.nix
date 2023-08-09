final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      paperwm = final.stdenv.mkDerivation rec {
        pname = "gnome-shell-extension-paperwm";
        version = "44.7.1";

        src = final.fetchFromGitHub {
          owner = "paperwm";
          repo = "PaperWM";
          rev = "v${version}";
          sha256 = "sha256-EY3NbKG7V8kWOkD/FspYYFm5Qfi02vgPE3wtDUDqswQ=";
        };

        passthru.extensionUuid = "paperwm@paperwm.github.com";

        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
          cp -r . "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Tiled scrollable window management for Gnome Shell";
          homepage = "https://github.com/paperwm/PaperWM";
          license = licenses.gpl3;
          maintainers = with maintainers; [terlar];
        };
      };
    };
}
