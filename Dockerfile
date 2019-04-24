FROM openjdk:8u151-jre-alpine

ARG BUILDTIME_CORDA_VERSION=4.0-corda
ARG BUILDTIME_JAVA_OPTIONS

ENV CORDA_VERSION=${BUILDTIME_CORDA_VERSION}
ENV JAVA_OPTIONS=${BUILDTIME_JAVA_OPTIONS}

LABEL net.corda.version = ${CORDA_VERSION} \
      maintainer = "shashank.shashank@gmsil.com" \
      vendor = "Personal"

RUN apk upgrade --update && \
    apk add --update --no-cache bash iputils tmux && \
    rm -rf /var/cache/apk/* && \
    addgroup corda && \
    adduser -G corda -D -s /bin/bash corda && \
    mkdir -p /opt/corda/cordapps && \
    mkdir -p /opt/corda/certificates && \
    mkdir -p /opt/corda/logs

ADD --chown=corda:corda https://dl.bintray.com/r3/corda/net/corda/corda/${CORDA_VERSION}/corda-${CORDA_VERSION}.jar /opt/corda/corda.jar

COPY run-corda.sh /run-corda.sh
RUN chmod +x /run-corda.sh && \
    sync && \
    chown -R corda:corda /opt/corda

WORKDIR /opt/corda
ENV HOME=/opt/corda
USER corda

CMD ["/run-corda.sh"]