#!/bin/sh

# Configure antivirus plugin
if [[ -n "${CLAMAV_ADDRESS}" ]]; then
    if [[ -z "${CLAMAV_PORT}" ]]; then
        CLAMAV_PORT=3310
    fi
    sed -i "s/plugin_clamav_connect_type=socket/plugin_clamav_connect_type=tcp" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_ADDRESS}" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_PORT}" antivirus-plugin/plugins/antivirus-config.conf
    mv antivirus-plugin/plugins/* coreruleset/plugins/
    cp coreruleset/nginx-modsecurity-plugins.conf coreruleset/nginx-modsecurity.conf
fi

# Configure fakebot google plugin
if [[ "${FAKEBOT_PLUGIN_ENNABLED}" = "true" ]]; then
    mv fake-bot-plugin/plugins/* coreruleset/plugins/
    cp coreruleset/nginx-modsecurity-plugins.conf coreruleset/nginx-modsecurity.conf
fi


# Build nginx configuration file
# Add crs-setup file
echo "Include /etc/nginx/owasp-modsecurity-crs/crs-setup.conf" > coreruleset/nginx-modsecurity.conf
# Add plugin conf files if present
if [[ $(ls -1 coreruleset/plugins/*-config.conf | wc -w) > 0  ]]; then
    echo "/etc/nginx/owasp-modsecurity-crs/plugins/*-config.conf" >> coreruleset/nginx-modsecurity.conf
fi
# Add plugin *-before.conf files if present
if [[ $(ls -1 coreruleset/plugins/*-before.conf | wc -w) > 0  ]]; then
    echo "Include modsecurity.d/owasp-modsecurity-crs/plugins/*-before.conf" >> coreruleset/nginx-modsecurity.conf
fi
# Add core rule set rules
echo "Include /etc/nginx/owasp-modsecurity-crs/rules/*.conf" >> coreruleset/nginx-modsecurity.conf
# Add plugin *-before.conf files if present
if [[ $(ls -1 coreruleset/plugins/*-after.conf | wc -w) > 0  ]]; then
    echo "Include modsecurity.d/owasp-modsecurity-crs/plugins/*-after.conf" >> coreruleset/nginx-modsecurity.conf
fi

# Copy files to destination
rm -f coreruleset/nginx-modsecurity-plugins.conf
cp -r coreruleset/* /etc/nginx/owasp-modsecurity-crs/




    