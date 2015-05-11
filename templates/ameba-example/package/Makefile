

#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------

all: clean ameba 


.PHONY: clean
clean:
	@echo --- Cleaning ameba release and debug
	@$(MAKE) -f ameba.mk $@
	rm -fr release


ameba:
	@echo --- Create directory 
	mkdir release
	@$(MAKE) -f ameba.mk

