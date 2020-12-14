FROM alpine AS tools
RUN apk add --update-cache --no-cache \
        bash \
        curl \
        jq \
 && curl --silent --location --output /usr/local/bin/pkgctl https://github.com/nicholasdille/packages/raw/master/pkgctl.sh \
 && chmod +x /usr/local/bin/pkgctl \
 && pkgctl cache

FROM tools AS terraform-builder
RUN pkgctl install terraform@0.14.2

FROM scratch AS terraform
COPY --from=terraform-builder /usr/local/bin/terraform /
ENTRYPOINT [ "/terraform" ]
