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
    # Start cleanup
    apk del --purge build-dependencies && \
    rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/* \
        /var/cache/apk/*

COPY docker_start.sh /docker_start.sh
COPY nginx-modsecurity.conf coreruleset/nginx-modsecurity.conf
COPY modsecurity.conf modsecurity.conf
COPY nginx.tmpl nginx.tmpl

ENTRYPOINT [ "/docker_start.sh" ]