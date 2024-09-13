#!/bin/bash

DOCKERFILE="Dockerfile"
IMAGE_NAME="patrickarmengol/dorudon"
CONTAINER_NAME_PREFIX="dorduon"

build_image() {
    echo "building the Docker image..."
    docker build -t $IMAGE_NAME -f $DOCKERFILE .
}

spawn_container() {
    UNIQUE_NAME="${CONTAINER_NAME_PREFIX}_$(date +%s)"
    echo "spawning a new container with the name: $UNIQUE_NAME"
    docker run -dit -h $UNIQUE_NAME --name "$UNIQUE_NAME" $IMAGE_NAME
}

attach_container() {
    if [ -z "$1" ]; then
        echo "please specify a container name or id to attach"
        exit 1
    fi
    echo "attaching to container $1..."
    docker attach "$1"
}

remove_container() {
    if [ -z "$1" ]; then
        echo "please specify a container name or id to remove"
        exit 1
    fi
    echo "removing container $1..."
    docker rm -f "$1"
}

list_containers() {
    echo "listing all containers..."
    docker ps -a --filter "name=${CONTAINER_NAME_PREFIX}"
}

case "$1" in
    build)
        build_image
        ;;
    spawn)
        spawn_container
        ;;
    attach)
        attach_container "$2"
        ;;
    rm)
        remove_container "$2"
        ;;
    ls)
        list_containers
        ;;
    *)
        echo "usage: $0 {build|spawn|attach|rm|ls}"
        exit 1
        ;;
esac
