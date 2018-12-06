pkgs: epkgs:

with epkgs;

let
  ## Fix font-lock issue.
  all-the-icons = melpaPackages.all-the-icons.overrideAttrs(attrs: {
    patches = [ ./emacs/all-the-icons-font-lock-fix.patch ];
  });

  ## Fix issue with wdired
  all-the-icons-dired = melpaPackages.all-the-icons-dired.overrideAttrs(attrs: {
    patches = [ ./emacs/all-the-icons-dired-wdired-fix.patch];
  });

  ## Latest version.
  eglot = melpaPackages.eglot.overrideAttrs(attrs: {
    version = "20181204";
    src = pkgs.fetchFromGitHub {
      owner  = "joaotavora";
      repo   = "eglot";
      rev    = "53bfdb7087b9b4a7c79abc3863c90b6d06ecca1f";
      sha256 = "0pmd2xvgdnpb3bgcv9w85h2prm4j67yw35fw5srcfym4fcd79pyq";
      # date = 2018-12-04T23:10:35+00:00;
    };
  });

  ## Latest version.
  ivy = melpaPackages.ivy.overrideAttrs(attrs: {
    version = "20181129";
    src = pkgs.fetchFromGitHub {
      owner  = "abo-abo";
      repo   = "swiper";
      rev    = "86635fb8268c07b9fb534357e8e0940c23edeef7";
      sha256 = "1bx091lh9kyqpw4dpgrlars6ziyl37vvva6ycw5w65a6f2bb57ia";
      # date = 2018-11-29T22:05:38+01:00;
    };
  });

  ## Add missing dependencies.
  kubernetes = melpaPackages.kubernetes.overrideAttrs(attrs: {
    buildInputs = attrs.buildInputs ++ [ pkgs.git ];
  });

  ## Latest version.
  nix-mode = melpaPackages.nix-mode.overrideAttrs(attrs: {
    version = "20181120";
    src = pkgs.fetchFromGitHub {
      owner  = "nixos";
      repo   = "nix-mode";
      rev    = "90ac0a74b205f11dc456676b6dbefc5072e7eb6c";
      sha256 = "00v70v64icsi5iwrimdb311rvlcpazwg22hg12x7l6m87c949krf";
      # date = 2018-11-20T16:53:03-06:00;
    };
  });

  ## New package.
  org-pretty-table = melpaBuild rec {
    pname   = "org-pretty-table";
    version = "20131129";
    src = pkgs.fetchFromGitHub {
      owner  = "fuco1";
      repo   = "org-pretty-table";
      rev    = "0dca6f3156dd1eb0a42f08ac2ad89259637a16b5";
      sha256 = "09avbl1mmgs3b1ya0rvv9kswq2k7d133zgr18cazl3jkpvh35lxg";
      # date = 2013-11-29T16:10:09+01:00;
    };
    recipe = pkgs.writeText "recipe" ''
      (org-pretty-table :repo "fuco1/org-pretty-table" :fetcher github)
    '';

    meta = {
      description = "Replace org-table characters with box-drawing unicode glyphs";
      longDescription = ''
        This replaces the characters - | and + in `org-mode' tables with
        appropriate unicode box-drawing glyphs, see
        http://en.wikipedia.org/wiki/Box-drawing_character
      '';
    };
  };

  ## New package.
  rotate-text = melpaBuild rec {
    pname   = "rotate-text";
    version = "20090413";
    src = pkgs.fetchFromGitHub {
      owner  = "nschum";
      repo   = "rotate-text.el";
      rev    = "74c456f91bfefb19dfcd33dbb3bd8574d1f185c6";
      sha256 = "1cgxv4aibkvv6lnssynn0438a615fz3zq8hg9sb0lhfgsr99pxln";
      # date = 2009-04-13T22:36:18+02:00;
    };
    recipe = pkgs.writeText "recipe" ''
      (rotate-text :repo "nschum/rotate-text.el" :fetcher github)
    '';

    meta = {
      description = "Cycle through words, symbols and patterns";
      longDescription = ''
        rotate-text allows you cycle through commonly interchanged text with a single
        keystroke.  For example, you can toggle between "frame-width" and
        "frame-height", between "public", "protected" and "private" and between
        "variable1", "variable2" through "variableN".
      '';
    };
  };

  ## Add support for relative path
  rspec-mode = melpaPackages.rspec-mode.overrideAttrs(attrs: {
    patches = [ ./emacs/rspec-mode-relative-path.patch ];
  });

  ## New package
  source-peek = melpaBuild rec {
    pname   = "source-peek";
    version = "20170424";
    src = pkgs.fetchFromGitHub {
      owner  = "iqbalansari";
      repo   = "emacs-source-peek";
      rev    = "fa94ed1def1e44f3c3999d355599d1dd9bc44dab";
      sha256 = "14ai66c7j2k04a0vav92ybaikcc8cng5i5vy0iwpg7b2cws8a2zg";
      # date = 2017-04-24T03:47:10+05:30;
    };
    recipe = pkgs.writeText "recipe" ''
      (source-peek :repo "iqbalansari/emacs-source-peek" :fetcher github)
    '';

    meta = {
      description = "Display function definitions inline";
      longDescription = ''
        This package adds the command `source-peek' which fetches the definition of
        the function at point (using different backends) and displays them inline in
        the current buffer.
      '';
    };
  };
