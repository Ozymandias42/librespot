FROM alpine:edge
ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"
RUN /bin/ash -c \
	'echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk update && apk add librespot'
ENTRYPOINT ["/usr/bin/librespot"]
CMD ["--name", "librespot", "-b", "320", "--backend", "alsa"]
