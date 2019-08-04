UNAME               := $(shell uname)
NIXOS_CONFIG        := $(CURDIR)/configuration.nix
HOME_MANAGER_CONFIG := $(CURDIR)/config/home.nix
NIX_PATH            := nixpkgs=$(CURDIR)/nixpkgs:nixpkgs-overlays=$(CURDIR)/overlays:home-manager=$(CURDIR)/home-manager:private-data=$(CURDIR)/private/data.nix
NIXOS_HOSTS         := $(addprefix install-nixos-,$(notdir $(wildcard hosts/*)))
PRIVATE_CONFIG_PATH := ../nix-config-private

TIMESTAMP ?= $(shell date +%Y%m%d%H%M%S)

ifeq ($(UNAME),Darwin)
SWITCH_SYSTEM := switch-darwin
GC_SYSTEM     := gc-darwin
NIX_PATH      := $(NIX_PATH):darwin=$(CURDIR)/darwin:darwin-config=$(CURDIR)/config/darwin.nix
endif
ifeq ($(UNAME),Linux)
SWITCH_SYSTEM := switch-nixos
GC_SYSTEM     := gc-nixos
NIX_PATH      := $(NIX_PATH):nixos-config=$(NIXOS_CONFIG)
endif

export NIX_PATH
export HOME_MANAGER_CONFIG

QUTEBROWSER_DICTS := en-US sv-SE

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
	nix-shell home-manager -A install --run 'home-manager -b bak switch'
install-private: private ## Install private configuration

$(NIXOS_HOSTS):
install-nixos-%: hosts/%/configuration.nix hosts/%/hardware-configuration.nix
	ln -s $? .

.PHONY: install-qutebrowser-dicts
install-qutebrowser-dicts:
	$(shell nix-build '<nixpkgs>' --no-build-output -A qutebrowser)/share/qutebrowser/scripts/dictcli.py install $(QUTEBROWSER_DICTS)

.PHONY: switch switch-home
switch: switch-system switch-home ## Switch all
switch-home: ## Switch to latest home config
	home-manager -b bak switch
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
	git submodule sync config/dotfiles config/emacs.d
	git submodule update --remote config/dotfiles
	git submodule update --remote config/emacs.d
pull-nix: ## Pull latest nix upstream changes
	git submodule sync darwin home-manager nixpkgs
	git submodule update --remote darwin
	git submodule update --remote home-manager
	git submodule update --remote nixpkgs

.PHONY: dev-emacs-config dev-home-manager dev-nixpkgs
dev-emacs-config: ## Use local config/emacs.d
	git config --file=.gitmodules submodule."config/emacs.d".url file://$(HOME)/src/github.com/terlar/emacs.d
	git submodule update --remote config/emacs.d
dev-home-manager: ## Use my home-manager fork
	git config --file=.gitmodules submodule.home-manager.url https://github.com/terlar/home-manager.git
	git submodule sync home-manager
	git submodule update --remote home-manager
dev-nixpkgs: ## Use my nixpkgs fork
	git config --file=.gitmodules submodule.nixpkgs.url https://github.com/terlar/nixpkgs.git
	git submodule sync nixpkgs
	git submodule update --remote nixpkgs

.PHONY: gc gc-home
gc: gc-system gc-home ## Clean up system packages and home generations (older than 2 weeks)
gc-home: # Clean up home generations (older than 2 weeks)
	home-manager expire-generations '-2 weeks'

.PHONY: gc-system gc-nixos gc-darwin
gc-system: # Clean system packages (older than 2 weeks)
gc-system: $(GC_SYSTEM)
gc-nixos: # Clean up NixOS packages (older than 2 weeks)
	sudo -E nix-env -p /nix/var/nix/profiles/system --delete-generations old
	nix-collect-garbage -d --delete-older-than 2w
	sudo -E nixos-rebuild boot
gc-darwin: # Clean up Darwin packages (older than 2 weeks)
	nix-collect-garbage -d --delete-older-than 2w

.PHONY: clean
clean:
	-@rm configuration.nix hardware-configuration.nix private 2>/dev/null ||:

.PHONY: programs.sqlite
programs.sqlite:
	wget https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz -O - \
	  | tar xJf - --wildcards "nixos*/programs.sqlite" -O \
	  > programs.sqlite

private:
	ln -s $(PRIVATE_CONFIG_PATH) $@

.PHONY: backup
backup: backup/$(TIMESTAMP)

backup/$(TIMESTAMP):
	mkdir -p $@/fish $@/gnupg
	cp $(HOME)/.local/share/fish/fish_history* $@/fish/.
	cp $(HOME)/.gnupg/sshcontrol $@/gnupg/.
