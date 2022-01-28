#!/bin/sh

# Configure antivirus plugin
if [[ "${CLAMAV_PLUGIN_ENABLED}" = "true" ]] && [[ -n "${CLAMAV_ADDRESS}" ]]; then
    sed -i "s/plugin_clamav_connect_type=.*'/plugin_clamav_connect_type=tcp'/g" antivirus-plugin/plugins/antivirus-config.conf
    sed -i "s/plugin_clamav_address=.*'/plugin_clamav_address=${CLAMAV_ADDRESS}'/g" antivirus-plugin/plugins/antivirus-config.conf
    if [[ -n "${CLAMAV_PORT}" ]]; then
        sed -i "s/plugin_clamav_port=.*'/plugin_clamav_port=${CLAMAV_PORT}'/g" antivirus-plugin/plugins/antivirus-config.conf
    fi
    if [[ -n "${CLAMAV_SCAN_REQUEST_BODY}" ]]; then
        sed -i "s/plugin_scan_request_body=.*'/plugin_scan_request_body=${CLAMAV_SCAN_REQUEST_BODY}'/g" antivirus-plugin/plugins/antivirus-config.conf
    fi
    if [[ -n "${CLAMAV_MAX_DATA_SIZE}" ]]; then
        sed -i "s/plugin_max_data_size_bytes=.*'/plugin_max_data_size_bytes=${CLAMAV_MAX_DATA_SIZE}'/g" antivirus-plugin/plugins/antivirus-config.conf
    fi
    if [[ -n "${CLAMAV_NETWORK_TIMEOUT}" ]]; then
        sed -i "s/plugin_network_timeout_seconds=.*'/plugin_network_timeout_seconds=${CLAMAV_NETWORK_TIMEOUT}'/g" antivirus-plugin/plugins/antivirus-config.conf
    fi
    if [[ -n "${CLAMAV_CHUNK_SIZE}" ]]; then
        sed -i "s/plugin_clamav_chunk_size_bytes=.*'/plugin_clamav_chunk_size_bytes=${CLAMAV_CHUNK_SIZE}'/g" antivirus-plugin/plugins/antivirus-config.conf
    fi
    mv antivirus-plugin/plugins/* coreruleset/plugins/
fi

# Configure fakebot google plugin
if [[ "${FAKEBOT_PLUGIN_ENABLED}" = "true" ]]; then
    mv fake-bot-plugin/plugins/* coreruleset/plugins/
fi

# Configure Incubator plugin
if [[ "${INCUBATOR_PLUGIN_ENABLED}" = "true" ]]; then
    mv incubator-plugin/plugins/* coreruleset/plugins/
fi

# Configure body-decompress plugin
if [[ "${BODY_DECOMPRESS_PLUGIN_ENABLED}" = "true" ]]; then
    if [[ -n "${BODY_DECOMPRESS_MAX_DATA_SIZE}" ]]; then
        sed -i "s/plugin_max_data_size_bytes=.*'/plugin_max_data_size_bytes=${CLAMAV_MAX_DATA_SIZE}'/g" body-decompress-plugin/plugins/body-decompress-config.conf
    fi
    mv body-decompress-plugin/plugins/* coreruleset/plugins/
fi

# Configure auto-decoding plugin
if [[ "${AUTO_DECODING_PLUGIN_ENABLED}" = "true" ]]; then
    if [[ -n "${AUTO_DECODING_DOUBLE_DECODING_ENABLED}" ]]; then
        sed -i "s/#SecAction/#SecAction/g" body-decompress-plugin/plugins/body-decompress-config.conf
        sed -i "s/#    /    /g" body-decompress-plugin/plugins/body-decompress-config.conf
    fi
    mv body-decompress-plugin/plugins/* coreruleset/plugins/
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