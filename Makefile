help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lambda: ## Build lambda package
	npm install .
	@echo "Factory package files..."
	@if [ ! -d build ] ;then mkdir build; fi
	@cp index.js build/index.js
	@cp config.json build/config.json
	@if [ -d build/node_modules ] ;then rm -rf build/node_modules; fi
	@cp -R node_modules build/node_modules
	@cp -R lib build/
	@cp -R bin build/
	@rm -rf build/bin/darwin
	@echo "Create package archive..."
	@cd build && zip -rq aws-lambda-image.zip .
	@mv build/aws-lambda-image.zip ./

uploadlambda: lambda ## Upload lambda to aws (set LAMBDA_FUNCTION_NAME)
	@if [ -z "${LAMBDA_FUNCTION_NAME}" ]; then (echo "Please export LAMBDA_FUNCTION_NAME" && exit 1); fi
	aws-vault exec shrinkray -- aws lambda update-function-code --function-name ${LAMBDA_FUNCTION_NAME} --zip-file fileb://aws-lambda-image.zip

configtest: ## Run configtest
	@./bin/configtest

clean: ## Clean up lambda package
	@echo "clean up package files"
	@if [ -f aws-lambda-image.zip ]; then rm aws-lambda-image.zip; fi
	@rm -rf build/*

.PHONY: help lambda uploadlambda configtest clean
.DEFAULT_GOAL := help
