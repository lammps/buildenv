FROM centos:8

RUN dnf -y install epel-release dnf-utils && \
    dnf config-manager --set-enabled PowerTools && \
    dnf -y update && \
    dnf -y install \
                   blas-devel \
                   ccache \
                   clang \
                   cmake \
                   diffutils \
                   doxygen \
                   doxygen-latex \
                   eigen3-devel \
                   enchant \
                   fftw-devel \
                   file \
                   file \
                   gcc-c++ \
                   gcc-gfortran \
                   gdb \
                   git \
                   gsl-devel \
                   hdf5-devel \
                   kim-api-devel \
                   lapack-devel \
                   latexmk \
                   libasan \
                   libjpeg-devel \
                   libomp-devel \
                   libpng-devel \
                   libtsan \
                   libubsan \
                   libyaml-devel \
                   libzstd-devel \
                   make \
                   mpich-devel \
                   netcdf-cxx-devel \
                   netcdf-devel \
                   netcdf-mpich-devel \
                   netcdf-openmpi-devel \
                   ninja-build \
                   openblas-devel \
                   openkim-models \
                   openmpi-devel \
                   patch \
                   platform-python-devel \
                   python3-virtualenv \
                   readline-devel \
                   texlive-anysize \
                   texlive-capt-of \
                   texlive-collection-latex \
                   texlive-collection-latexrecommended \
                   texlive-dvipng \
                   texlive-fncychap \
                   texlive-framed \
                   texlive-latex \
                   texlive-latex-bin \
                   texlive-latex-fonts \
                   texlive-latexconfig \
                   texlive-lualatex-math \
                   texlive-needspace \
                   texlive-pslatex \
                   texlive-tabulary \
                   texlive-titlesec \
                   texlive-upquote \
                   texlive-wrapfig \
                   valgrind \
                   vim-enhanced \
                   voro++-devel \
                   which \
                   zstd && \
        dnf clean all

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

# create missing readline pkgconfig file
COPY readline.pc /usr/lib64/pkgconfig/readline.pc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
