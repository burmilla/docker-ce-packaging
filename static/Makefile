SHELL:=/bin/bash
ALPINE_IMG:=$(shell $(CURDIR)/../detect_alpine_image)
ENGINE_DIR:=$(CURDIR)/../../engine
CLI_DIR:=$(CURDIR)/../../cli
ENGINE_VER=$(shell cat $(ENGINE_DIR)/VERSION)
VERSION=$(shell cat $(ENGINE_DIR)/VERSION)
CHOWN=docker run --rm -v $(CURDIR):/v -w /v $(ALPINE_IMG) chown
HASH_CMD=docker run -v $(CURDIR):/sum -w /sum debian:jessie bash hash_files
DIR_TO_HASH:=build/linux
ARCH:=$(shell $(CURDIR)/../detect_arch)

.PHONY: help clean static static-linux cross-mac cross-win cross-arm static-cli static-engine cross-all-cli cross-win-engine hash_files

help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove build artifacts
	[ ! -d build ] || $(CHOWN) -R $(shell id -u):$(shell id -g) build
	$(RM) -r build

static: static-linux cross-mac cross-win cross-arm ## create all static packages

static-linux: static-cli static-engine ## create tgz with linux x86_64 client and server
	mkdir -p build/linux/docker
	cp $(CLI_DIR)/build/docker build/linux/docker/
	for f in dockerd docker-containerd docker-containerd-ctr docker-containerd-shim docker-init docker-proxy docker-runc; do \
		cp $(ENGINE_DIR)/bundles/$(ENGINE_VER)/binary-daemon/$$f build/linux/docker; \
	done
	tar -C build/linux -c -z -f build/linux/docker-$(VERSION).tgz docker

ros-base:
	mkdir -p build/linux/docker
	cp $(CLI_DIR)/build/docker build/linux/docker/system-docker
	for f in dockerd docker-containerd docker-containerd-ctr docker-containerd-shim docker-init docker-proxy docker-runc; do \
		cp $(ENGINE_DIR)/bundles/$(ENGINE_VER)/binary-daemon/$$f build/linux/docker/system-$$f; \
	done
	tar -C build/linux -c -z -f build/linux/docker-${ARCH}-$(VERSION).tgz docker

ros-static-linux-amd64: ros-static-cli-amd64 ros-static-engine ros-base## create tgz with linux x86_64 client and server

ros-static-linux-arm64: ros-static-cli-arm64 ros-static-engine ros-base## create tgz with linux arm64 client and server

ros-static-linux-mips64el: ros-static-cli-mips64el ros-static-engine ros-base## create tgz with linux mips64el client and server

hash_files:
	@echo "Hashing directory $(DIR_TO_HASH)"
	$(HASH_CMD) "$(DIR_TO_HASH)"

cross-mac: cross-all-cli ## create tgz with darwin x86_64 client only
	mkdir -p build/mac/docker
	cp $(CLI_DIR)/build/docker-darwin-amd64 build/mac/docker/docker
	tar -C build/mac -c -z -f build/mac/docker-$(VERSION).tgz docker

cross-win: cross-all-cli cross-win-engine ## create zip file with windows x86_64 client and server
	mkdir -p build/win/docker
	cp $(CLI_DIR)/build/docker-windows-amd64 build/win/docker/docker.exe
	cp $(ENGINE_DIR)/bundles/$(ENGINE_VER)/cross/windows/amd64/dockerd-$(ENGINE_VER).exe build/win/docker/dockerd.exe
	docker run --rm -v $(CURDIR)/build/win:/v -w /v $(ALPINE_IMG) sh -c 'apk update&&apk add zip&&zip -r docker-$(VERSION).zip docker'
	$(CHOWN) -R $(shell id -u):$(shell id -g) build

cross-arm: cross-all-cli ## create tgz with linux armhf client only
	mkdir -p build/arm/docker
	cp $(CLI_DIR)/build/docker-linux-arm build/arm/docker/docker
	tar -C build/arm -c -z -f build/arm/docker-$(VERSION).tgz docker

static-cli:
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) build

static-cli-arm64:
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) build_arm64

static-cli-mips64el:
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) build_mips64el

ros-static-cli-amd64: static-cli

ros-static-cli-arm64: static-cli-arm64

ros-static-cli-mips64el: static-cli-mips64el

static-engine:
	$(MAKE) -C $(ENGINE_DIR) binary

ros-static-engine: static-engine

cross-all-cli:
	$(MAKE) -C $(CLI_DIR) -f docker.Makefile VERSION=$(VERSION) cross

cross-win-engine:
	$(MAKE) -C $(ENGINE_DIR) DOCKER_CROSSPLATFORMS=windows/amd64 cross
