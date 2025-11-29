FROM alpine:3.22

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
    adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

ENV APIFIREWALL_VERSION v0.9.4

RUN set -eux; \
    \
    apk add --no-cache wget; \
    \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        'x86_64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
            sha256='89c7d5ebcb35733c90b1adee529f7116adf7880311706029d2470af792176e0c'; \
            ;; \
        'aarch64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"; \
            sha256='f8590efca3d526ea3b0a85b245bbdbb647bebcb01fcbc5bafeff03b81a479a70'; \
            ;; \
        'x86') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"; \
            sha256='90ac4e0c2b864e24e87b85f9012ff9c67ed5ae807828bc61ec4d5c6c30e6fabc'; \
            ;; \
        *) \
            echo >&2 "error: current architecture ($arch) does not have a corresponding API-Firewall binary release"; \
            exit 1; \
            ;; \
    esac; \
    \
    wget -O api-firewall.tar.gz "$url"; \
    echo "$sha256 *api-firewall.tar.gz" | sha256sum -c; \
    \
    mkdir -p "$APIFW_PATH"; \
    tar -xzf api-firewall.tar.gz -C "$APIFW_PATH" --strip-components 1; \
    rm api-firewall.tar.gz; \
    \
    chmod 755 $APIFW_PATH/api-firewall; \
    \
# smoke test
    api-firewall -v

COPY docker-entrypoint.sh $APIFW_PATH/

USER api-firewall
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["api-firewall"]
