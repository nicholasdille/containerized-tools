FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        bash \
        curl \
        jq \
 && curl --silent --location --output /usr/local/bin/pkgctl https://github.com/nicholasdille/packages/raw/master/pkgctl.sh \
 && chmod +x /usr/local/bin/pkgctl \
 && pkgctl cache

FROM tools AS docker-machine-builder
RUN pkgctl install docker-machine@0.16.2

FROM scratch AS kubectl
COPY --from=docker-machine-builder /usr/local/bin/docker-machine /
ENTRYPOINT [ "/docker-machine" ]
