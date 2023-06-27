ARG ALPINE_VERSION=edge
FROM alpine:${ALPINE_VERSION} AS builder
ARG COMMIT_ID=HEAD

RUN apk update \
  && apk add --no-cache alpine-sdk sudo \
  && adduser -D packager \
  && addgroup packager abuild \
  && addgroup packager wheel \
  && sed -i 's/^# \%wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

USER packager
WORKDIR /home/packager/aports
RUN git init \
  && git remote add origin https://gitlab.alpinelinux.org/alpine/aports.git \
  && git fetch --depth 1 origin ${COMMIT_ID} \
  && git reset --hard FETCH_HEAD
WORKDIR /home/packager/aports/community/chromium/
RUN abuild-keygen -a -i -n \
  && abuild -r \
  && rm -rf /var/cache/distfiles/*

FROM alpine:${ALPINE_VERSION}
COPY --from=builder --chown=root:root /home/packager/.abuild/*.pub /etc/apk/keys
COPY --from=builder --chown=root:root /home/packager/packages /root/packages
RUN CHROMIUM_APK=$(find /root/packages/community/x86_64/ -name 'chromium-*.apk' -type f | sort -n | head -n 1) \
  && apk add --no-cache "${CHROMIUM_APK}" font-noto-cjk \
  && rm -rf /root/packages \
  && adduser -D user
USER user
