# Automated build of Docker Images on GitHub Push

To auto-build `amd64`-targeted Docker Images, you can simply setup an automated build from GitHub on Docker Hub. Whenever you push a new commit to GitHub, Docker Hub will pull it and build a new Docker image for you. For `arm` (Raspberry Pi), there's no such system yet, but according to *hypriot* and *Pradipta Kumar*, there's a workaround using Travis CI.  

**Every GitHub branch is one possible solution to create a multi-architecture Docker Image.**

## [`github-workflow`](https://github.com/dersimn/HelloARM/tree/github-workflow) (recommended)

|              |         amd64        |         arm*         |
|--------------|:--------------------:|:--------------------:|
| Docker Hub   |                      |                      |
| Travis       |                      |                      |
| Local build  |  :heavy_check_mark:  |  :heavy_check_mark:  |
| GitHub build |  :heavy_check_mark:  |  :heavy_check_mark:  |

You can use GitHub Workflows to trigger the exact same `buildx`-build on every pushed commit and even let GitHub tag your Docker Images for you using [semver tags](https://github.com/crazy-max/ghaction-docker-meta#handle-semver-tag).

With this method one can run

    docker run dersimn/helloarm
    docker run dersimn/helloarm:1
    docker run dersimn/helloarm:1.2
    docker run dersimn/helloarm:1.2.3
    docker run dersimn/helloarm:latest
    docker run dersimn/helloarm:<branch name>

on any platform, Docker will then pull the right image for you.

## [`native`](https://github.com/dersimn/HelloARM/tree/native)

| :warning: For now you have to build the image locally, imho this is still the best method. |
| --- |

|             |         amd64        |         arm*         |
|-------------|:--------------------:|:--------------------:|
| Docker Hub  |                      |                      |
| Travis      | (:heavy_check_mark:) | (:heavy_check_mark:) |
| Local build |  :heavy_check_mark:  |  :heavy_check_mark:  |

Use Docker's freshly introduced `buildx` command. Instructions [here](https://docs.docker.com/docker-for-mac/multi-arch/).  
Make sure, that the baseimage specified in the Dockerfile (`FROM ...`) is compatible to the desired architectures. You can check this on Docker Hub, for e.g. this is the list of supported platforms for the [Debian image](https://github.com/dersimn/HelloARM/raw/master/docker-hub-platforms.png).

With this method one can simply run

    docker run dersimn/helloarm:native

on any platform, Docker will then pull the right image for you.

## [`manifest`](https://github.com/dersimn/HelloARM/tree/manifest)

|             |        amd64       |                                          arm*                                          |
|-------------|:------------------:|:--------------------------------------------------------------------------------------:|
| Docker Hub  |                    |                                                                                        |
| Travis      | :heavy_check_mark: | :heavy_check_mark: ![](https://api.travis-ci.org/dersimn/HelloARM.svg?branch=manifest) |
| Local build |                    |                                                                                        |

Combine either `simple` or `qemu-inject` with a manifest file, so that you don't have to specifically pull a Docker Image that suits your platform.

Without a manifest file you have to run 

    docker run dersimn/helloarm

and 

    docker run dersimn/helloarm:armhf

respectively for a machine based on `amd64` or `arm` (Raspberry Pi). With a manifest file, one simply run

    docker run dersimn/helloarm:manifest

on both platforms, Docker will then pull the right image for your platform.

## [`simple`](https://github.com/dersimn/HelloARM/tree/simple)

Based on [Hypriot's work][1].

|             |        amd64       |                                         arm*                                         |
|-------------|:------------------:|:------------------------------------------------------------------------------------:|
| Docker Hub  | :heavy_check_mark: |                                                                                      |
| Travis      |                    | :heavy_check_mark: ![](https://api.travis-ci.org/dersimn/HelloARM.svg?branch=simple) |
| Local build |                    |                                                                                      |

Configure Docker Hub to auto-build a amd64 image, configure Travis to build the arm image.  
In this case the baseimage must include the qemu binaries for running arm executeables on a amd64 platform. However, there aren't many trustworthy Docker Images targeted for arm architecture, that would include a non-arm binary just for the build process - at least official images don't include the binaries. Wether you want to use unofficial Docker Images as base for your builds, is up to you.

## [`qemu-inject`](https://github.com/dersimn/HelloARM/tree/qemu-inject) (obsolete)

|             |        amd64       |                                            arm*                                           |
|-------------|:------------------:|:-----------------------------------------------------------------------------------------:|
| Docker Hub  | :heavy_check_mark: |                                                                                           |
| Travis      |                    | :heavy_check_mark: ![](https://api.travis-ci.org/dersimn/HelloARM.svg?branch=qemu-inject) |
| Local build |                    |                                                                                           |

Pradipta Kumar describes [a workaround][2] for the disadvantage of the `simple` approach. With this you can use an official baseimage and inject the qemu binaries just for the build process. However, this process involves installing an alternative version of Docker for the Travis build.


# Credits

[Hypriot][1].  
[Pradipta Kumar][2].  
[Holger Imbery](https://github.com/holgerimbery) inspired me with this [line][3] to let travis name non-master branches accordingly.

[1]: https://blog.hypriot.com/post/setup-simple-ci-pipeline-for-arm-images/ 
[2]: https://developer.ibm.com/linuxonpower/2017/07/28/travis-multi-architecture-ci-workflow/
[3]: https://github.com/hobbyquaker/hm2mqtt.js/blob/10c5a62013b9beb4341e4239e7e85fea92f54581/.travis.yml#L28
