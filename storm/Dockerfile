#
# Intended as a base image from which the different Storm 
# servers can be launched
#
FROM ubuntu:vivid

# get deps
RUN apt-get update \
    && apt-get install -y supervisor wget openjdk-8-jre-headless nano \
    && mkdir -p /var/log/supervisor
   
# setup env
ENV USER_NAME="user" \
    WORK_DIR="/app" \
    STORM_VERSION="apache-storm-0.9.5"

# setup user, group and workdir
RUN groupadd -r ${USER_NAME} \
    && useradd -r -d ${WORK_DIR} -g ${USER_NAME} ${USER_NAME} \
    && mkdir ${WORK_DIR} \
    && chown ${USER_NAME}:${USER_NAME} ${WORK_DIR}
USER ${USER_NAME}
ENV HOME=${WORK_DIR}
WORKDIR ${WORK_DIR}

# download & install storm
RUN wget http://apache.rediris.es/storm/${STORM_VERSION}/${STORM_VERSION}.tar.gz \
    && tar -xvzf ${STORM_VERSION}.tar.gz \
    && ln -s ${WORK_DIR}/${STORM_VERSION}/bin/storm . \
    && rm ${STORM_VERSION}.tar.gz

# add config script, and make it executable
COPY goStorm.sh goStorm.sh
# need to briefly elevate privs to chmod
USER root
RUN chmod 0755 goStorm.sh
USER ${USER_NAME}
ENV STORM_CFG="$WORK_DIR/$STORM_VERSION/conf/storm.yaml"
ENV STORM_DIR="$WORK_DIR/$STORM_VERSION/"
ENV STORM_VOL="$WORK_DIR/storm_vol"

VOLUME storm_vol

CMD [ "/bin/bash" ]