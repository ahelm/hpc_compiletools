FROM gcc:latest

# build openMPI for building and running
ENV MPI_ROOT="/usr/local/mpi"
ENV MPI_LIB="/usr/local/mpi/lib"
ENV MPI_INC="/usr/local/mpi/include"
ENV PATH="${MPI_ROOT}/bin:${PATH}"

RUN \
  wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz && \
  echo "7b4ddd4ec610cbd1059d23bca3bfd853 openmpi-4.0.0.tar.gz" | md5sum -c && \
  tar -xzvf openmpi-4.0.0.tar.gz && \
  cd openmpi-4.0.0 && \
  ./configure --prefix=${MPI_ROOT} && \
  make install && \
  cd .. && \
  rm -rf openmpi-4.0.0 openmpi-4.0.0.tar.gz

# build SZIP for building
ENV SZIP_ROOT="/usr/local/szip"
ENV SZIP_LIB="/usr/local/szip/lib"
ENV SZIP_INC="/usr/local/szip/include"

RUN \
  wget  https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz && \
  echo "5addbf2a5b1bf928b92c47286e921f72  szip-2.1.1.tar.gz" | md5sum -c && \
  tar -xzvf szip-2.1.1.tar.gz && \
  cd szip-2.1.1 && \
  ./configure --prefix=${SZIP_ROOT} && \
  make install && \
  cd .. && \
  rm -rf szip-2.1.1 szip-2.1.1.tar.gz

# build HDF5 for building
ENV HDF5_ROOT="/usr/local/hdf5"
ENV HDF5_LIB="/usr/local/hdf5/lib"
ENV HDF5_INC="/usr/local/hdf5/include"

RUN \
  wget  https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.4/src/hdf5-1.10.4.tar.gz && \
  echo "cdf02e61f0d9920a7e7183aa0fb35429  hdf5-1.10.4.tar.gz" | md5sum -c && \
  tar -xzvf hdf5-1.10.4.tar.gz && \
  cd hdf5-1.10.4 && \
  ./configure --prefix=${HDF5_ROOT} --enable-fortran --enable-hl --with-szlib=${SZIP_ROOT} && \
  make install && \
  cd .. && \
  rm -rf hdf5-1.10.4 hdf5-1.10.4.tar.gz

# build HDF5 for building
ENV FFTW3_ROOT="/usr/local/fftw3"
ENV FFTW3_LIB="/usr/local/fftw3/lib"
ENV FFTW3_INC="/usr/local/fftw3/include"

RUN \
  wget http://www.fftw.org/fftw-3.3.8.tar.gz && \
  echo "8aac833c943d8e90d51b697b27d4384d  fftw-3.3.8.tar.gz" | md5sum -c && \
  tar -xzvf fftw-3.3.8.tar.gz && \
  cd fftw-3.3.8 && \
  ./configure --prefix=${FFTW3_ROOT} && \
  make install && \
  cd .. && \
  rm -rf fftw-3.3.8 fftw-3.3.8.tar.gz

WORKDIR /project