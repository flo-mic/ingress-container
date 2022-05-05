#!/bin/sh

# Configure antivirus plugin
if [[ "${CLAMAV_PLUGIN_ENABLED}" = "true" ]] && [[ -n "${CLAMAV_ADDRESS}" ]]; then
    echo "Configure Antivirus Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${CLAMAV_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:antivirus-plugin_enabled \"@eq 0\" \\
   \"id:9502010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.antivirus-plugin_enabled=0'\"" >> antivirus-plugin/plugins/antivirus-config.conf 
    fi
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
    echo "Configure Fakebot Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${FAKEBOT_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:fake-bot-plugin_enabled \"@eq 0\" \\
   \"id:9504010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.fake-bot-plugin_enabled=0'\"" >> fake-bot-plugin/plugins/fake-bot-config.conf
    fi
    mv fake-bot-plugin/plugins/* coreruleset/plugins/
fi

# Configure Incubator plugin
if [[ "${INCUBATOR_PLUGIN_ENABLED}" = "true" ]]; then
    echo "Configure Incubator Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${INCUBATOR_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:incubator-plugin_enabled \"@eq 0\" \\
   \"id:9900010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.incubator-plugin_enabled=0'\"" >> incubator-plugin/plugins/incubator-config.conf 
    fi
    mv incubator-plugin/plugins/* coreruleset/plugins/
fi

# Configure body-decompress plugin
if [[ "${BODY_DECOMPRESS_PLUGIN_ENABLED}" = "true" ]]; then
    echo "Configure body-decompress Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${BODY_DECOMPRESS_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:body-decompress-plugin_enabled \"@eq 0\" \\
   \"id:9503010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.body-decompress-plugin_enabled=0'\"" >> body-decompress-plugin/plugins/body-decompress-config.conf 
    fi
    if [[ -n "${BODY_DECOMPRESS_MAX_DATA_SIZE}" ]]; then
        sed -i "s/plugin_max_data_size_bytes=.*'/plugin_max_data_size_bytes=${CLAMAV_MAX_DATA_SIZE}'/g" body-decompress-plugin/plugins/body-decompress-config.conf
    fi
    mv body-decompress-plugin/plugins/* coreruleset/plugins/
fi

# Configure auto-decoding plugin
if [[ "${AUTO_DECODING_PLUGIN_ENABLED}" = "true" ]]; then
    echo "Configure Auto decoding Plugin for OWASP CRS"
    if [[ -n "${AUTO_DECODING_DOUBLE_DECODING_ENABLED}" ]]; then
        sed -i "s/#SecAction/#SecAction/g" auto-decoding-plugin/plugins/generic-transformations-config-before.conf
        sed -i "s/#    /    /g" auto-decoding-plugin/plugins/generic-transformations-config-before.conf
    fi
    mv auto-decoding-plugin/plugins/* coreruleset/plugins/
fi

# Configure nextcloud-rule-exclusions-plugin
if [[ "${NEXTCLOUD_PLUGIN_ENABLED}" = "true" ]]; then
    echo "Configure nextcloud rule exclusion Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${NEXTCLOUD_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:nextcloud-rule-exclusions-plugin_enabled \"@eq 0\" \\
   \"id:9508010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.nextcloud-rule-exclusions-plugin_enabled=0'\"" >> nextcloud-rule-exclusions-plugin/plugins/nextcloud-rule-exclusions-config.conf 
    fi
    mv nextcloud-rule-exclusions-plugin/plugins/* coreruleset/plugins/
fi

# Configure pgadmin-rule-exclusions-plugin
if [[ "${PGADMIN_PLUGIN_ENABLED}" = "true" ]]; then
    echo "Configure pgadmin rule exclusion Plugin for OWASP CRS"
    # Disable the plugin globally so it can be loaded in individual server locations only
    if [[ "${PGADMIN_ACTIVATE_GLOBALLY}" = "false" ]]; then
        echo "# Disabling plugin globally (can still be enabled on ingress objects by setting the variable back to 1)
SecRule &TX:pgadmin-rule-exclusions-plugin_enabled \"@eq 0\" \\
   \"id:9516010,\\
    phase:1,\\
    pass,\\
    nolog,\\
    setvar:'tx.pgadmin-rule-exclusions-plugin_enabled=0'\"" >> pgadmin-rule-exclusions-plugin/plugins/pgadmin-rule-exclusions-config.conf
    fi
    if [[ -n "${PGADMIN_SESSION_COOKIE_NAME}" ]]; then
        sed -i "s/pga4_session/${PGADMIN_SESSION_COOKIE_NAME}/g" pgadmin-rule-exclusions-plugin/plugins/pgadmin-rule-exclusions-config.conf
    fi
    mv pgadmin-rule-exclusions-plugin/plugins/* coreruleset/plugins/
fi

# Copy OWASP CRS to destination
if [[ -d "/etc/nginx/owasp-modsecurity-crs/" ]]; then
    echo "Copy OWASP CRS to volume mount"
    cp -r coreruleset/* /etc/nginx/owasp-modsecurity-crs/
fi

# Copy nginx template file
if [[ -d "/etc/nginx/template/" ]]; then
    echo "Copy nginx template file to volume mount"
    cp nginx.tmpl /etc/nginx/template/nginx.tmpl
fi

# Copy modsecurity config file
if [[ -d "/etc/nginx/modsecurity/" ]]; then
    echo "Copy modsecurity configuration file to volume mount"
    cp modsecurity.conf /etc/nginx/modsecurity/modsecurity.conf
fi

# Build nginx configuration file
# Add crs-setup file
if [[ -d "/etc/nginx/owasp-modsecurity-crs/" ]]; then
    echo "Create nginx-modsecurity configuration file"

    echo "Include /etc/nginx/owasp-modsecurity-crs/crs-setup.conf" >> /etc/nginx/owasp-modsecurity-crs/nginx-modsecurity.conf
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
fi