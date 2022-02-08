## Build stage
FROM docker.io/maven:3.8.4-openjdk-11 AS builder
COPY ./ /
RUN mvn clean package

## Application image
FROM docker.io/openliberty/open-liberty:22.0.0.1-full-java11-openj9-ubi

COPY --chown=1001:0 config/server.xml /config/server.xml

COPY --chown=1001:0 config/configDropins/overrides/*.xml /config/configDropins/overrides/

COPY --from=builder --chown=1001:0 target/modresorts.war /config/apps/modresorts.war

RUN configure.sh