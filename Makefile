help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy: ## Deploy lambda
	aws-vault exec shrinkray -- npm run deploy

update: ## Update lambda
	aws-vault exec shrinkray -- npm run update

configtest: ## Run configtest
	@./bin/configtest

.PHONY: help deploy configtest
.DEFAULT_GOAL := help
