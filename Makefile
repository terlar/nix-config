UNAME               := $(shell uname)
NIX_CONF            := $(CURDIR)
NIX_PATH            := darwin=$(NIX_CONF)/darwin:darwin-config=$(NIX_CONF)/config/darwin.nix:nixpkgs=$(NIX_CONF)/nixpkgs
NIXOS_CONFIG        := $(NIX_CONF)/configuration.nix
HOME_MANAGER_CONFIG := $(NIX_CONF)/config/home.nix
NIXOS_HOSTS         := $(addprefix install-nixos-,$(notdir $(wildcard hosts/*)))

ifeq ($(UNAME),Darwin)
SWITCH_SYSTEM := switch-darwin
endif
ifeq ($(UNAME),Linux)
SWITCH_SYSTEM := switch-nixos
endif

export NIX_PATH
export NIXOS_CONFIG
export HOME_MANAGER_CONFIG

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help message.
	$(info $(NAME) $(TAG))
	@echo "Usage: make [target] ..."
	@echo
	@echo "Targets:"
	@egrep '^(.+)\:[^#]*##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: install-nix install-darwin install-home
install-nix: ## Install nix and update submodules
	curl https://nixos.org/nix/install | sh
	git submodule update --init
install-darwin: ## Install darwin
	nix-shell darwin -A installer --run darwin-installer
install-home: ## Install home-manager
	nix-shell home-manager -A install --run 'home-manager switch'

$(NIXOS_HOSTS):
install-nixos-%: hosts/%/configuration.nix hosts/%/hardware-configuration.nix
	ln -s $? .

.PHONY: switch switch-home
switch: switch-system switch-home ## Switch all
switch-home: ## Switch to latest home config
	home-manager switch
	@echo "Home generation: $$(home-manager generations | head -1)"

.PHONY: switch-system switch-nixos switch-darwin
switch-system: ## Switch to latest system config
switch-system: $(SWITCH_SYSTEM)
switch-nixos: ## Switch to latest NixOS config
	nixos-rebuild switch
switch-darwin: ## Switch to latest Darwin config
	darwin-rebuild switch -Q
	@echo "Darwin generation: $$(darwin-rebuild --list-generations | tail -1)"

.PHONY: pull
pull: ## Pull latest upstream changes
	(cd darwin             && git pull --rebase)
	(cd home-manager       && git pull --rebase)
	(cd nixpkgs            && git pull --rebase)
	(cd overlays/emacs/src && git pull --rebase)
