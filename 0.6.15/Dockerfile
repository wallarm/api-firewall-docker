FROM alpine:3.18

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
    adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

ENV APIFIREWALL_VERSION v0.6.15

RUN set -eux; \
    \
    apk add --no-cache wget; \
    \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
        'x86_64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
            sha256='bcd672cef9c3de2f87c995fe948efd0310fb66fd441f98a0e1f685ff215d6daf'; \
            ;; \
        'aarch64') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-arm64-musl.tar.gz"; \
            sha256='f69c9b63c89db1e140a9e268f75dd2bace1dadff4550363408be6f4e0f00365b'; \
            ;; \
        'x86') \
            url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-386-musl.tar.gz"; \
            sha256='96ac79d6a6e6df6c357391d5e611f2204e48b951a443152ede6a19753c959c27'; \
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
