FROM fedora:32

RUN dnf -y update && \
    dnf -y install vim-enhanced git file make cmake patch which file Lmod \
           ninja-build clang libomp-devel libubsan libasan libtsan diffutils \
           dos2unix findutils rsync python-devel libjpeg-devel libpng-devel \
           ccache gcc-c++ gcc-gfortran gdb valgrind eigen3-devel openblas-devel \
           openmpi-devel mpich-devel fftw-devel voro++-devel gsl-devel hdf5-devel \
           netcdf-devel netcdf-cxx-devel netcdf-mpich-devel netcdf-openmpi-devel \
           python3-pyyaml \
           mingw-filesystem-base mingw32-nsis mingw-binutils-generic \
           mingw32-filesystem mingw32-pkg-config \
           mingw64-filesystem mingw64-pkg-config \
           mingw32-crt mingw32-headers mingw32-binutils \
           mingw64-crt mingw64-headers mingw64-binutils \
           mingw32-cpp mingw32-gcc mingw32-gcc-gfortran mingw32-gcc-c++ \
           mingw64-cpp mingw64-gcc mingw64-gcc-gfortran mingw64-gcc-c++ \
           mingw32-libgomp mingw64-libgomp \
           mingw32-winpthreads mingw64-winpthreads \
           mingw32-winpthreads-static mingw64-winpthreads-static \
           mingw32-eigen3 mingw64-eigen3 \
           mingw32-libjpeg-turbo mingw64-libjpeg-turbo \
           mingw32-libjpeg-turbo-static mingw64-libjpeg-turbo-static \
           mingw32-libpng mingw64-libpng \
           mingw32-libpng-static mingw64-libpng-static \
           mingw32-zlib mingw64-zlib \
           mingw32-zlib-static mingw64-zlib-static \
           mingw32-expat mingw64-expat \
           mingw64-expat-static mingw32-expat-static \
           mingw32-sqlite-static mingw64-sqlite-static \
           enchant python3-virtualenv doxygen \
           texlive-latex-fonts texlive-pslatex texlive-collection-latexrecommended \
           texlive-latex texlive-latexconfig doxygen-latex texlive-collection-latex \
           texlive-latex-bin texlive-lualatex-math texlive-fncychap texlive-tabulary \
           texlive-framed texlive-wrapfig texlive-upquote texlive-capt-of \
           texlive-needspace texlive-titlesec texlive-anysize texlive-dvipng \
           blas-devel lapack-devel libyaml-devel openkim-models kim-api-devel zstd libzstd-devel && \
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

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
