FROM fedora:32

RUN dnf -y update && \
    dnf -y install \
                   blas-devel \
                   ccache \
                   clang \
                   cmake \
                   diffutils \
                   dos2unix \
                   doxygen \
                   doxygen-latex \
                   eigen3-devel \
                   enchant \
                   fftw-devel \
                   file \
                   file \
                   findutils \
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
                   libzstd-devel
                   make \
                   mingw-binutils-generic \
                   mingw-filesystem-base \
                   mingw32-binutils \
                   mingw32-cpp \
                   mingw32-crt \
                   mingw32-eigen3 \
                   mingw32-fftw \
                   mingw32-filesystem \
                   mingw32-gcc \
                   mingw32-gcc-c++ \
                   mingw32-gcc-gfortran \
                   mingw32-headers \
                   mingw32-libgomp \
                   mingw32-libjpeg-turbo \
                   mingw32-libpng \
                   mingw32-nsis \
                   mingw32-pkg-config \
                   mingw32-readline \
                   mingw32-termcap \
                   mingw32-winpthreads \
                   mingw32-zlib \
                   mingw64-binutils \
                   mingw64-cpp \
                   mingw64-crt \
                   mingw64-eigen3 \
                   mingw64-fftw \
                   mingw64-filesystem \
                   mingw64-gcc \
                   mingw64-gcc-c++ \
                   mingw64-gcc-gfortran \
                   mingw64-headers \
                   mingw64-libgomp \
                   mingw64-libjpeg-turbo \
                   mingw64-libpng \
                   mingw64-pkg-config \
                   mingw64-readline \
                   mingw64-termcap \
                   mingw64-winpthreads \
                   mingw64-zlib \
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
                   python-devel \
                   python3-pyyaml \
                   python3-virtualenv \
                   readline-devel \
                   rsync \
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
                   texlive-xindy \
                   valgrind \
                   vim-enhanced \
                   voro++-devel \
                   which \
                   zstd && \
    dnf clean all

ENV PLUMED_VERSION=2.6.1

RUN source /usr/share/lmod/lmod/init/profile && \
    module purge && \
    module load mpi && \
    mkdir plumed && \
    cd plumed && \
    curl -L -o plumed.tar.gz https://github.com/plumed/plumed2/releases/download/v${PLUMED_VERSION}/plumed-src-${PLUMED_VERSION}.tgz && \
    tar -xzf plumed.tar.gz && \
    cd plumed-${PLUMED_VERSION} && \
    ./configure --disable-doc --prefix=/usr && \
    make -j 4 && \
    make install && \
    mv -v /usr/lib64/pkgconfig/plumed* /usr/share/pkgconfig/ && \
    cd ../../ && \
    rm -rvf plumed

# restrict OpenMPI to shared memory comm by default
ENV OMPI_MCA_btl="tcp,self"
# do not warn about unused components as this messes up testing
ENV OMPI_MCA_btl_base_warn_component_unused="0"

COPY termcap_i686.pc   /usr/i686-w64-mingw32/sys-root/mingw/lib/pkgconfig/termcap.pc
COPY termcap_x86_64.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/termcap.pc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
