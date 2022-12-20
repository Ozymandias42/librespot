FROM library/rust as build

ARG TARGETPLATFORM

ADD https://github.com/librespot-org/librespot.git /root/librespot
WORKDIR librespot
COPY . .

RUN apt update && apt install -y build-essential apt-utils libasound2-dev libpulse-dev
#RUN dnf install -y cargo git pulseaudio-libs-devel gcc make alsa-lib-devel

RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} \
    cargo install cargo-strip


RUN --mount=type=cache,target=/usr/local/cargo/registry,id=${TARGETPLATFORM} --mount=type=cache,target=/root/target,id=${TARGETPLATFORM} \
    cargo build --release --no-default-features --features "pulseaudio-backend" && \
    cargo strip

#RUN cargo build --release --no-default-features --features "alsa-backend" --features "pulseaudio-backend"

#RUN mkdir -p /usr/local/sbin && ln -s $(which rustc) /usr/local/sbin/rustc

FROM debian
RUN apt update && apt install -y libpulse0

COPY --from=build  /root/librespot/target/release/librespot /usr/local/bin/librespot
ENTRYPOINT /usr/local/bin/librespot
CMD ["--name", "librespot", "-b", "320"]