in (with melpaPackages; [
  use-package
  ace-link
  ace-window
  aggressive-indent
  alchemist
  all-the-icons
  all-the-icons-dired
  all-the-icons-ivy
  ansible
  ansible-doc
  async
  auto-compile
  auto-dictionary
  auto-minor-mode
  avy
  bibliothek
  cakecrumbs
  camcorder
  caml
  cider
  clojure-mode
  color-identifiers-mode
  company
  counsel
  counsel-tramp
  coverlay
  crystal-mode
  csv-mode
  deadgrep
  default-text-scale
  defrepeater
  deft
  devdocs
  diff-hl
  diminish
  dired-sidebar
  dired-subtree
  direnv
  docker
  docker-compose-mode
  docker-tramp
  dockerfile-mode
  dumb-jump
  easy-escape
  edit-indirect
  editorconfig
  eglot
  eldoc-overlay
  elixir-mode
  elm-mode
  emmet-mode
  ensime
  erlang
  eros
  es-mode
  esh-autosuggest
  eshell-fringe-status
  esup
  eval-in-repl
  exec-path-from-shell
  eyebrowse
  fish-completion
  fish-mode
  flymake-shellcheck
  flyspell-correct-ivy
  focus
  format-all
  general
  git
  git-messenger
  gitignore-mode
  go-eldoc
  go-mode
  gorepl-mode
  goto-chg
  gradle-mode
  groovy-mode
  haskell-mode
  hasky-stack
  helpful
  hide-lines
  hide-mode-line
  highlight-numbers
  highlight-quoted
  hl-todo
  idle-highlight-mode
  imenu-anywhere
  imenu-list
  indent-guide
  indent-info
  indium
  inf-crystal
  inf-ruby
  isend-mode
  ivy
  ivy-erlang-complete
  ivy-xref
  ivy-yasnippet
  javadoc-lookup
  js2-mode
  js2-refactor
  kotlin-mode
  kubernetes
  kubernetes-tramp
  lua-mode
  magit
  markdown-mode
  markdown-toc
  miniedit
  minions
  minitest
  nameless
  nginx-mode
  nix-mode
  nix-update
  no-littering
  nodejs-repl
  nov
  ob-http
  objed
  org-bullets
  org-cliplink
  org-noter
  org-pretty-table
  org-preview-html
  org-radiobutton
  org-tree-slide
  org-variable-pitch
  package-lint
  page-break-lines
  pdf-tools
  pip-requirements
  plantuml-mode
  projectile
  protobuf-mode
  pug-mode
  pydoc
  python
  python-test
  quick-peek
  quickrun
  racket-mode
  rainbow-delimiters
  rainbow-identifiers
  rainbow-mode
  rake
  redtick
  rotate-text
  rspec-mode
  rubocopfmt
  ruby-refactor
  rustic
  salt-mode
  sbt-mode
  scala-mode
  slim-mode
  slime
  smart-jump
  smartparens
  smex
  source-peek
  spray
  string-edit
  stripe-buffer
  suggest
  swiper
  tao-theme
  transpose-frame
  ts-comint
  tuareg
  typescript-mode
  visual-fill-column
  vlf
  web-mode
  wgrep-ag
  which-key
  whole-line-or-region
  ws-butler
  yaml-mode
  yard-mode
  yari
  yasnippet
  yasnippet-snippets
  yatemplate
  zoom-window
] ++ (with orgPackages; [
  org
  org-plus-contrib
]))
