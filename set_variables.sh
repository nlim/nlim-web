#!/bin/bash

CLIENT_DIR="$(stack path --stack-yaml=stack-client.yaml --dist-dir)/build/client/client.jsexe"
SERVER_DIR="$(stack path --stack-yaml=stack-server.yaml --local-install-root)/bin"
