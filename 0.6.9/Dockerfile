FROM alpine:3.16

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
    adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

ENV APIFIREWALL_VERSION v0.6.9

RUN set -eux; \
    \
    apk add --no-cache wget; \
    \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        'x86_64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
            sha256='12f0b039e84f71298ebc17777910cdd7618e76f65f3356d2e890c3b45f01ef19'; \
            ;; \
        'aarch64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"; \
            sha256='4f31329e9f2391460450e83096b0b17afa08649e17870f8667f1187aacc5ae00'; \
            ;; \
        'x86') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"; \
            sha256='acdce9e1e3d5ecc46be56d3a6b5a70a84de44c53d342a02b8e5f848624ae4b16'; \
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
