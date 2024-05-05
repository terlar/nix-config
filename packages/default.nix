_: prev: {
  gnome45Extensions = prev.gnome45Extensions // {
    "paperwm@paperwm.github.com" = prev.gnome45Extensions."paperwm@paperwm.github.com".override (_: {
      version = "99";
      sha256 = "sha256-LyvCfDKKdLh/gL+pNyDzlYfNJUq5GYkGTDwZ0JLFU5c=";
    });
  };
}
