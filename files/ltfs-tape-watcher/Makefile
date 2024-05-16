-include Makefile.local # for optional local config

OUTPUT_DIR ?= ./build## Build directory (default: ./build)

.PHONY: build
build:
	mkdir -p $(OUTPUT_DIR)
	crystal build src/ltfs-tape-watcher.cr -o $(OUTPUT_DIR)/ltfs-tape-watcher

.PHONY: run
run: ## pass arguments as `make run arguments="--arg1 value"`
	crystal run src/ltfs-tape-watcher.cr -- $(arguments)

.PHONY: clean
clean: ## Remove build directory
	rm -rvf $(OUTPUT_DIR)
