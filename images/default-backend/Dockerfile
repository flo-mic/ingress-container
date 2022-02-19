
FROM tarampampam/error-pages:2.6.0 as template
COPY error-pages.yml /opt/error-pages.yml
COPY templates/ /opt/templates/


FROM alpine:latest as build
COPY --from=template / /
WORKDIR /opt
RUN /bin/error-pages --config-file error-pages.yml build html --verbose --index


FROM nginx:latest
WORKDIR /etc/nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /opt/html/l7-dark/* /usr/share/nginx/html/
COPY --from=build /opt/html/l7-dark/404.html /usr/share/nginx/html/index.html