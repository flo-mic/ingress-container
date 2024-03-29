FROM alpine:latest

ARG OWASP_VERSION=v3.4/dev

RUN apk update && \
    apk add --no-cache --virtual=build-dependencies \
        curl \
        git \
        openssl && \
    # Get required files
    git clone -b ${OWASP_VERSION} --depth 1 --quiet https://github.com/coreruleset/coreruleset && \
    mv coreruleset/crs-setup.conf.example coreruleset/crs-setup.conf && \
    git clone https://github.com/coreruleset/antivirus-plugin && \
    git clone https://github.com/coreruleset/fake-bot-plugin && \
    git clone https://github.com/coreruleset/incubator-plugin && \
    git clone https://github.com/coreruleset/body-decompress-plugin && \
    git clone https://github.com/coreruleset/auto-decoding-plugin && \
    git clone https://github.com/coreruleset/nextcloud-rule-exclusions-plugin && \
    git clone https://github.com/flo-mic/pgadmin-rule-exclusions-plugin && \
    # Start cleanup
    apk del --purge build-dependencies && \
    rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/* \
        /var/cache/apk/*

COPY docker_start.sh /docker_start.sh
COPY nginx.tmpl nginx.tmpl
COPY modsecurity.conf modsecurity.conf

ENTRYPOINT [ "/docker_start.sh" ]