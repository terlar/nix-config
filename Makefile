NIXOS_HOSTS         := $(addprefix install-nixos-,$(notdir $(wildcard hosts/*)))
PRIVATE_CONFIG_PATH ?= ../nix-config-private

TIMESTAMP = $(shell date +%Y%m%d%H%M%S)

QUTEBROWSER_DICTS = en-US sv-SE

.DEFAULT_GOAL = help
.PHONY: help
help: ## Show this help message.
	$(info $(NAME) $(TAG))
	@echo "Usage: make [target] ..."
	@echo
	@echo "Targets:"
	@egrep '^(.+)\:[^#]*##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

$(NIXOS_HOSTS):
install-nixos-%: hosts/%/configuration.nix hosts/%/hardware-configuration.nix
	ln -s $? .

.PHONY: install-qutebrowser-dicts
install-qutebrowser-dicts:
	$(shell nix-build '<nixpkgs>' --no-build-output -A qutebrowser)/share/qutebrowser/scripts/dictcli.py install $(QUTEBROWSER_DICTS)

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
