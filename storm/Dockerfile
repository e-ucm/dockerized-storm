#
# Intended as a base image from which the different Storm 
# servers can be launched
#
FROM java:openjdk-8-jre-alpine

# get deps:
#    wget to download storm
#    bash for scripting
#    nano for in-container debugging
#    python required by nimbus
RUN apk update \
    && apk add wget nano bash python

# setup env
ENV USER_NAME="user" \
    WORK_DIR="/app" \
    STORM_VERSION="apache-storm-0.10.0"
ENV STORM_CFG="$WORK_DIR/$STORM_VERSION/conf/storm.yaml" \
    STORM_DIR="$WORK_DIR/$STORM_VERSION/" \
    HOME="$WORK_DIR"

# setup user, group and workdir
RUN addgroup -S ${USER_NAME} \
    && adduser -S -h ${WORK_DIR} -H -G ${USER_NAME} ${USER_NAME} \
    && mkdir ${WORK_DIR} \
    && chown -R ${USER_NAME}:${USER_NAME} ${WORK_DIR}
USER ${USER_NAME}
WORKDIR ${WORK_DIR}

# download & install storm
RUN wget http://apache.rediris.es/storm/${STORM_VERSION}/${STORM_VERSION}.tar.gz \
    && tar -xvzf ${STORM_VERSION}.tar.gz \
    && ln -s ${WORK_DIR}/${STORM_VERSION}/bin/storm . \
    && rm ${STORM_VERSION}.tar.gz

# add config script, and make it executable
COPY launcher.sh launcher.sh
# need to briefly elevate privs to chmod
USER root
RUN chmod 0755 launcher.sh
USER ${USER_NAME}

CMD [ "/bin/bash" ]
