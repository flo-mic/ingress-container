#!/bin/sh

cp -r coreruleset/* /etc/nginx/owasp-modsecurity-crs/
cp modsecurity.conf /etc/nginx/modsecurity/modsecurity.conf
cp nginx.tmpl /etc/nginx/template/nginx.tmpl