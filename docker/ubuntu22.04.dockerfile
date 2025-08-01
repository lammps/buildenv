FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common gpg gpg-agent && \
    add-apt-repository ppa:openkim/latest -y && \
    apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get install --no-install-recommends -y \
        bc \
        build-essential \
        ccache \
        clang \
        clang-format \
        cmake \
        cmake-curses-gui \
        curl \
        doxygen \
        enchant-2 \
        file \
        g++ \
        gcc \
        gfortran \
        git \
        hdf5-tools \
        less \
        libblas-dev \
        libeigen3-dev \
        libenchant-2-dev \
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
        libreadline-dev \
        libvtk9-dev \
        libyaml-dev \
        libzstd-dev \
        make \
        mpi-default-bin \
        mpi-default-dev \
        ninja-build \
        python3-dev \
        python3-pip \
        python3-pkg-resources \
        python3-setuptools \
        python3-virtualenv \
        python3-venv \
        python-is-python3 \
        rsync \
        ssh \
        texlive \
        texlive-latex-recommended \
        texlive-formats-extra \
        texlive-pictures \
        texlive-publishers \
        texlive-science \
        dvipng \
        latexmk \
        xindy \
        vim-nox \
        virtualenv \
        voro++-dev \
        wget \
        xxd \
        valgrind \
        gdb \
        zstd \
        libyaml-cpp-dev \
        libkim-api-dev \
        openkim-models && \
    rm -rf /var/lib/apt/lists/*

###########################################################################
# Plumed
###########################################################################

ENV PLUMED_PKG_VERSION=2.9.3

RUN mkdir plumed && \
    cd plumed && \
    curl -L -o plumed.tar.gz https://github.com/plumed/plumed2/releases/download/v${PLUMED_PKG_VERSION}/plumed-src-${PLUMED_PKG_VERSION}.tgz && \
    tar -xzf plumed.tar.gz && \
    cd plumed-${PLUMED_PKG_VERSION} && \
    ./configure --disable-doc --prefix=/usr && \
    make && \
    make install && \
    cd ../../ && \
    rm -rvf plumed

ENV LC_ALL=C
ENV PATH=/usr/lib/ccache:$PATH
# tell OpenMPI to not try using Infiniband
ENV OMPI_MCA_btl="^openib"
# do not warn about unused components as this messes up testing
ENV OMPI_MCA_btl_base_warn_component_unused="0"
