FROM alpine:3.20

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
    adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

ENV APIFIREWALL_VERSION v0.7.4

RUN set -eux; \
    \
    apk add --no-cache wget; \
    \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        'x86_64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
            sha256='176bbcd6165de7dc03184fe64eb2018e129a130b41fd4f5908a81dd50fcabeb0'; \
            ;; \
        'aarch64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"; \
            sha256='24e67d30b5f32138a6b83dbaee886af2d4084c0b29e197b80378f4414b6079c9'; \
            ;; \
        'x86') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"; \
            sha256='75f92885364801f9af7c64cff91529745bad5d1f88ebe20053ab99311eab91e6'; \
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
