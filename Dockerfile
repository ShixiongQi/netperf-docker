FROM alpine:latest

RUN printf "\n%s\n%s" "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add \
        --no-cache --virtual build-dependencies \
        autoconf automake@edge make gcc g++ libtool pkgconfig libmcrypt-dev re2c zlib-dev xdg-utils libpng-dev freetype-dev libjpeg-turbo-dev openssh-client libxslt-dev ca-certificates gmp-dev texinfo && \
    apk add \
        --no-cache --virtual build-dependencies \
        build-base linux-headers lksctp-tools-dev git && \
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
	rm -rf netperf-${NETPERF_VERSION}* && \
	apk del build-dependencies

# CMD ["/usr/bin/netserver", "-D"]