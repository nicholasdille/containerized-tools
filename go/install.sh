#!/bin/bash

: "${GO_VERSION:=latest}"

echo "### Starting container for go development based on golang:${GO_VERSION}"
docker run -d --name golang --mount type=bind,src=${PWD},dst=/src golang:${GO_VERSION}

alias go="docker exec -it --workdir /src golang go"
