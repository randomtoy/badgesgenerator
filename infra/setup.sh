#!/bin/bash
set -exu

VERSION_FILE="./VERSION.txt"

DEVENV=${1:-unknown}


increment_version() {
    local version=$1
    local IFS='.'
    read -r MAJOR MINOR PATCH <<< "$version"
    if [[ "$DEVENV" == "dev" ]]; then
        PATCH=$((PATCH + 1))
    elif [[ "$DEVENV" == "main" ]]; then
        PATCH=0
        MINOR=$((MINOR + 1))
    elif [[ "$DEVENV" == "release" ]]; then
        PATCH=0
        MINOR=0
        MAJOR=$((MAJOR + 1))
    fi

    echo "$MAJOR.$MINOR.$PATCH"
}

build_and_push() {
    local version=$1

    docker build \
    -t $DOCKERHUB_USERNAME/$IMAGE_NAME:$version \
    -t $DOCKERHUB_USERNAME/$IMAGE_NAME:$DEVENV \
    -f ./Dockerfile .

    docker push $DOCKERHUB_USERNAME/$IMAGE_NAME -a

}

current_version=$(cat $VERSION_FILE)
new_version=$(increment_version $current_version)
echo "$new_version" > $VERSION_FILE
build_and_push $new_version

