# Alpine Linux based librespot container

This container uses the awesome [librespot](https://github.com/librespot-org/librespot) library to transform any docker host into a spotify connect device.
The Dockerfile for this container is hosted on GitHub [Ozymandias42/librespot-container](https://github.com/ozymandias42/librespot-container)

This container runs on all architectures on which the librespot package is available in the alpinelinux testing repository.
At the time of this writing these are:

|Architecture | Devices|
|-------------|--------|
|x86\_64||
|aarch64	  |armv8 architectures and later. I.e. Raspberry Pi >3b|

## How to run
### Via `docker run`
```bash
#Note: use --net host to make sure broadcasting works without having to mess with macvlan networks.
docker run \
	--name librespot \
	--net host \
	--device /dev/snd \
	4f7a796d616e6469617334320a/librespot \
		/usr/bin/librespot \
			--name <NAME-OF-YOUR-SPOTIFY-CONNECT-DEVICE> \
			--bitrate <160,254,320> \
			--backend alsa \
			<--device YOUR-SND-DEVICE>
```
### Via Compose File
```yaml
Version 3.7

services:
  librespot:
    image: 4f7a796d616e6469617334320a/librespot 
    devices:
      - "/dev/snd:/dev/snd"
    network_mode: "host"
    entrypoint: ["/usr/bin/librespot"]
    command: [ "--name", "<YOUR-SPOTIFY-CONNECT>", "-b", "320", "--backend", "alsa", "--device", "default:CARD=Device"]
```

