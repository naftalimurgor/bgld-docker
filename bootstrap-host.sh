#!/bin/bash
#
# Configure broken host machine to run correctly
#
set -ex

BGL_IMAGE=${BGL_IMAGE:-naftalimurgor/bgld}

distro=$1
shift

free -m

# Always clean-up, but fail successfully
docker kill bgld-node 2>/dev/null || true
docker rm bgld-node 2>/dev/null || true
stop docker-bgld 2>/dev/null || true

# Always pull remote images to avoid caching issues
if [ -z "${BGL_IMAGE##*/*}" ]; then
    docker pull $BGL_IMAGE
fi

# Initialize the data container
docker volume create --name=bgld-data
docker run -v bgld-data:/BGL --rm $BGL_IMAGE bgl_init

# Start bgld via upstart and docker
curl https://raw.githubusercontent.com/naftalimurgor/docker-bgld/master/upstart.init > /etc/init/docker-BGL.conf
start docker-bgld

set +ex
echo "Resulting bgl.conf:"
docker run -v bgld-data:/BGL --rm $BTC_IMAGE cat /BGL/.BGL/BGL.conf
