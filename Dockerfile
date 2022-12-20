FROM alpine:edge as build
ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"
#ADD  https://github.com/librespot-org/librespot.git librespot

RUN /bin/ash -c \
  ' apk update \
  && apk add git rustup rust cargo gcc libpulse musl-dev libc-dev build-base make \
  && git clone https://github.com/librespot-org/librespot.git librespot'
WORKDIR /librespot

RUN /bin/ash -c \
'mkdir -p /usr/local/sbin \
&& ln -s /usr/bin/rustc /usr/local/sbin/rustc'

#COPY . /librespot
RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/root/target,id=${TARGETPLATFORM} \
cargo build --release --no-default-features --features "pulseaudio-backend" && \
cargo strip && \
mv /root/target/release/librespot /librespot/librespot


#RUN /bin/ash -c 'apk del rustup cargo gcc libpulse \
#  && cp -v target/release/librespot /usr/local/bin/'

#WORKDIR /

#RUN /bin/ash -c 'rm -rfv librespot'

#RUN /bin/ash -c \ 
#	'echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
#	&& apk update && apk add librespot'

FROM alpine:edge
COPY --from=build /librespot/librespot /usr/local/bin/librespot
RUN apk --no-cache add libpulse
ENTRYPOINT ["/usr/local/bin/librespot"]
CMD ["--name", "librespot", "-b", "320"]
