#!/bin/bash

shopt -s expand_aliases

INSTANCE_NAME=$(basename ${PWD})
echo "### Using instance name ${INSTANCE_NAME}."
: "${CONTAINER_NAME:=golang-${INSTANCE_NAME}}"
export CONTAINER_NAME
echo "### Using cache ${GO_CACHE}"
: "${GO_CACHE:=${HOME}/.cache/${CONTAINER_NAME}}"
mkdir --parent ${GO_CACHE}

: "${GO_VERSION:=latest}"
echo "### Starting container named ${CONTAINER_NAME} for go development based on golang:${GO_VERSION}"
docker run -d \
    --name ${CONTAINER_NAME} \
    --mount type=bind,src=${PWD},dst=/src \
    --mount type=bind,src=${GO_CACHE},dst=/go \
    golang:${GO_VERSION} bash -c 'sleep infinity'

echo "### Adding alias for go"
function go() {
    docker exec -it --workdir /src ${CONTAINER_NAME} go "$@"
}
function gofmt() {
    docker exec -it --workdir /src ${CONTAINER_NAME} gofmt "$@"
}
export -f go
export -f gofmt

echo "### Installing tools"
go get -u golang.org/x/lint/golint
go get github.com/KyleBanks/depth/cmd/depth

echo "### Installing aliases for tools"
function golint() {
    docker exec -it --workdir /src ${CONTAINER_NAME} golint "$@"
}
function depth() {
    docker exec -it --workdir /src ${CONTAINER_NAME} depth "$@"
}
export -f golint
export -f depth

echo "### End sub-shell to tear down container for golang"
bash

echo "### Removing aliases"
unset -f depth
unset -f golint
unset -f gofmt
unset -f go

echo "### Removing container named ${CONTAINER_NAME}"
docker rm -f ${CONTAINER_NAME}

echo "### Unsetting variables"
unset INSTANCE_NAME
unset CONTAINER_NAME
unset GO_CACHE
unset GO_VERSION
