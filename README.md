# abuild-chromium
Dockerfile to build and install Chromium for Alpine Linux apk from any commit ID.

Note: it takes about 6 to 12 hours to build Chromium on a typical 8-core machine.

## Why build your own apk
As far as I know, the official package repository for Alpine Linux doesn't provide older versions of packages in the same branch. So, if you need an older version of Chromium from a specific branch, you must build the apk yourself. This is why this repository exists. It's here to help you easily build any version of Chromium apk using Docker, especially when the official repository doesn't have the version you need.

## How to build
In most cases, you can use the `Dockerfile`. You can specify the following build args:

* ALPINE_VERSION: This refers to the base Docker image version of Alpine Linux that will be used to build and install Chromium.
* COMMIT_ID: Specify the commit id from the [aports](https://gitlab.alpinelinux.org/alpine/aports) repository that you want to build.

For example, to build [chromium 112.0.5615.165](https://gitlab.alpinelinux.org/alpine/aports/-/commit/e197e433add07f6416e0dd6cbd428256b4c5aa76) on alpine:3.17, you would use the following command:

```
docker build -t abuild-chromium --build-arg ALPINE_VERSION=3.17 --build-arg COMMIT_ID=e197e433add07f6416e0dd6cbd428256b4c5aa76 .
```

To build an older commit where the `snapshot()` function is defined in APKBUILD, use the Dockerfile.wsnapshot as follows:

```
docker build -t abuild-chromium -f Dockerfile.wsnapshot .
```

Depending on the commit id, you may need to add a special command during the builder stage to install build dependencies that are deprecated in newer Alpine releases, like this:

```
apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/v3.16/community libgnome-keyring-dev
```

## Usage example
To run the built Docker image:

```
docker run -d --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
  -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  -e PULSE_SERVER=$PULSE_SERVER \
  --cap-add SYS_ADMIN abuild-chromium chromium --disable-gpu --disable-dev-shm-usage --no-first-run
```

* the SYS_ADMIN capability required to run Chromium.
* Use `--disable-dev-shm-usage` because Docker's /dev/shm is usually too small.

![image](https://github.com/jptomoya/abuild-chromium/assets/4786564/c8d6cb68-7dd1-4481-a04c-b6b26c53e433)

## References
* [Alpine linux install specific (older) package version](https://medium.com/@scythargon/alpine-linux-install-specific-older-package-version-36eadca31fc1)
* [Abuild and Helpers - Alpine Linux](https://wiki.alpinelinux.org/wiki/Abuild_and_Helpers)
