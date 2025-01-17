FROM python:latest as build

LABEL maintainer="OmniDB team"

ARG OMNIDB_VERSION=3.0.3b

SHELL ["/bin/bash", "-c"]

USER root

RUN addgroup --system omnidb \
    && adduser --system omnidb --ingroup omnidb \
    && apt-get update \
    && apt-get install libsasl2-dev python-dev libldap2-dev libssl-dev vim -y

USER omnidb:omnidb
ENV HOME /home/omnidb
WORKDIR ${HOME}

COPY . ${HOME}/OmniDB

WORKDIR ${HOME}/OmniDB

RUN pip install -r requirements.txt \
    && mkdir ${HOME}/.omnidb

WORKDIR ${HOME}/OmniDB/OmniDB

CMD python omnidb-server.py -H ${OMNIDB_HOST:-0.0.0.0}


FROM build as test

RUN set -ex
RUN id omnidb
