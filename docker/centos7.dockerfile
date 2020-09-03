FROM centos:7

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install vim-enhanced \
        ccache gcc-c++ gcc-gfortran clang gdb valgrind-openmpi \
        make cmake cmake3 ninja-build patch which file git Lmod \
        libpng-devel libjpeg-devel openmpi-devel mpich-devel python-devel python36-devel \
        hdf5-devel python36-virtualenv python36-pip python36-PyYAML python-pip \
        netcdf-devel netcdf-cxx-devel netcdf-mpich-devel netcdf-openmpi-devel \
        python-virtualenv fftw-devel voro++-devel eigen3-devel gsl-devel openblas-devel enchant \
        blas-devel lapack-devel libyaml-devel openkim-models kim-api-devel zstd zstd-devel && \
    yum clean all

ENV PLUMED_VERSION=2.6.1

# manually install Plumed
RUN . /etc/profile && \
    module load mpi && \
    mkdir plumed && \
    cd plumed && \
    curl -L -o plumed.tar.gz https://github.com/plumed/plumed2/releases/download/v${PLUMED_VERSION}/plumed-src-${PLUMED_VERSION}.tgz && \
    tar -xzf plumed.tar.gz && \
    cd plumed-${PLUMED_VERSION} && \
    ./configure --disable-doc --prefix=/usr && \
    make -j 4 && \
    make install && \
    mv -v /usr/lib/pkgconfig/plumed* /usr/share/pkgconfig/ && \
    cd ../../ && \
    rm -rvf plumed

ENV LC_ALL=C

# restrict OpenMPI to shared memory comm by default
ENV OMPI_MCA_btl="tcp,self"
# do not warn about unused components as this messes up testing
ENV OMPI_MCA_btl_base_warn_component_unused="0"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
