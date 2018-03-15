#
# The present Dockerfile builds a debian (wheezy) container
# allowing the error-free compilation of LibBoost 1.44, required for
# the error-free compilation of the MCS Stream ANSI library.
#
# It represents a development environment. 
#
# howto: docker build -t mcs_env .
#        docker run -it --rm mcs_env
#        docker run -it --rm -v "/Users/michi:/opt" mcs_env 
#
# March 14th 2018, Michele Giugliano (mgiugliano@gmail.com)
#

FROM debian:buster-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing \
    && apt-get install -y build-essential \
        && apt-get install -y wget git vim locales \
        && rm -rf /var/lib/apt/lists/*

COPY boost_1_44_0.tar.gz /tmp
COPY MCStreamANSILib.tgz /tmp

RUN cd /tmp \
       && tar -xzf boost_1_44_0.tar.gz \
       && tar -xzf MCStreamANSILib.tgz \
       && rm boost_1_44_0.tar.gz \
       && rm MCStreamANSILib.tgz \
       && cd boost_1_44_0 \
       && ./bootstrap.sh --prefix=/usr/local \
       #&& ./bjam --prefix=/usr/local --without-mpi --without-python threading=multi --layout=tagged install \
       && ./bjam --prefix=/usr/local --with-system threading=multi --layout=tagged --with-filesystem \
       && ./bjam --prefix=/usr/local --with-system threading=multi --layout=tagged --with-system \
       && mv /tmp/boost_1_44_0/stage/lib/* /usr/local/lib \
	   && mv /tmp/boost_1_44_0/boost /usr/local/include \
	   && ldconfig

ENV BOOST_PATH="/usr/local" CSOFLAGS="-Wl,-R,." LSOFLAGS="-shared -Wl,-soname" SOEXT="so"

RUN cd /tmp \
       && cd MC_StreamAnsiLib \
#       && /bin/bash -c "source setlinux" \
       && cd source \
       && make \
       && cp ../lib/* /usr/local/lib/ \
       && cp ../include/* /usr/local/include \
       && cd /tmp \
       && rm -r boost_1_44_0 \
       && rm -r MC_StreamAnsiLib

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
       && locale-gen

# The libraries and includes are in /usr/local/lib and /usr/local/include

VOLUME /opt
WORKDIR /opt
