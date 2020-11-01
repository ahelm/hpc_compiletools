program hello_hdf5
  use hdf5
  use h5lib
  implicit none
  integer :: majnum, minnum, relnum, err

  call h5get_libversion_f(majnum, minnum, relnum, err)
  write(*, "('hello from HDF5 in Fortran, libver = ')", advance="no")
  write(*, "(I0,'.')", advance="no") majnum
  write(*, "(I0,'.')", advance="no") minnum
  write(*, "(I0)") relnum
end program hello_hdf5