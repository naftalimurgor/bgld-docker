# Debugging

## Things to Check

* RAM utilization -- bgld is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The bitgesesl blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary, bitgesell is relatively small with block size 10x smaller than that of bitcoin.

## Viewing bgld Logs

    docker logs bgld

## Running Bash in Docker Container

*Note:* This container will be run in the same way as the bgld node, but will not connect to already running containers or processes.

    docker run -dp 8454:8454 naftalimurgor/bgld

You can also attach bash into running container to debug running bgld

    docker exec -it bgld bash -l
