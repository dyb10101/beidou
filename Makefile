MAKEFLAGS = -j1

export NODE_ENV = test
export FORCE_COLOR = true

.PHONY: eslint-lint prettier-lint lint reinstall-examples-dependencies clean-packages clean-examples clean clean-test test ci changelog

lint:
	make prettier-lint && make eslint-lint

prettier-lint:
	prettier --write "packages/**/*.{js,jsx,json,css,scss,md}"

eslint-lint:
	eslint --fix --ext .jsx,.js packages/

reinstall-examples-dependencies:
	make clean-examples
	rm -rf examples/*/yarn.lock
	./scripts/reinstall-examples.sh

clean-packages:
	rm -rf packages/*/node_modules
	make clean-test
	rm -rf packages/*/coverage
	rm -rf packages/*/*.log

clean-examples:
	rm -rf examples/*/node_modules
	rm -rf examples/*/logs
	rm -rf examples/*/run
	rm -rf examples/*/*.log
	rm -rf examples/*/.stats.json
	rm -rf examples/*/.isomorphic

clean:
	make clean-packages && make clean-examples

clean-test:
	rm -rf packages/*/test/**/run
	rm -rf packages/*/test/**/logs
	rm -rf packages/*/test/**/.stats.json
	rm -rf packages/*/test/**/.isomorphic

test:
	make lint
	./scripts/test.sh
	make clean-test

ci:
	./scripts/ci.sh

changelog:
	lerna-changelog
