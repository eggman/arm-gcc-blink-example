
# Makefile for compiling libchip
.SUFFIXES: .o .a .c .s

TOOLCHAIN=gcc

DEV_NUL=/dev/null

PROJECT_BASE_PATH = ../src

CHIP=ameba

RM=rm -f

#-------------------------------------------------------------------------------
# Files
#-------------------------------------------------------------------------------

vpath %.h $(PROJECT_BASE_PATH)/sw/app/helloworld
vpath %.c $(PROJECT_BASE_PATH)/sw/app/helloworld
vpath %.h $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/hal
vpath %.h $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/hal_ext
vpath %.h $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/cmsis/rtl8195a
vpath %.h $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a
vpath %.c $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a
vpath %.c $(PROJECT_BASE_PATH)/sw/os/os_dep
vpath %.h $(PROJECT_BASE_PATH)/sw/os/os_dep/include
vpath %.h $(PROJECT_BASE_PATH)/targets/cmsis
vpath %.h $(PROJECT_BASE_PATH)/targets/cmsis/target_rtk/target_8195a
vpath %.c $(PROJECT_BASE_PATH)/targets/cmsis/target_rtk/target_8195a
vpath %.h $(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a
vpath %.h $(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a/rtl8195a
vpath %.c $(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a/src

VPATH+=$(PROJECT_BASE_PATH)/sw/os/os_dep
VPATH+=$(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a
VPATH+=$(PROJECT_BASE_PATH)/targets/cmsis/target_rtk/target_8195a
VPATH+=$(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a/src

INCLUDES = -I$(PROJECT_BASE_PATH)/include
INCLUDES += -I$(PROJECT_BASE_PATH)/targets/cmsis
INCLUDES += -I$(PROJECT_BASE_PATH)/targets/cmsis/target_rtk/target_8195a
INCLUDES += -I$(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a
INCLUDES += -I$(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a/rtl8195a
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/hal
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/hal_ext
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/cmsis/rtl8195a
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/os
INCLUDES += -I$(PROJECT_BASE_PATH)/sw/os/os_dep/include

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------

include $(TOOLCHAIN).mk

#-------------------------------------------------------------------------------

OUTPUT_PATH=release

#-------------------------------------------------------------------------------
# C source files and objects
#-------------------------------------------------------------------------------
C_SRC=$(wildcard $(PROJECT_BASE_PATH)/sw/app/helloworld/*.c)
C_SRC+=$(wildcard $(PROJECT_BASE_PATH)/targets/hal/target_rtk/target_8195a/src/*.c)
C_SRC+=$(wildcard $(PROJECT_BASE_PATH)/targets/cmsis/target_rtk/target_8195a/*.c)
C_SRC+=$(wildcard $(PROJECT_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a/*.c)
C_SRC+=$(wildcard $(PROJECT_BASE_PATH)/sw/os/os_dep/*.c)


C_OBJ_TEMP=$(patsubst %.c, %.o, $(notdir $(C_SRC)))

# during development, remove some files
C_OBJ_FILTER=

C_OBJ=$(filter-out $(C_OBJ_FILTER), $(C_OBJ_TEMP))

#-------------------------------------------------------------------------------
# Assembler source files and objects
#-------------------------------------------------------------------------------
A_SRC=$(wildcard $(PROJECT_BASE_PATH)/source/*.s)

A_OBJ_TEMP=$(patsubst %.s, %.o, $(notdir $(A_SRC)))

# during development, remove some files
A_OBJ_FILTER=

A_OBJ=$(filter-out $(A_OBJ_FILTER), $(A_OBJ_TEMP))


#-------------------------------------------------------------------------------
# Linkers
#-------------------------------------------------------------------------------

ELF_FLAGS= -O2 -Wl,--gc-sections -mcpu=cortex-m3 -mthumb --specs=nano.specs
ELF_FLAGS+= -L./ -L./scripts -T./scripts/rlx8195a.ld -Wl,-Map=target.map 
ELF_FLAGS+= -Wl,--cref -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common 

ELF_LDLIBS= startup.o lib_platform.a -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------
all: build_info.h helloworld


$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: %.c
	@echo "$(CC) -c $(CFLAGS) $< -o $@"
	@"$(CC)" -c $(CFLAGS) $< -o $@

$(addprefix $(OUTPUT_PATH)/,$(A_OBJ)): $(OUTPUT_PATH)/%.o: %.s
	@"$(AS)" -c $(ASFLAGS) $< -o $@

helloworld: $(addprefix $(OUTPUT_PATH)/, $(C_OBJ)) $(addprefix $(OUTPUT_PATH)/, $(A_OBJ))
	echo build all objects
	$(CC) $(ELF_FLAGS) -o target.axf -Wl,--start-group $^ -Wl,--end-group $(ELF_LDLIBS)
	mv *.i $(OUTPUT_PATH)/
	mv *.s $(OUTPUT_PATH)/
	cd ./makebin && /bin/bash ./makebin.sh


build_info.h:
	@echo -n \#define UTS_VERSION \"\#`cat .version` > .ver
	@if [ -f .name ]; then  echo -n \-`cat .name` >> .ver; fi
	@echo ' '`date +%Y/%m/%d-%T`'"' >> .ver
	@echo \#define RTL8195AFW_COMPILE_TIME \"`date +%Y/%m/%d-%T`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_BY \"`id -u -n`\" >> .ver
	@echo \#define RTL8195AFW_COMPILE_HOST \"`$(HOSTNAME_APP)`\" >> .ver
	@if [ -x /bin/dnsdomainname ]; then \
		echo \#define RTL8195AFW_COMPILE_DOMAIN \"`dnsdomainname`\"; \
	elif [ -x /bin/domainname ]; then \
		echo \#define RTL8195AFW_COMPILE_DOMAIN \"`domainname`\"; \
	else \
		echo \#define RTL8195AFW_COMPILE_DOMAIN ; \
	fi >> .ver
	@mv -f .ver $(PROJECT_BASE_PATH)/sw/os/$@

# dependencies
$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: $(wildcard $(PROJECT_BASE_PATH)/include/*.h) 

.PHONY: clean
clean:
	@echo clean
	-@$(RM) ./target.* 1>$(DEV_NUL) 2>&1
	-@$(RM) ./*.i 1>$(DEV_NUL) 2>&1
	-@$(RM) ./*.s 1>$(DEV_NUL) 2>&1
	-@$(RM) ./makebin/target* 1>$(DEV_NUL) 2>&1
	-@$(RM) ./makebin/*.bin 1>$(DEV_NUL) 2>&1

