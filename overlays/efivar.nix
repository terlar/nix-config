self: super:
{
  efivar = super.efivar.overrideDerivation (finalAttrs: rec {
    version = "37";
    src = super.fetchFromGitHub {
      owner = "rhinstaller";
      repo = "efivar";
      rev = version;
      sha256 = "1z2dw5x74wgvqgd8jvibfff0qhwkc53kxg54v12pzymyibagwf09";
      # date = 2018-12-05T11:17:42-05:00;
    };
  });
}
