SHELL:=/bin/bash
ENGINE_DIR:=$(CURDIR)/../../engine
CLI_DIR:=$(CURDIR)/../../cli
ENGINE_VER=$(shell cat $(ENGINE_DIR)/VERSION)
VERSION=$(shell cat $(ENGINE_DIR)/VERSION)
ARCH:=$(shell $(CURDIR)/../detect_arch)

.PHONY: help clean ros-base ros-static-linux-amd64 ros-static-linux-arm64

help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove build artifacts
	$(RM) -r build

# Only what BurmillaOS runs: no docker-proxy (userland proxy is off), docker-init (--init unused) or containerd-ctr (debug tool)
ros-base:
	mkdir -p build/linux/docker
	cp $(CLI_DIR)/build/docker build/linux/docker/system-docker
	for f in dockerd docker-containerd docker-containerd-shim docker-runc; do \
		cp $(ENGINE_DIR)/bundles/$(ENGINE_VER)/binary-daemon/$$f build/linux/docker/system-$$f; \
	done
	tar -C build/linux -c -z -f build/linux/docker-${ARCH}-$(VERSION).tgz docker

ros-static-linux-amd64: ## create tgz with linux x86_64 client and server
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) build
	$(MAKE) -C $(ENGINE_DIR) binary
	$(MAKE) ros-base

ros-static-linux-arm64: ## create tgz with linux arm64 client and server
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) build_arm64
	$(MAKE) -C $(ENGINE_DIR) binary
	$(MAKE) ros-base
