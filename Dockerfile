FROM ubuntu:22.04 as builder

ARG VERSION=0.1.13

RUN apt update \
    && apt install -y --no-install-recommends \
        libatomic1 \
        wget \
        ca-certificates \
        apt-transport-https \
        libsqlite3-dev

RUN cd /tmp/ \
    && wget https://github.com/BitgesellOfficial/bitgesell/releases/download/${VERSION}/bitgesell_${VERSION}_amd64.deb \
    && wget http://ports.ubuntu.com/pool/main/p/perl/perl-modules-5.30_5.30.0-9build1_all.deb \
    && dpkg -i perl-modules-5.30_5.30.0-9build1_all.deb || true \
    && dpkg -i bitgesell_${VERSION}_amd64.deb || true \
    && apt-get install -y -f \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM builder

WORKDIR /root/.BGL

COPY ./bin /usr/local/bin/
COPY ./docker-entrypoint.sh /usr/local/bin/

#VOLUME [ "/root/.BGL" ]

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 8455
CMD ["bgl_oneshot"]
