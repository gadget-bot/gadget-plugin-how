GO          ?= go
GO_FILES    := $(shell find . -type f -name '*.go')

.PHONY: all
all: clean verify lint test build

###############
##@ Development

# This is to allow make to detect when other targes should be rerun (source changes)
$(GO_FILES):
	@stat -c "%y %n" "$@"

.PHONY: verify
verify:   ## Verify 'vendor' dependencies
	@ $(MAKE) --no-print-directory log-$@
	$(GO) mod verify

.PHONY: fmt ## Format the project
fmt:
	@$(MAKE) --no-print-directory log-$@
	@golangci-lint fmt --diff

.PHONY: lint ## Lint the project
lint: fmt
	@$(MAKE) --no-print-directory log-$@
	@golangci-lint run

.PHONY: test
test: coverage.out ## Execute tests
coverage.out: $(GO_FILES)
	@$(MAKE) --no-print-directory log-$@
	$(GO) test -coverprofile=coverage.out -covermode=atomic -v ./...

.PHONY: build
build: ## Build the project
	@$(MAKE) --no-print-directory log-$@
	$(GO) build ./...

.PHONY: clean
clean: ## Clean the workspace including modcache and dist/
	@$(MAKE) --no-print-directory log-$@
	@$(GO) clean -modcache
	@rm -rf dist/* coverage.out

.PHONY: tools
tools: ## Install tools needed for development
	@$(MAKE) --no-print-directory log-$@
	@$(GO) install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.10.1

###########################################################################
## Self-Documenting Makefile Help and logging                            ##
## https://github.com/terraform-docs/terraform-docs/blob/master/Makefile ##
## https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html    ##
###########################################################################

########
##@ Help

.PHONY: help
help:   ## Display this help
	@awk \
		-v "col=\033[36m" -v "nocol=\033[0m" \
		' \
			BEGIN { \
				FS = ":.*##" ; \
				printf "Usage:\n  make %s<target>%s\n", col, nocol \
			} \
			/^[a-zA-Z_-]+:.*?##/ { \
				printf "  %s%-12s%s %s\n", col, $$1, nocol, $$2 \
			} \
			/^##@/ { \
				printf "\n%s%s%s\n", nocol, substr($$0, 5), nocol \
			} \
		' $(MAKEFILE_LIST)

log-%:
	@grep -h -E '^$*:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk \
			'BEGIN { \
				FS = ":.*?## " \
			}; \
			{ \
				printf "\033[36m==> %s\033[0m\n", $$2 \
			}'