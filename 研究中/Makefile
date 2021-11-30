
#log

NOCOLOR=\033[0m
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHTGRAY=\033[0;37m

#DARKGRAY=\033[1;30m
#LIGHT_RED=\033[1;31m
#LIGHT_GREEN=\033[1;32m
#YELLOW=\033[1;33m
#LIGHT_BLUE=\033[1;34m
#LIGHT_PURPLE=\033[1;35m
#LIGHT_CYAN=\033[1;36m
WHITE=\033[1;37m

COLORS=RED GREEN YELLOW BLUE PURPLE CYAN LIGHTGRAY WHITE

#define echo_blue
#	@echo "${BLUE} $$(date +"%Y-%m-%d %H:%M:%S %z") $@: $(1)"
#endef

define echo_color
	@echo "$1 $$(date +"%Y-%m-%d %H:%M:%S %z") $@: $2"
endef

define echo_blue
	$(call echo_color, ${BLUE}, $1)
endef

define echo_yellow
	$(call echo_color, ${YELLOW}, $1)
endef

define echo_green
	$(call echo_color, ${GREEN}, $1)
endef

define echo_red
	$(call echo_color, ${RED}, $1)
endef


define test_echo_color
	$(foreach e, $(COLORS), $(call echo_color, ${${e}}, $1\n))
endef


#.PHONY

.PHONY: all
all: postget clean pubGet run

.PHONY:	help
help:	## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
    	done


.PHONY:	postget
postget: ## ./postget.sh
	@echo "\033[34m >>> ./postget.sh..."
	@flutter packages get
	./postget.sh

.PHONY:	clean
clean: ## flutter clean
	@echo "\033[34m >>> flutter clean..."
	@flutter clean
 
.PHONY:	pubGet
pubGet: ## flutter pub get
	@echo "\033[34m >>> ./flutter pub get..."
	@flutter pub get

.PHONY:	run
run: ## flutter run -d fbd70656d622f1abc00f00ea8fe4ab6c46e96127
	@echo "\033[34m >>> ./flutter run..."
	@flutter run -d fbd70656d622f1abc00f00ea8fe4ab6c46e96127



.PHONY:	test
current_dir = ${CURDIR}
username = ${shell whoami}
current_dir2 = ${shell pwd}
hostname = ${shell Hostname}

test:	## test
	@echo "\033[34m >>> test..."
#	@echo "${BLUE} >>> this is a test .PHONY target"
#	@echo "--- ${username}"
#	echo -e "The first five colors of the rainbow are ${RED}red ${YELLOW}orange ${YELLOW}yellow ${GREEN}green ${NOCOLOR}and ${BLUE}blue${NOCOLOR}"
	$(call test_echo_color, __ this is a test log111.)
	$(call echo_color, ${BLUE}, ${username})
	$(call echo_color, ${BLUE}, ${current_dir})
	$(call echo_color, ${BLUE}, ${current_dir2})
	$(call echo_color, ${BLUE}, ${hostname})

	@echo ">>> test finished."

