FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        bash \
        curl \
        jq \
 && curl --silent --location --output /usr/local/bin/pkgctl https://github.com/nicholasdille/packages/raw/master/pkgctl.sh \
 && chmod +x /usr/local/bin/pkgctl \
 && pkgctl cache

FROM tools AS helm-builder
RUN pkgctl install helm@3.4.1

FROM scratch AS helm
COPY --from=helm-builder /usr/local/bin/helm /
ENTRYPOINT [ "/helm" ]
