
#需要注意的是，我们在每个target内使用制表符而不是空格是非常重要的。复制和粘贴内容时尤其如此。如果我们添加空格而不是制表符，我们将收到错误消息；


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
	@echo ">>>./postget.sh..." 
	@flutter packages get
	./postget.sh

.PHONY:	clean
clean: ## flutter clean
	@echo ">>>flutter clean..." 
	@flutter clean
 
.PHONY:	pubGet
pubGet: ## flutter pub get
	@echo ">>>./flutter pub get..." 
	@flutter pub get

.PHONY:	run
run: ## flutter run -d fbd70656d622f1abc00f00ea8fe4ab6c46e96127
	@echo ">>>./flutter run..." 
	@flutter run -d fbd70656d622f1abc00f00ea8fe4ab6c46e96127
