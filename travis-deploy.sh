#!/bin/bash
set -e

if [[ "$TRAVIS_TAG" ]]; then
  tag="$TRAVIS_TAG"
else
  tag=latest
fi

image="$REPO"
docker push "$image:linux-$ARCH-$tag"


  echo "Downloading docker client with manifest command"
  wget https://6582-88013053-gh.circle-artifacts.com/1/work/build/docker-linux-amd64
  mv docker-linux-amd64 docker
  chmod +x docker
  ./docker version

  set -x

  echo "Pushing manifest $image:$tag"
  ./docker -D manifest create "$image:$tag" \
    "$image:linux-amd64-$tag" \
    "$image:linux-arm32v6-$tag" \
    "$image:linux-arm64v8-$tag"
  ./docker manifest annotate "$image:$tag" "$image:linux-arm32v6-$tag" --os linux --arch arm --variant v6
  ./docker manifest annotate "$image:$tag" "$image:linux-arm64v8-$tag" --os linux --arch arm64 --variant v8
  ./docker manifest push "$image:$tag"
