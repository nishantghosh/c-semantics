KOMPILE_DEFAULT_FLAGS := --backend ocaml --non-strict --smt none
CPP_KOMPILE_FLAGS := --opaque-klabels c-translation.k
EXECUTION_KOMPILE_FLAGS := \
	--opaque-klabels \
	cpp-translation.k \
	--no-expand-macros \
	--ocaml-serialize-config '$$PGM' \
	--ocaml-dump-exit-code 139
KDEP_DEFAULT_FLAGS :=

define timestamp_of
    .build/$(PROFILE)/$(1)-kompiled/$(1)-kompiled/timestamp
endef

.PHONY: default
default: fast

$(call timestamp_of,c-translation):
	@echo "Kompiling the static C semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) c-translation.k \
		-d ".build/$(PROFILE)/c-translation-kompiled" \
		--no-prelude -w all -v --debug \
		-I $(PROFILE_DIR)/semantics

$(call timestamp_of,cpp-translation):
	@echo "Kompiling the static C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) cpp-translation.k \
		-d ".build/$(PROFILE)/cpp-translation-kompiled" \
		--no-prelude -w all -v --debug \
		-I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-cpp-linking):
	@echo "Kompiling the C and C++ linking semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(CPP_KOMPILE_FLAGS) c-cpp-linking.k \
		-d ".build/$(PROFILE)/c-cpp-linking-kompiled" \
		--no-prelude -w all -v --debug \
		-I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-cpp):
	@echo "Kompiling the dynamic C and C++ semantics..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp.k \
		-d ".build/$(PROFILE)/c-cpp-kompiled" \
		--no-prelude -w all -v --transition "interpRule" \
		--debug \
		-I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-nd):
	@echo "Kompiling the dynamic C and C++ semantics with expression sequencing non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp.k \
		-d ".build/$(PROFILE)/c-nd-kompiled" \
		--no-prelude --transition "observable ndtrans" \
		--superheat "ndheat" --supercool "ndlocal" \
		-I $(PROFILE_DIR)/semantics

$(call timestamp_of,c-nd-thread):
	@echo "Kompiling the dynamic C and C++ semantics with thread-interleaving non-determinism..."
	$(KOMPILE) $(KOMPILE_DEFAULT_FLAGS) $(EXECUTION_KOMPILE_FLAGS) c-cpp.k \
		-d ".build/$(PROFILE)/c-nd-thread-kompiled" \
		--no-prelude --transition "observable ndtrans ndthread" \
		-I $(PROFILE_DIR)/semantics

.PHONY: all
all: fast nd thread

.PHONY: fast
fast: $(addsuffix -semantics,c-translation c-cpp c-cpp)

.PHONY: fast-cpp
fast-cpp: $(addsuffix -semantics,c-translation c-cpp c-cpp-linking cpp-translation)

XYZ_SEMANTICS := $(addsuffix -semantics,c-translation cpp-translation c-cpp-linking c-cpp)
.PHONY: $(XYZ_SEMANTICS)
.SECONDEXPANSION:
$(XYZ_SEMANTICS): %-semantics: $(call timestamp_of,$$*)

.PHONY: nd
nd: $(call timestamp_of,c-nd)

.PHONY: thread
thread: $(call timestamp_of,c-nd-thread)

.PHONY: clean
clean:
	@-rm -rf */c-translation-kompiled \
           */cpp-translation-kompiled \
					 */c-cpp-kompiled \
					 */c-nd-kompiled \
					 */c-nd-thread-kompiled \
					 .kompile-* \
					 .depend-* \
					 .build/*

BASIC_DEPENDS := $(addprefix .depend-$(PROFILE)-basic-,c-translation cpp-translation c-cpp-linking c-cpp)
SPECIAL_DEPENDS := .depend-$(PROFILE)-nd .depend-$(PROFILE)-nd-thread
DEPENDS := $(BASIC_DEPENDS) $(SPECIAL_DEPENDS)

.PHONY: $(DEPENDS)

# See https://stackoverflow.com/a/4270649/6209703
ifneq ($(MAKECMDGOALS),clean)
  -include $(DEPENDS)
endif

KDEP_FLAGS := $(KDEP_DEFAULT_FlAGS)
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics/c
KDEP_FLAGS += -I $(PROFILE_DIR)/semantics/cpp

$(BASIC_DEPENDS): .depend-$(PROFILE)-basic-%:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d ".build/$(PROFILE)/$*-kompiled" -- $*.k > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-nd:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d ".build/$(PROFILE)/c-nd-kompiled" -- c-cpp.k > $(TMP)
	mv $(TMP) $@

.depend-$(PROFILE)-nd-thread:
	$(eval TMP := $(shell mktemp))
	$(KDEP) $(KDEP_FLAGS) -d ".build/$(PROFILE)/c-nd-thread-kompiled" -- c-cpp.k > $(TMP)
	mv $(TMP) $@
