ARG PYTHON_VERSION=3.7
ARG PANDAS_VERSION=1.0.5

FROM blockdox/pandas:${PANDAS_VERSION}-py${PYTHON_VERSION}-alpine
ARG SCIPY_VERSION=1.5.2

RUN apk -U add --update --no-cache lapack blas openblas
RUN apk -U add --update --no-cache lapack-dev blas-dev openblas-dev g++ gfortran && \
    pip3 install "scipy==${SCIPY_VERSION}" && \
    apk del g++ gfortran lapack-dev blas-dev openblas-dev

LABEL org.scipy.version ${SCIPY_VERSION}
