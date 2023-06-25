# abuild-chromium
Dockerfile to build and install Chromium for Alpine Linux apk from any commit ID.

## Usage
In most cases, you can use the `Dockerfile`. You can specify the following build args:

* ALPINE_VERSION: This refers to the base Docker image version of Alpine Linux that will be used to build and install Chromium.
* COMMIT_ID: Specify the commit id from the [aports](https://gitlab.alpinelinux.org/alpine/aports) repository that you want to build.

For example, to build [chromium 112.0.5615.165](https://gitlab.alpinelinux.org/alpine/aports/-/commit/e197e433add07f6416e0dd6cbd428256b4c5aa76) on alpine:3.17, you would use the following command:

```
docker build --build-arg ALPINE_VERSION=3.17 --build-arg COMMIT_ID=e197e433add07f6416e0dd6cbd428256b4c5aa76 .
```

To build an older commit where the `snapshot()` function is defined in APKBUILD, use the Dockerfile.wsnapshot as follows:

```
docker build -f Dockerfile.wsnapshot .
```

Depending on the commit id, you may need to add a special command during the builder stage to install build dependencies that are deprecated in newer Alpine releases, like this:

```
apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/v3.16/community libgnome-keyring-dev
```

## References
* [Alpine linux install specific (older) package version](https://medium.com/@scythargon/alpine-linux-install-specific-older-package-version-36eadca31fc1)
* [Abuild and Helpers - Alpine Linux](https://wiki.alpinelinux.org/wiki/Abuild_and_Helpers)
