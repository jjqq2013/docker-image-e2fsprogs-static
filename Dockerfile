FROM ubuntu:bionic as builder

RUN apt-get update && apt-get -y install build-essential gcc g++ gdb make \
    automake autopoint libtool pkg-config bison gettext wget curl

WORKDIR /src
RUN wget 'https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/e2fsprogs/1.44.1-1ubuntu1.3/e2fsprogs_1.44.1.orig.tar.gz' -O - \
 | tar -xz --strip 1

RUN ./configure
RUN make LDFLAGS=-static CFLAGS="-DNDEBUG -v" install DESTDIR=/out/

# bash is installed in /usr/local/bin, so I have to link it to bin/
RUN cd /out && mkdir -p bin/ && ln -s ../usr/local/bin/bash bin/

###############################################################################

FROM bash

COPY --from=builder /out /

ENTRYPOINT []
CMD ["/bin/bash"]
