CHECK_MK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

define check_packages_deps
print-deps:
	@sh $(CHECK_MK_DIR)deps.sh print

check-deps:
	@sh $(CHECK_MK_DIR)deps.sh check
endef
