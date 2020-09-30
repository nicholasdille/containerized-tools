#!/bin/bash

shopt -s expand_aliases

INSTANCE_NAME=$(basename ${PWD})
echo "### Using instance name ${INSTANCE_NAME}."
: "${CONTAINER_NAME:=ansible-${INSTANCE_NAME}}"
export CONTAINER_NAME
echo "### Using cache ${ANSIBLE_CACHE}"
: "${ANSIBLE_CACHE:=${HOME}/.cache/${CONTAINER_NAME}}"
mkdir --parent ${ANSIBLE_CACHE}

: "${ANSIBLE_VERSION:=latest}"
echo "### Starting container named ${CONTAINER_NAME} based on nicholasdille/ansible:${ANSIBLE_VERSION}"
docker run -d \
    --entrypoint bash \
    --name ${CONTAINER_NAME} \
    --mount type=bind,src=${PWD},dst=/src \
    --mount type=bind,src=${ANSIBLE_CACHE},dst=/go \
    nicholasdille/ansible:${ANSIBLE_VERSION} -c 'while true; do sleep 5; done'

echo "### Adding alias for ansible"
function ansible() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible "$@"
}
function ansible-playbook() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-playbook "$@"
}
function ansible-galaxy() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-galaxy "$@"
}
function ansible-console() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-console "$@"
}
function ansible-inventory() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-inventory "$@"
}
function ansible-test() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-test "$@"
}
function ansible-config() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-config "$@"
}
function ansible-doc() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-doc "$@"
}
function ansible-vault() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-vault "$@"
}
function ansible-connection() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-connection "$@"
}
function ansible-pull() {
    docker exec -it --workdir /src ${CONTAINER_NAME} ansible-pull "$@"
}
export -f ansible
export -f ansible-playbook
export -f ansible-galaxy
export -f ansible-console
export -f ansible-inventory
export -f ansible-test
export -f ansible-config
export -f ansible-doc
export -f ansible-vault
export -f ansible-connection
export -f ansible-pull

echo "### End sub-shell to tear down container for ansible"
bash

echo "### Removing aliases"
unset -f ansible
unset -f ansible-playbook
unset -f ansible-galaxy

echo "### Removing container named ${CONTAINER_NAME}"
docker rm -f ${CONTAINER_NAME}

echo "### Unsetting variables"
unset INSTANCE_NAME
unset CONTAINER_NAME
unset ANSIBLE_CACHE
unset ANSIBLE_VERSION
