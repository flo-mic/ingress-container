FROM alpine:latest

ARG OWASP_VERSION=v3.4/dev

RUN apk update && \
    apk add --no-cache --upgrade \
        curl \
        git \
        openssl && \
    git clone -b ${OWASP_VERSION} --depth 1 --quiet https://github.com/coreruleset/coreruleset && \
    mv coreruleset/crs-setup.conf.example coreruleset/crs-setup.conf

COPY docker_start.sh /docker_start.sh
COPY nginx-modsecurity.conf nginx-modsecurity.conf

ENTRYPOINT [ "/docker_start.sh" ]