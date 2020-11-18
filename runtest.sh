#!/usr/bin/env bash
abort() {
  # Aborts script execution and returns 1 as exit code.
  echo >&2 "[ERROR] Stopping execution !!!"
  exit 1
}

assert() {
  # Uses regex to compare to strings aborts script if
  # substring not found
  #
  # Parameters
  # ----------
  #
  # `$1`: Base string for comparision.
  #
  # `$2`: Substring which should be in $1
  #
  if [[ ! "$1" =~ "$2" ]]; then
    echo >&2 "[ERROR] Assertion failed"
    abort
  fi
}

run() {
  # Executes a commend in a specified docker container and
  # checks if the outputs matches a substring.
  #
  # Parameters
  # ----------
  #
  # `$1`: Docker container to be used for execution.
  #
  # `$2`: Command which will be executed in docker container.
  #
  # `$3`: (Optional) String to which should be contained
  #       in the output.
  #
  echo "> on '$1' running: $2"
  cmd="docker run -v $(pwd):/project $1 bash -c '$2'"
  output=$(eval $cmd)
  [ $? -ne 0 ] && abort
  if [[ -n $3 ]]; then
    assert "$output" "$3"
  fi
}

# tmp directory for output
if [ ! -d test/tmp_output ]; then
  mkdir test/tmp_output
fi

######################################################################
# TESTS
######################################################################
# checks user name
run 'hpc_compiletools/gcc:latest' 'id' 'hpc_user'

# gcc latest
run \
  'hpc_compiletools/gcc:latest' \
  'gcc ${HPC_C_COMPILE_ARGS} ${HPC_C_LINK_ARGS} -o test/tmp_output/hello-mpi-c.out test/hello_mpi.c'
run \
  'hpc_compiletools/gcc:latest' \
  'test/tmp_output/hello-mpi-c.out' \
  'hello from MPI in C'

run \
  'hpc_compiletools/gcc:latest' \
  'gfortran ${HPC_F_COMPILE_ARGS} ${HPC_F_LINK_ARGS} -o test/tmp_output/hello-mpi-fortran.out test/hello_mpi.f90'
run \
  'hpc_compiletools/gcc:latest' \
  'test/tmp_output/hello-mpi-fortran.out' \
  'hello from MPI in Fortran'

run \
  'hpc_compiletools/gcc:latest' \
  'gcc ${HPC_C_COMPILE_ARGS} ${HPC_C_LINK_ARGS} -o test/tmp_output/hello-hdf5-c.out test/hello_hdf5.c'
run \
  'hpc_compiletools/gcc:latest' \
  'test/tmp_output/hello-hdf5-c.out' \
  'hello from HDF5 in C'


run \
  'hpc_compiletools/gcc:latest' \
  'gfortran ${HPC_F_COMPILE_ARGS} ${HPC_F_LINK_ARGS} -o test/tmp_output/hello-hdf5-fortran.out test/hello_hdf5.f90'
run \
  'hpc_compiletools/gcc:latest' \
  'test/tmp_output/hello-hdf5-fortran.out' \
  'hello from HDF5 in Fortran'

# cleanup build directory
if [ -d test/tmp_output ]; then
  rm -rf test/tmp_output
fi
