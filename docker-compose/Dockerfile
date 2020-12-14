FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        bash \
        curl \
        jq \
 && curl --silent --location --output /usr/local/bin/pkgctl https://github.com/nicholasdille/packages/raw/master/pkgctl.sh \
 && chmod +x /usr/local/bin/pkgctl \
 && pkgctl cache

FROM tools AS docker-compose-builder
RUN pkgctl install docker-compose@1.27.4

FROM scratch AS kubectl
COPY --from=docker-compose-builder /usr/local/bin/docker-compose /
ENTRYPOINT [ "/docker-compose" ]
