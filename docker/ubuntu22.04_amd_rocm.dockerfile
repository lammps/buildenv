FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get install -y --no-install-recommends curl wget gnupg ca-certificates && \
    rm -rf /var/lib/apt/lists/*


###########################################################################
# ROCm 5.7.1
###########################################################################
RUN apt-get update && \
    wget https://repo.radeon.com/amdgpu-install/5.7.1/ubuntu/jammy/amdgpu-install_5.7.50701-1_all.deb && \
    apt-get install -y ./amdgpu-install_5.7.50701-1_all.deb && \
    apt-get install --no-install-recommends -y \
        kmod \
        file \
        sudo \
        libelf1 \
        build-essential && \
    amdgpu-install --usecase=rocm --no-dkms -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/lib/ccache:${PATH}:/opt/rocm/bin
RUN echo -e '/opt/rocm/lib\n/opt/rocm/lib64\n' > /etc/ld.so.conf.d/rocm.conf && ldconfig

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
        python3-venv \
        python-is-python3 \
        rsync \
        ssh \
        vim-nox \
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

ENV PLUMED_PKG_VERSION=2.8.2

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
