SHELL:=/bin/bash
ENGINE_DIR:=$(CURDIR)/../engine
CLI_DIR:=$(CURDIR)/../cli
VERSION=unknown

.PHONY: help clean ros-static-amd64 ros-static-arm64

help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove build artifacts
	$(MAKE) -C static clean

ros-static-amd64 ros-static-arm64: ros-static-%: ## build System Docker static tgz
	$(MAKE) -C static VERSION=$(VERSION) ENGINE_DIR=$(ENGINE_DIR) CLI_DIR=$(CLI_DIR) ros-static-linux-$*
