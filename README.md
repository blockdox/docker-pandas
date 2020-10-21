# Introduction

This is an adaptation of [The upstream repository by _amancevice_](https://github.com/amancevice/docker-pandas/).
For additional build options it's worthwhile to consult the documentation there too.

# Available Versions

While the Dockerfile allows versions to be built from both Apline and Ubuntu baselines, only Alpine builds
have been tested.

Versions are tagged in a way that indicates the Pandas and Python which are used as baseline.
If Scipy is used, then its version is also given as part of the Docker tag.
In addition, the images in this repository are also tagged with the following tags:

* org.pydata.pandas.version
* org.python.version
* org.alpinelinux.version
* org.scipy.version (when Scipy is included)

The best place to see which versions are available is [the repository](https://hub.docker.com/repository/docker/blockdox/pandas).
Example versions:

* 1.0.5-py3.7-alpine
* 1.0.5-scipy1.5.2-py3.7

## Building

Use the `make` command to build a new suite of pandas images, specifying
Pandas and Python versions, and optionally also the Alpine version

```bash
make clean
make alpine PANDAS_VERSION=1.0.5 PYTHON_VERSION=3.7
make scipy PANDAS_VERSION=1.0.5 PYTHON_VERSION=3.7
```

Optionally SCIPY_VERSION could also be specified
