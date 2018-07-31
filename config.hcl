
exec {
  #command = "su -u "tomcat" -c "the command to run""
  command = "catalina.sh run"
}

template {
  source = "templates/context.xml.ctmpl"
  destination = "{{ env "CATALINA_HOME" }}/conf/context.xml"
  perms = 0644
}

template {
  source = "templates/geofence_config.xml.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/security/auth/geofence/config.xml"
  perms = 0644
}

template {
  source = "templates/geofence.properties.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/geofence/geofence.properties"
  perms = 0644
}

template {
  source = "templates/geofence-server.properties.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/geofence/geofence-server.properties"
  perms = 0644
}

template {
  source = "templates/geogigconfig.ctmpl"
  destination = "/usr/share/tomcat/.geogigconfig"
  perms = 0644
}

template {
  source = "templates/geonode-oauth2_config.xml.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/security/filter/geonode-oauth2/config.xml"
  perms = 0644
}

template {
  source = "templates/geonodeRESTRoleService_config.xml.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/security/role/geonode REST role service/config.xml"
  perms = 0644
}

template {
  source = "templates/geoserver.xml.ctmpl"
  destination = "/etc/tomcat/Catalina/localhost/geoserver.xml"
  perms = 0644
}

template {
  source = "templates/global.xml.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/global.xml"
  perms = 0644
}

template {
  source = "templates/security_config.xml.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/security/config.xml"
  perms = 0644
}

template {
  source = "templates/rest.properties.ctmpl"
  destination = "{{ env "GEOSERVER_DATA_DIR" }}/security/rest.properties"
  perms = 0644
}

template {
  source = "templates/web.xml.ctmpl"
  destination = "{{ env "WEBAPPS_DIR" }}/geoserver/WEB-INF/web.xml"
  perms = 0644
}
