FROM java:latest

LABEL maintainer=martin.cortez@redb.ee

ENV LIQUIBASE_VERSION="3.6.2" \
    LIQUIBASE_DRIVER=""\
    LIQUIBASE_CLASSPATH="" \
    LIQUIBASE_URL="" \
    LIQUIBASE_USERNAME="" \
    LIQUIBASE_PASSWORD="" \
    LIQUIBASE_CHANGELOG="" \
    LIQUIBASE_CONTEXTS="" \
    LIQUIBASE_OPTS="" \
    LIQUIBASE_SCHEMA="" \
    LIQUIBASE_LOGLEVEL=""

COPY conf/ /opt/docker/

RUN set -x \
    && apt-get update \
    && wget -q -O/tmp/liquibase.tar.gz "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}-bin.tar.gz" \
    && mkdir -p /opt/liquibase \
    && tar -xzf /tmp/liquibase.tar.gz -C /opt/liquibase \
    && rm -f /tmp/liquibase.tar.gz \
    && chmod +x /opt/liquibase/liquibase \
    && mv /opt/docker/*.jar /opt/liquibase/lib/ \
    && ln -s /opt/liquibase/liquibase /usr/local/bin/ \
    && chmod +x /opt/docker/bin/entrypoint.sh \
	  && apt-get clean \
	  && rm -r /var/lib/apt/lists/* \
    && mkdir /liquibase \
    && ln -sf /opt/docker/bin/entrypoint.sh /entrypoint \
    # cleanup
    && apt-get autoremove -y -f \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /liquibase
ENTRYPOINT ["/entrypoint"]
