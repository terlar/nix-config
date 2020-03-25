{ ... }:

{
  home.file.".ripgreprc".text = ''
    --max-columns=150
    --max-columns-preview

    --glob=!.git/*

    --smart-case
  '';
}
