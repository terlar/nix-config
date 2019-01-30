UNAME               := $(shell uname)
NIX_CONF            := $(CURDIR)
NIXOS_CONFIG        := $(NIX_CONF)/configuration.nix
HOME_MANAGER_CONFIG := $(NIX_CONF)/config/home.nix
NIX_PATH            := nixpkgs=$(NIX_CONF)/nixpkgs:nixos-config=$(NIXOS_CONFIG):darwin=$(NIX_CONF)/darwin:darwin-config=$(NIX_CONF)/config/darwin.nix
NIXOS_HOSTS         := $(addprefix install-nixos-,$(notdir $(wildcard hosts/*)))
PRIVATE_CONFIG_PATH := ../nix-config-private

ifeq ($(UNAME),Darwin)
SWITCH_SYSTEM := switch-darwin
endif
ifeq ($(UNAME),Linux)
SWITCH_SYSTEM := switch-nixos
endif

export NIX_PATH
export HOME_MANAGER_CONFIG

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help message.
	$(info $(NAME) $(TAG))
	@echo "Usage: make [target] ..."
	@echo
	@echo "Targets:"
	@egrep '^(.+)\:[^#]*##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: print-path
print-path: ## Print NIX_PATH
	@echo $(NIX_PATH)

.PHONY: init
init: ## Initialize sources (submodules)
	git submodule update --init

.PHONY: install-nix install-nixos install-darwin install-home install-private
install-nix: ## Install nix and update submodules
	curl https://nixos.org/nix/install | sh
install-nixos: ## Install NixOS for current host
	$(MAKE) install-nixos-$(shell hostname)
install-darwin: ## Install darwin
	nix-shell darwin -A installer --run darwin-installer
install-home: ## Install home-manager
	nix-shell home-manager -A install --run 'home-manager switch'
install-private: ## Install private configuration
	ln -s $(PRIVATE_CONFIG_PATH) private

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
	sudo -E nixos-rebuild switch
switch-darwin: ## Switch to latest Darwin config
	darwin-rebuild switch -Q
	@echo "Darwin generation: $$(darwin-rebuild --list-generations | tail -1)"

.PHONY: build-nixos
build-nixos:
	nixos-rebuild build

.PHONY: pull
pull: pull-dotfiles pull-emacs pull-nix ## Pull latest upstream changes
pull-emacs: ## Pull latest Emacs upstream changes
	git submodule update --remote overlays/emacs/src
pull-dotfiles: ## Pull latest dotfiles
	git submodule update --remote config/dotfiles
	git submodule update --remote config/emacs.d
pull-nix: ## Pull latest nix upstream changes
	git submodule update --remote darwin
	git submodule update --remote home-manager
	git submodule update --remote nixpkgs

.PHONY: clean
clean:
	-@rm configuration.nix hardware-configuration.nix private 2>/dev/null ||:
