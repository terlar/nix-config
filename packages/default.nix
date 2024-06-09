_: prev:
let
  paperwm = prev.gnomeExtensions.paperwm.override (_: {
    version = "113";
    sha256 = "sha256-RuLj4JLHPOKA/4g0Nmvr2Ti0oVw+qCUCJCxjNVe6cq0=";
  });
in
{
  gnomeExtensions = prev.gnomeExtensions // {
    inherit paperwm;
  };
  gnome46Extensions = prev.gnome46Extensions // {
    "paperwm@paperwm.github.com" = paperwm;
  };
}
