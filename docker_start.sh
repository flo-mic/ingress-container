#!/bin/sh

# Configure antivirus plugin
if [[ -z "${CLAMAV_ADDRESS}"]]; then
    if [[ -z "${CLAMAV_PORT}" ]]; then
        CLAMAV_PORT=3310
    fi
    sed -i "s/plugin_clamav_connect_type=socket/plugin_clamav_connect_type=tcp" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_ADDRESS}" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_PORT}" antivirus-plugin/plugins/antivirus-config.conf
    mv antivirus-plugin/plugins/* /coreruleset/plugins/
fi

# Configure fakebot google plugin
if [[ ${FAKEBOT_PLUGIN_ENNABLED} = "true"]]; then
    mv fake-bot-plugin/plugins/* /coreruleset/plugins/
fi

cp -r coreruleset/* /etc/nginx/owasp-modsecurity-crs/
#cp modsecurity.conf /etc/nginx/modsecurity/modsecurity.conf




    