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

.PHONY: install-qutebrowser-dicts
install-qutebrowser-dicts:
	$(shell nix-build '<nixpkgs>' --no-build-output -A qutebrowser)/share/qutebrowser/scripts/dictcli.py install $(QUTEBROWSER_DICTS)

.PHONY: programs.sqlite
programs.sqlite:
	wget https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz -O - \
	  | tar xJf - --wildcards "nixos*/programs.sqlite" -O \
	  > programs.sqlite

.PHONY: backup
backup: backup/$(TIMESTAMP)

backup/$(TIMESTAMP):
	mkdir -p $@/fish $@/gnupg
	cp $(HOME)/.local/share/fish/fish_history* $@/fish/.
	cp $(HOME)/.gnupg/sshcontrol $@/gnupg/.
