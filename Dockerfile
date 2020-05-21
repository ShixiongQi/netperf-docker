FROM ubuntu:14.04

# Satisfy deps
RUN apt-get update && \
    apt-get install -y gcc make && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup   

RUN apt-get install -y autotools-dev autoconf automake texinfo

# Download netperf
RUN git clone https://github.com/HewlettPackard/netperf.git
RUN cd netperf && \
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
    make install

# CMD ["/usr/local/bin/netserver", "-D"]