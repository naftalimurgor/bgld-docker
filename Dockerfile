FROM ubuntu:20.04 as builder

ARG VERSION=0.1.13

RUN apt update \
    && apt install -y --no-install-recommends \
    libatomic1 \
    wget \
    ca-certificates \ 
    apt-transport-https 

RUN cd /tmp/ \
    && wget https://github.com/BitgesellOfficial/bitgesell/releases/download/${VERSION}/bitgesell_${VERSION}_amd64.deb \
    && wget http://ports.ubuntu.com/pool/main/p/perl/perl-modules-5.34_5.34.0-3ubuntu1.3_all.deb \
    && apt-get install libsqlite3-dev -y \
    && dpkg -i perl-modules-5.34_5.34.0-3ubuntu1.3_all.deb \
    && dpkg -i bitgesell_${VERSION}_amd64.deb \
    && apt-get install -y -f \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM builder

ENTRYPOINT ["docker-entrypoint.sh"]  
VOLUME [ "/root/.BGL" ]
WORKDIR /root/.BGL

COPY ./bin ./docker-entrypoint.sh /usr/local/bin/


EXPOSE 8455

CMD ["bgl_oneshot"]
