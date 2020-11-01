#include "hdf5.h"
#include <stdio.h>

int main() {
  unsigned major, minor, release;

  H5get_libversion(&major, &minor, &release);
  printf("hello from HDF5 in C, libver = %d.%d.%d\n", major, minor, release);
}