FROM alpine:3.15

ENV APIFIREWALL_VERSION v0.6.7

ENV APIFW_PATH /opt/api-firewall
ENV PATH $APIFW_PATH:$PATH

RUN set -eux; \
	adduser -u 1000 -H -h /opt -D -s /bin/sh api-firewall

RUN set -eux; \	
    arch="$(apk --print-arch)"; \
    case "$arch" in \
		'x86_64') \
			url="https://github.com/wallarm/api-firewall/releases/download/${APIFIREWALL_VERSION}/api-firewall-amd64-musl.tar.gz"; \
			sha256='fb61a3ca620340a76f97856ec30190de8422535c31d17ddc89019e87825d60b9'; \
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
# smoke test
	api-firewall -v

COPY docker-entrypoint.sh $APIFW_PATH/

RUN chmod 755 $APIFW_PATH/api-firewall; \
    chmod 755 $APIFW_PATH/docker-entrypoint.sh

USER api-firewall
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["api-firewall"]
