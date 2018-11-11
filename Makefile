SHELL := /bin/bash

install:
	./set_js_url.sh
	stack build --stack-yaml stack-server.yaml --install-ghc --copy-bins

all-dev:
	$(MAKE) static/all.min.js
	cp index-dev.html static/index.html
	$(MAKE) bin/server

bin/server:
	mkdir -p bin/
	stack build --stack-yaml stack-server.yaml --install-ghc
	source set_variables.sh && cp $$SERVER_DIR/server bin/

static/all.min.js: static/all.js
	source set_variables.sh && ccjs static/all.js --externs=node --externs=$$CLIENT_DIR/all.js.externs > static/all.min.js

static/all.js:
	stack build --stack-yaml stack-client.yaml  --install-ghc
	source set_variables.sh && cp $$CLIENT_DIR/all.js static/all.js

clean-client:
	rm -f static/*.js

clean-server:
	rm -rf bin/

clean:
	$(MAKE) clean-client
	$(MAKE) clean-server
	rm -rf .stack-work/
