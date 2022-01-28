#!/bin/sh

# Configure antivirus plugin
if [[ -n "${CLAMAV_ADDRESS}" ]]; then
    if [[ -z "${CLAMAV_PORT}" ]]; then
        CLAMAV_PORT=3310
    fi
    sed -i "s/plugin_clamav_connect_type=socket/plugin_clamav_connect_type=tcp/g" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_ADDRESS}/g" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=127.0.0.1/plugin_clamav_address=${CLAMAV_PORT}/g" antivirus-plugin/plugins/antivirus-config.conf
    mv antivirus-plugin/plugins/* coreruleset/plugins/
fi

# Configure fakebot google plugin
if [[ "${FAKEBOT_PLUGIN_ENNABLED}" = "true" ]]; then
    mv fake-bot-plugin/plugins/* coreruleset/plugins/
fi

# Copy files to destination
cp -r coreruleset/* /etc/nginx/owasp-modsecurity-crs/

# Build nginx configuration file
# Add crs-setup file
echo "Include /etc/nginx/owasp-modsecurity-crs/crs-setup.conf" > /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
# Add plugin conf files if present
for line in $(find /etc/nginx/owasp-modsecurity-crs/plugins -name '*-config.conf' | sort); do 
     echo "Include $line" >> /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
done
# Add plugin *-before.conf files if present
for line in $(find /etc/nginx/owasp-modsecurity-crs/plugins -name '*-before.conf' | sort); do 
     echo "Include $line" >> /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
done
# Add All CRS Rules if present
echo "Include /etc/nginx/owasp-modsecurity-crs/rules/*.conf" >> /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
# Add plugin *-before.conf files if present
for line in $(find /etc/nginx/owasp-modsecurity-crs/plugins -name '*-after.conf' | sort); do 
     echo "Include $line" >> /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
done