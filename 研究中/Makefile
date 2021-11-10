#需要注意的是，我们在每个target内使用制表符而不是空格是非常重要的。复制和粘贴内容时尤其如此。如果我们添加空格而不是制表符，我们将收到错误消息；

NOCOLOR=\033[0m
RED=\033[0;31m
GREEN=\033[0;32m
ORANGE=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
LIGHTGRAY=\033[0;37m
DARKGRAY=\033[1;30m
LIGHTRED=\033[1;31m
LIGHTGREEN=\033[1;32m
YELLOW=\033[1;33m
LIGHTBLUE=\033[1;34m
LIGHTPURPLE=\033[1;35m
LIGHTCYAN=\033[1;36m
WHITE=\033[1;37m



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
test:	## test
#	@echo "\033[34m >>> test..."
	echo "${BLUE} >>> this is a test .PHONY target"
#	echo -e "The first five colors of the rainbow are ${RED}red ${ORANGE}orange ${YELLOW}yellow ${GREEN}green ${NOCOLOR}and ${BLUE}blue${NOCOLOR}"

