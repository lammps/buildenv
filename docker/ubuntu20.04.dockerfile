FROM ubuntu:20.04

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
        dvipng \
        enchant \
        g++ \
        gcc \
        gdb \
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
        libkim-api-dev \
        liblapack-dev \
        libnetcdf-dev \
        libnuma-dev \
        libomp-dev \
        libopenblas-dev \
        libpng-dev \
        libproj-dev \
        libvtk6-dev \
        libyaml-dev \
        libzstd-dev \
        make \
        mpi-default-bin \
        mpi-default-dev \
        ninja-build \
        python3-pip \
        python3-pygments \
        python3-virtualenv \
        python3-dev \
        python3-pip \
        python3-pkg-resources \
        python3-setuptools \
        python3-virtualenv \
        python3-yaml \
        rsync \
        ssh \
        texlive \
        texlive-formats-extra \
        texlive-latex-recommended \
        texlive-pictures \
        texlive-publishers \
        texlive-science \
        valgrind \
        vim-nox \
        virtualenv \
        voro++-dev \
        wget \
        xxd \
        zstd \
        openkim-models && \
    apt-get purge --autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENV PLUMED_VERSION=2.6.1

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

ENV LC_ALL=C
ENV PATH=/usr/lib/ccache:$PATH
# restrict OpenMPI to shared memory comm by default
ENV    OMPI_MCA_btl="tcp,self"
# do not warn about unused components as this messes up testing
ENV OMPI_MCA_btl_base_warn_component_unused="0"
