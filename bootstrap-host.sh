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
docker kill bgld 2>/dev/null || true
docker rm bgld 2>/dev/null || true

# Always pull remote images to avoid caching issues
if [ -z "${BGL_IMAGE##*/*}" ]; then
    docker pull $BGL_IMAGE
fi

# Initialize the data container
docker volume create --name=bgld-data
docker run -v bgld-data:/BGL --rm $BGL_IMAGE bgl_init

# Start bgld via upstart and docker
curl https://raw.githubusercontent.com/naftalimurgor/bgld-docker/master/upstart.init > /etc/init/docker-BGL.conf
start bgld

set +ex
echo "Resulting bgl.conf:"

