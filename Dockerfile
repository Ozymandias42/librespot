FROM fedora as build

RUN dnf install -y cargo git pulseaudio-libs-devel gcc make alsa-lib-devel

RUN git clone https://github.com/librespot-org/librespot.git
WORKDIR librespot

RUN cargo build --release --no-default-features --features "alsa-backend" --features "pulseaudio-backend"


FROM fedora
RUN dnf install -y pulseaudio-libs alsa-lib

COPY --from=build  /librespot/target/release/librespot /usr/local/bin/librespot
ENTRYPOINT /usr/local/bin/librespot
CMD ["--name", "librespot", "-b", "320"]
