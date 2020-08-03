FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:openkim/latest && \
    apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        ccache \
        clang \
        cmake \
        cmake-curses-gui \
        curl \
        doxygen \
        enchant \
        g++ \
        gcc \
        gfortran \
        git \
        hdf5-tools \
        less \
        libblas-dev \
        libeigen3-dev \
        libenchant-dev \
        libfftw3-dev \
        libgsl-dev \
        libhdf5-serial-dev \
        libhwloc-dev \
        libjpeg-dev \
        liblapack-dev \
        libnetcdf-dev \
        libomp-dev \
        libopenblas-dev \
        libnuma-dev \
        libpng-dev \
        libproj-dev \
        libvtk6-dev \
        libyaml-dev \
        make \
        mpi-default-bin \
        mpi-default-dev \
        ninja-build \
        python-dev \
        python-pip \
        python-pygments \
        python-virtualenv \
        python3-dev \
        python3-pip \
        python3-pkg-resources \
        python3-setuptools \
        python3-virtualenv \
        python3-yaml \
        rsync \
        ssh \
        texlive \
        texlive-latex-recommended \
        texlive-formats-extra \
        texlive-pictures \
        texlive-publishers \
        texlive-science \
        dvipng \
        vim-nox \
        virtualenv \
        voro++-dev \
        wget \
        xxd \
        zstd \
        valgrind \
        gdb \
        libkim-api-dev \
        openkim-models && \
    apt-get purge --autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENV PLUMED_VERSION=2.6.0

# manually install Plumed
RUN mkdir plumed && \
    cd plumed && \
    curl -L -o plumed.tar.gz https://github.com/plumed/plumed2/releases/download/v${PLUMED_VERSION}/plumed-src-${PLUMED_VERSION}.tgz && \
    tar -xzf plumed.tar.gz && \
    cd plumed-${PLUMED_VERSION} && \
    ./configure --disable-doc --prefix=/usr && \
    make -j 4 && \
    make install && \
    cd ../../ && \
    rm -rvf plumed

ENV LC_ALL=C.UTF-8
ENV PATH=/usr/lib/ccache:$PATH
ENV DEBIAN_FRONTEND=dialog
