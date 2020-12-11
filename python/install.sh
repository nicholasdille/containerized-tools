#!/bin/bash

shopt -s expand_aliases

INSTANCE_NAME=$(basename ${PWD})
echo "### Using instance name ${INSTANCE_NAME}."
: "${CONTAINER_NAME:=python-${INSTANCE_NAME}}"
export CONTAINER_NAME

echo "### Using cache ${PYTHON_CACHE}"
: "${PYTHON_CACHE:=${HOME}/.cache/${CONTAINER_NAME}}"
mkdir --parent ${PYTHON_CACHE}

: "${PYTHON_VERSION:=latest}"
echo "### Starting container named ${CONTAINER_NAME} for python development based on python:${PYTHON_VERSION}"
docker run -d \
    --name ${CONTAINER_NAME} \
    --mount type=bind,src=${PWD},dst=/src \
    --mount type=bind,src=${PYTHON_CACHE},dst=/venv/ \
    python:${PYTHON_VERSION} bash -c 'sleep infinity'

echo "### Adding alias for python"
function python() {
    docker exec -it --workdir /src ${CONTAINER_NAME} python "$@"
}
function pip() {
    docker exec -it --workdir /src ${CONTAINER_NAME} pip "$@"
}
export -f python
export -f pip

echo "### End sub-shell to tear down container for golang"
bash

echo "### Removing aliases"
unset -f python

echo "### Removing container named ${CONTAINER_NAME}"
docker rm -f ${CONTAINER_NAME}

echo "### Unsetting variables"
unset INSTANCE_NAME
unset CONTAINER_NAME
unset PYTHON_CACHE
unset PYTHON_VERSION
