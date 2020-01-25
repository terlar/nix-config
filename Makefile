.DEFAULT_GOAL = help
.PHONY: help
help: ## Show this help message.
	$(info $(NAME) $(TAG))
	@echo "Usage: make [target] ..."
	@echo
	@echo "Targets:"
	@egrep '^(.+)\:[^#]*##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: programs.sqlite
programs.sqlite:
	wget https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz -O - \
	  | tar xJf - --wildcards "nixos*/programs.sqlite" -O \
	  > programs.sqlite
