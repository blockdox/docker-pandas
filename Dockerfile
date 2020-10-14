ARG ALPINE_VERSION=3.11
ARG PYTHON_VERSION=3.7
ARG PANDAS_VERSION=1.0.5

FROM python:${PYTHON_VERSION} AS lock
ARG ALPINE_VERSION
ARG PYTHON_VERSION
ARG PANDAS_VERSION
WORKDIR /var/lib/pandas/
RUN pip install pipenv==2018.11.26
RUN pipenv install 2>&1
COPY Pipfile* /var/lib/pandas/
RUN sed -i s/PANDAS_VERSION/${PANDAS_VERSION}/g /var/lib/pandas/Pipfile && \
    sed -i s/PYTHON_VERSION/${PYTHON_VERSION}/g /var/lib/pandas/Pipfile
RUN pipenv lock --requirements > requirements.txt
RUN pipenv lock --requirements --dev > requirements-dev.txt

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} as alpine
ARG ALPINE_VERSION
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN apk add --no-cache libstdc++ && \
    apk add --no-cache --virtual .build-deps g++ && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install $(grep numpy requirements.txt) && \
    pip3 install -r requirements.txt && \
    apk del .build-deps

FROM python:${PYTHON_VERSION}-slim AS slim
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep numpy requirements.txt) && \
    pip install -r requirements.txt

FROM python:${PYTHON_VERSION} AS jupyter
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep numpy requirements.txt) && \
    pip install -r requirements.txt -r requirements-dev.txt

FROM python:${PYTHON_VERSION} AS latest
WORKDIR /var/lib/pandas/
COPY --from=lock /var/lib/pandas/ .
RUN pip install $(grep numpy requirements.txt) && \
    pip install -r requirements.txt
