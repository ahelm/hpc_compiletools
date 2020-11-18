ARG VERSION=latest

FROM gcc:${VERSION}

ENV HPC_C_COMPILE_ARGS=""
ENV HPC_F_COMPILE_ARGS=""
ENV HPC_C_LINK_ARGS=""
ENV HPC_F_LINK_ARGS=""


################################################################################
# OpenMPI
################################################################################
ARG OPENMPI_VERSION=4.0.5
ARG OPENMPI_SHA256=c58f3863b61d944231077f344fe6b4b8fbb83f3d1bc93ab74640bf3e5acac009

ENV MPI_ROOT="/usr/local/mpi"
ENV MPI_BIN="${MPI_ROOT}/bin"
ENV MPI_LIB="${MPI_ROOT}/lib"
ENV MPI_INCLUDE="${MPI_ROOT}/include"

ENV HPC_C_COMPILE_ARGS="-I${MPI_INCLUDE} -pthread ${HPC_C_COMPILE_ARGS}"
ENV HPC_C_LINK_ARGS="-pthread -Wl,-rpath -Wl,${MPI_LIB} -Wl,--enable-new-dtags -L${MPI_LIB} -lmpi ${HPC_C_LINK_ARGS}"

ENV HPC_F_COMPILE_ARGS="-I${MPI_INCLUDE} -pthread -I${MPI_LIB} ${HPC_F_COMPILE_ARGS}"
ENV HPC_F_LINK_ARGS="-pthread -I${MPI_LIB} -Wl,-rpath -Wl,${MPI_LIB} -Wl,--enable-new-dtags -L${MPI_LIB} -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi ${HPC_F_LINK_ARGS}"

ENV PATH="${MPI_BIN}:${PATH}"

RUN \
  wget -o /dev/null https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-${OPENMPI_VERSION}.tar.bz2 && \
  echo "${OPENMPI_SHA256} openmpi-${OPENMPI_VERSION}.tar.bz2" | sha256sum -c && \
  tar -xf openmpi-${OPENMPI_VERSION}.tar.bz2 && \
  cd openmpi-${OPENMPI_VERSION} && \
  ./configure --prefix=${MPI_ROOT} && \
  make -j && \ 
  make install > /dev/null && \
  cd .. && \
  rm -rf openmpi-${OPENMPI_VERSION} openmpi-${OPENMPI_VERSION}.tar.bz2

################################################################################
# SZIP
################################################################################
ARG SZIP_VERSION=2.1.1
ARG SZIP_SHA256=21ee958b4f2d4be2c9cabfa5e1a94877043609ce86fde5f286f105f7ff84d412

ENV SZIP_ROOT="/usr/local/szip"
ENV SZIP_LIB="${SZIP_ROOT}/lib"
ENV SZIP_INCLUDE="${SZIP_ROOT}/include"

ENV HPC_C_COMPILE_ARGS="-I${SZIP_INCLUDE} ${HPC_C_COMPILE_ARGS}"
ENV HPC_C_LINK_ARGS="-Wl,-rpath -Wl,${SZIP_LIB} -L${SZIP_LIB} -lsz ${HPC_C_LINK_ARGS}"

ENV HPC_F_COMPILE_ARGS="-I${SZIP_INCLUDE} ${HPC_F_COMPILE_ARGS}"
ENV HPC_F_LINK_ARGS="-Wl,-rpath -Wl,${SZIP_LIB} -L${SZIP_LIB} -lsz ${HPC_F_LINK_ARGS}"

RUN \
  wget -o /dev/null https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz && \
  echo "${SZIP_SHA256} szip-${SZIP_VERSION}.tar.gz" | sha256sum -c && \
  tar -xzf szip-${SZIP_VERSION}.tar.gz && \
  cd szip-${SZIP_VERSION} && \
  ./configure --prefix=${SZIP_ROOT} && \
  make -j && \ 
  make install > /dev/null && \
  cd .. && \
  rm -rf szip-${SZIP_VERSION} szip-${SZIP_VERSION}.tar.gz

################################################################################
# HDF5
################################################################################
ARG HDF5_SHORT_VER=1.12
ARG HDF5_VERSION=1.12.0
ARG HDF5_SHA256=97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61

ENV HDF5_ROOT="/usr/local/hdf5"
ENV HDF5_BIN="${HDF5_ROOT}/bin"
ENV HDF5_LIB="${HDF5_ROOT}/lib"
ENV HDF5_INCLUDE="${HDF5_ROOT}/include"

ENV HPC_C_COMPILE_ARGS="-I${HDF5_INCLUDE} ${HPC_C_COMPILE_ARGS}"
ENV HPC_C_LINK_ARGS="-Wl,-rpath -Wl,${HDF5_LIB} -L${HDF5_LIB} -lhdf5 -lhdf5_hl ${HPC_C_LINK_ARGS}"

ENV HPC_F_COMPILE_ARGS="-I${HDF5_INCLUDE} -I${HDF5_LIB} ${HPC_F_COMPILE_ARGS}"
ENV HPC_F_LINK_ARGS="-Wl,-rpath -Wl,${HDF5_LIB} -L${HDF5_LIB} -lhdf5hl_fortran -lhdf5_fortran -lhdf5_hl_fortran ${HPC_F_LINK_ARGS}"

ENV PATH="${HDF5_BIN}:${PATH}"

RUN \
  wget -o /dev/null https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_SHORT_VER}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.bz2 && \
  echo "${HDF5_SHA256} hdf5-${HDF5_VERSION}.tar.bz2" | sha256sum -c && \
  tar -xf hdf5-${HDF5_VERSION}.tar.bz2 && \
  cd hdf5-${HDF5_VERSION} && \
  ./configure --prefix=${HDF5_ROOT} --enable-fortran --enable-cxx && \
  make -j && \
  make install > /dev/null && \
  cd .. && \
  rm -rf hdf5-${HDF5_VERSION} hdf5-${HDF5_VERSION}.tar.bz2

RUN groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
USER hpc_user

WORKDIR /project
