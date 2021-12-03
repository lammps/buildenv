FROM centos:7

RUN yum -y install epel-release && \
    yum -y update && \
    yum -y install \
                   Lmod \
                   blas-devel \
                   ccache \
                   clang \
                   cmake3 \
                   eigen3-devel \
                   enchant \
                   fftw-devel \
                   file \
                   gcc-c++ \
                   gcc-gfortran \
                   gdb \
                   git \
                   gsl-devel \
                   hdf5-devel \
                   kim-api-devel \
                   lapack-devel \
                   libjpeg-devel \
                   libjpeg-devel \
                   libpng-devel \
                   libpng-devel \
                   libyaml-devel \
                   libzstd-devel \
                   make \
                   mpich-devel \
                   mpich-devel \
                   netcdf-cxx-devel \
                   netcdf-devel \
                   netcdf-mpich-devel \
                   netcdf-openmpi-devel \
                   ninja-build \
                   openblas-devel \
                   openkim-models \
                   openmpi-devel \
                   openmpi-devel \
                   patch \
                   python-devel \
                   python-devel \
                   python-pip \
                   python-virtualenv \
                   python3-PyYAML \
                   python3-devel \
                   python3-devel \
                   python3-pip \
                   python3-venv \
                   readline-devel \
                   valgrind-openmpi \
                   vim-enhanced \
                   voro++-devel \
                   which \
                   zstd \
                   yaml-cpp-devel && \
    yum clean all

ENV PLUMED_VERSION=2.7.3

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

# create missing readline pkgconfig file
COPY readline_6.2.pc /usr/lib64/pkgconfig/readline.pc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
