#!/bin/sh
set -e

# Load secrets as environment variables
for secret in /run/secrets/env_*; do
    # Pattern matches with no results are treated as string literals.
    # Verify that the file actually exists.
    [ -f "$secret" ] || continue
    set -a
    . $secret
    set +a
done

export SESSION_COOKIE_DOMAIN=$PUBLIC_HOST
export PUBLIC_URL=${PUBLIC_PROTOCOL}://${PUBLIC_HOST}
export GEOSERVER_PROXY_URL=${PUBLIC_URL}/geoserver/

# If the data directory doesn't exist, copy the one embedded in the WAR.
[ ! -e $GEOSERVER_DATA_DIR/global.xml ] && cp -r $WEBAPPS_DIR/geoserver/data/* /var/lib/geoserver/data/

# Remove the data directory embedded in the WAR.
rm -rf $WEBAPPS_DIR/geoserver/data

# Copy in the default styles.
mkdir -p $GEOSERVER_DATA_DIR/styles
cp /tmp/styles/* $GEOSERVER_DATA_DIR/styles/

# Copy in the geonode workspace.
mkdir -p $GEOSERVER_DATA_DIR/workspaces
cp -R /tmp/workspaces/* $GEOSERVER_DATA_DIR/workspaces/

touch $GEOSERVER_DATA_DIR/geofence/geofence-datasource-ovr.properties
touch $GEOSERVER_DATA_DIR/geofence/geofence.properties

# Process params
PARAMS=""
for i do # loop over $@
    if [ "$i" = "--shell" ]; then
        # Override the exec config and run a shell
        PARAMS="$PARAMS --exec /bin/bash"
    fi
done

cd /opt
# Resolve the template for the config file so that paths are correct
./consul-template -template "config.hcl:config-new.hcl" -once
# Resolve the rest of the templates and run tomcat
./consul-template -config config-new.hcl -once $PARAMS
