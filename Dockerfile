FROM maven:3.5-jdk-8-alpine AS builder
LABEL maintainer="Tyler Battle <tbattle@boundlessgeo.com>"

# COPY m2 /root/.m2
COPY geoserver-geonode-ext /geoserver-geonode-ext
WORKDIR /geoserver-geonode-ext/geoserver
RUN mvn dependency:go-offline
RUN mvn install -DskipTests -Dmaven.gitcommitid.skip=true

COPY ms-gs-plugins /ms-gs-plugins
WORKDIR /ms-gs-plugins
RUN mvn dependency:go-offline
RUN set -ex \
    && mvn install -DskipTests -Dmaven.gitcommitid.skip=true \
    && cp target/*.jar /geoserver-geonode-ext/geoserver/web-app/target/geoserver/WEB-INF/lib/


FROM tomcat:9-jre8 AS runner

ENV CONSUL_TEMPLATE_VERSION=0.19.0
ENV WEBAPPS_DIR=$CATALINA_HOME/webapps
ENV GEOSERVER_DATA_DIR /var/lib/geoserver/data

# Install tools
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Add CA cert for self signing
COPY cacerts/ca.crt /usr/local/share/ca-certificates/
COPY cacerts/Certificates_v5.3_DoD.pem.crt /usr/local/share/ca-certificates/
COPY cacerts/comodorsacertificationauthority.crt /usr/local/share/ca-certificates/
COPY cacerts/comodorsadomainvalidationsecureserverca.crt /usr/local/share/ca-certificates/
RUN set -ex \
    && update-ca-certificates \
    && keytool -import -v -trustcacerts -alias server-alias -file /usr/local/share/ca-certificates/ca.crt -keystore cacerts.jks -keypass changeit -storepass changeit -noprompt

# Install consul-template
RUN set -ex \
    && wget -qO /opt/consul-template.tgz https://releases.hashicorp.com/consul-template/$CONSUL_TEMPLATE_VERSION/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz \
    && tar xf /opt/consul-template.tgz -C /opt/ consul-template \
    && rm /opt/consul-template.tgz

# Install native dependencies
RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libgeos-dev \
        libproj-dev \
        spatialite-bin \
    && rm -rf /var/lib/apt/lists/*

# Install GeoServer WAR
COPY --from=builder /geoserver-geonode-ext/geoserver/web-app/target/geoserver $WEBAPPS_DIR/geoserver

RUN mkdir /tmp/mapstory && mkdir /tmp/mapstory/geoserver

COPY styles/ /tmp/styles
COPY workspaces/ /tmp/workspaces
COPY config.hcl /opt/
COPY templates/ /opt/templates

COPY run.sh /opt/

#RUN mkdir -p $GEOSERVER_DATA_DIR && chown tomcat:tomcat $GEOSERVER_DATA_DIR
RUN mkdir -p $GEOSERVER_DATA_DIR
ENV GEOSERVER_ENABLE_GZIP true
ENTRYPOINT ["/opt/run.sh"]

#TODO: SECURITY don't run as root
