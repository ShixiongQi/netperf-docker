FROM alpine:latest

# ENV NETPERF_VERSION=2.7.0

RUN apk add \
        --no-cache --virtual build-dependencies \
        build-base linux-headers lksctp-tools-dev git autoconf automake texinfo && \
    apk add \
        --no-cache --virtual runtime-dependencies \
        lksctp-tools && \
    git clone https://github.com/HewlettPackard/netperf.git && \
    cd netperf && \
    ./autogen.sh && \
    ./configure \
        --prefix=/usr \
        --enable-histogram \
        --enable-unixdomain \
        --enable-dccp \
        --enable-omni \
        --enable-exs \
        --enable-sctp \
        --enable-intervals \
        --enable-spin \
        --enable-burst \
        --enable-cpuutil=procstat && \
    make && \
    strip -s src/netperf src/netserver && \
    install -m 755 src/netperf src/netserver /usr/bin && \
    cd ../ && \
    rm -rf netperf && \
    apk del build-dependencies

# CMD ["/usr/bin/netserver", "-D"]