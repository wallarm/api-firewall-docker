FROM alpine:3.21

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
    adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

ENV APIFIREWALL_VERSION v0.8.5

RUN set -eux; \
    \
    apk add --no-cache wget; \
    \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        'x86_64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
            sha256='fb78d1ec8487d8bdda99f48be1da32d1ca57f47a57d51a14f881f2a1f17e777f'; \
            ;; \
        'aarch64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"; \
            sha256='e0334cc6df7e2c9a281c43bd039525e2479fddf835029dc981b18f404586f370'; \
            ;; \
        'x86') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"; \
            sha256='76528b49cf9530aa45f294115d2dff86c6722a68fc2e3beb3ec173095eed6b9a'; \
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
