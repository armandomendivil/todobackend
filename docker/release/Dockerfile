FROM vigulant/todobackend-base:latest
MAINTAINER Jonathan Klingberg <jonathan.klingberg@gmail.com>

COPY target /wheelhouse

RUN . /appenv/bin/activate && \
    pip install --no-index -f /wheelhouse todobackend && \
    rm -rf /wheelhouse
