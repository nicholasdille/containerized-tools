FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        bash \
        curl \
        jq \
 && curl --silent --location --output /usr/local/bin/pkgctl https://github.com/nicholasdille/packages/raw/master/pkgctl.sh \
 && chmod +x /usr/local/bin/pkgctl \
 && pkgctl cache

FROM tools AS kubectl-builder
RUN pkgctl install kubectl@1.20.0

FROM scratch AS kubectl
COPY --from=kubectl-builder /usr/local/bin/kubectl /
ENTRYPOINT [ "/kubectl" ]
