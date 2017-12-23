# Docker images - automated multiplattform build

This repository is for testing automated builds for `amd64` and `armhf`-targeted (Raspberry Pi) Docker images.  

To build `amd64` targeted Docker images, you can simply setup an automated build from GitHub on Docker Hub. Whenever you push a new commit to GitHub, Docker Hub will pull it and build a new Docker image for you.

For `armhf` (Raspberry Pi), there's no such system yet, but according to *hypriot* and *Pradipta Kumar*, there's a workaround using Travis CI.  
Hypriot [claims][1] it is easy as long as there's a QEMU binary for Intel plattforms included in the Docker image (travis is running on Intel only). However, there aren't many trustworthy Docker images _targeted for ARM architecture_, that would include a non-ARM binary for Intel hardware.  
Pradipta Kumar describes [a workaround][2] which involves downloading the missing binary and installing an alternative version of Docker CE, since it is not (yet) possible to inject the missing binary during a `docker build` (which would be the equivalent of `docker run --volume <quemu path>`).

Combining the information from both developers, I created this repository which now builds fine for both plattform and even includes different branches. [Holger Imbery](https://github.com/holgerimbery) inspired me with this [line][3] to let travis name non-master branches accordingly.

tl;dr:  
You currently have two options:  

- Pick a baseimage that already includes the quemu binaries, but make sure that they're from a trustworthy source. I'm personally using holgerimbery's [debian image](https://hub.docker.com/r/holgerimbery/debian) and resin's [python image](https://hub.docker.com/r/resin/raspberrypi3-python). This example is described in the `master` branch.
- Use the method described above to inject the quemu binaries during build process. This is described in the `quemu-inject` branch.

With either options you have additionally the possibility to create a manifest, to let Docker pull a platform specific image automatically, see `manifest` branch for details.

## Try

### armhf (Raspberry Pi)

	docker run dersimn/helloarm:armhf
	docker run dersimn/helloarm:differentbranch-armhf

### amd64

	docker run dersimn/helloarm
	docker run dersimn/helloarm:differentbranch

### Automatic method using manifests

Run on either plattform from the same command:

    docker run dersimn/helloarm:manifest


## Build locally

### amd64

	docker build -t helloarm .

### armhf

	docker build -t helloarm -f Dockerfile.armhf .

When using *Docker for Mac* or *Docker for Windows* this command works by default for cross-plattform builds.


[1]: https://blog.hypriot.com/post/setup-simple-ci-pipeline-for-arm-images/ 
[2]: https://developer.ibm.com/linuxonpower/2017/07/28/travis-multi-architecture-ci-workflow/
[3]: https://github.com/hobbyquaker/hm2mqtt.js/blob/10c5a62013b9beb4341e4239e7e85fea92f54581/.travis.yml#L28
