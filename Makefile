# Note: in order to use py/common.py you need to first install libadalang
# and then run:
# pip install <prefix>/share/libadalang/python/Libadalang-*.whl

TMP_GEN_DIR=gen
OUT_DIR=out

LLVM_INCLUDE_DIR=$(LLVM_INSTALL_DIR)/include
LLVM_INCLUDE_DIR_C=$(LLVM_INCLUDE_DIR)/llvm-c
CLANG_INCLUDE_DIR=$(LLVM_INSTALL_DIR)/include
CLANG_INCLUDE_DIR_C=$(CLANG_INCLUDE_DIR)/clang-c

.PHONY: llvm-bindings clang-bindings

all: llvm-bindings clang-bindings

# Bindings generation works with GNAT versions starting from 22.0
# (in terms of date > 2021-06-16)

check-llvm-install-dir:
ifndef LLVM_INSTALL_DIR
	$(error Need to set LLVM_INSTALL_DIR!)
endif

llvm-bindings: $(OUT_DIR)/llvm-core.adb
	rm -rf llvm-bindings
	mv $(OUT_DIR) llvm-bindings

clang-bindings: $(OUT_DIR)/clang-index.adb
	mv $(OUT_DIR)/* clang-bindings

$(OUT_DIR)/llvm-core.adb: check-llvm-install-dir py/common.py py/wrapper.py
	rm -rf $(TMP_GEN_DIR) $(OUT_DIR)
	mkdir -p $(TMP_GEN_DIR) $(OUT_DIR)
	cd $(TMP_GEN_DIR) && g++ -I$(LLVM_INCLUDE_DIR) -DNDEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -U__cplusplus -c -D_Bool=bool -Dlto_api_version=lto_api_version_fun -fdump-ada-spec -C $(LLVM_INCLUDE_DIR_C)/*.h $(LLVM_INCLUDE_DIR_C)/*/*.h
	sed -e "s^$(LLVM_INSTALL_DIR)/^^g" -i $(TMP_GEN_DIR)/llvm_c_*_h.ads
	sed -e 's/\(with Interfaces.C; use Interfaces.C;\)/pragma Warnings (Off); \1 pragma Warnings (On);/g' -i $(TMP_GEN_DIR)/llvm_c_*_h.ads
	echo -n "pragma Style_Checks (Off); package LLVM is end LLVM;" > $(OUT_DIR)/llvm.ads
	./py/common.py process_names_llvm $(TMP_GEN_DIR)/llvm_c_*_h.ads
	cd $(OUT_DIR) && rm x86_64_linux*.ads
	sed -e 's/x86_64_linux_gnu_bits_stdint_u*intn_h/stdint_h/g' -i $(OUT_DIR)/llvm-*.ads
	sed -e 's/x86_64_linux_gnu_sys_types_h/stddef_h/g' -i $(OUT_DIR)/llvm-*.ads
	./py/undupwiths.py $(OUT_DIR)/llvm*.ads
	cp py/stddef_h.ads.proto $(OUT_DIR)/stddef_h.ads
	cp py/stdint_h.ads.proto $(OUT_DIR)/stdint_h.ads
	rm -rf $(TMP_GEN_DIR)
	mv $(OUT_DIR) $(TMP_GEN_DIR)
	mkdir $(OUT_DIR)
	./py/common.py generate_wrappers $(TMP_GEN_DIR)/llvm*.ads
	ls $(TMP_GEN_DIR)/*.ads | grep -v llvm | xargs -i cp {} $(OUT_DIR)/
	rm -rf $(TMP_GEN_DIR)

$(OUT_DIR)/clang-index.adb: check-llvm-install-dir py/common.py py/wrapper.py
	rm -rf $(TMP_GEN_DIR) $(OUT_DIR)
	mkdir -p $(TMP_GEN_DIR) $(OUT_DIR)
	cd $(TMP_GEN_DIR) && g++ -I$(LLVM_INCLUDE_DIR) -DNDEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -U__cplusplus -c -D_Bool=bool -Dlto_api_version=lto_api_version_fun -fdump-ada-spec -C $(CLANG_INCLUDE_DIR_C)/*.h
	sed -e "s^$(LLVM_INSTALL_DIR)/^^g" -i $(TMP_GEN_DIR)/clang_c_*_h.ads
	sed -e 's/\(with Interfaces.C; use Interfaces.C;\)/pragma Warnings (Off); \1 pragma Warnings (On);/g' -i $(TMP_GEN_DIR)/clang_c_*_h.ads
	echo -n "pragma Style_Checks (Off); package Clang is end Clang;" > $(OUT_DIR)/clang.ads
	./py/common.py process_names_clang $(TMP_GEN_DIR)/clang_c_*_h.ads
	cd $(OUT_DIR) && rm x86_64_linux*.ads
	sed -e 's/x86_64_linux_gnu_bits_types_time_t_h/time_h/g' -i $(OUT_DIR)/clang-*.ads
	./py/undupwiths.py $(OUT_DIR)/clang*.ads
	cp py/stddef_h.ads.proto $(OUT_DIR)/stddef_h.ads
	cp py/time_h.ads.proto $(OUT_DIR)/time_h.ads
	rm -rf $(TMP_GEN_DIR)
	mv $(OUT_DIR) $(TMP_GEN_DIR)
	mkdir $(OUT_DIR)
	./py/common.py generate_wrappers $(TMP_GEN_DIR)/clang*.ads
	ls $(TMP_GEN_DIR)/*.ads | grep -v clang | xargs -i cp {} $(OUT_DIR)/
	rm -rf $(TMP_GEN_DIR)

clean:
	rm -rf $(TMP_GEN_DIR) $(OUT_DIR)
