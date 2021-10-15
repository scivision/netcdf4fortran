program test_string

use, intrinsic:: iso_fortran_env, only:  stderr=>error_unit
use, intrinsic:: iso_c_binding, only: c_null_char

use nc4fortran, only : netcdf_file

implicit none (type, external)


type(netcdf_file) :: h

character(2) :: value
character(1024) :: val1k
character(*), parameter :: path='test_string.nc'

call h%open(path, action='w')

call h%write('little', '42')
call h%write('MySentence', 'this is a little sentence.')

call h%close()

call h%open(path, action='r')
call h%read('little', value)

if (value /= '42') error stop 'test_string:  read/write verification failure. Value: '// value

print *,'test_string_rw: reading too much data'
!! try reading too much data, then truncating to first C_NULL
call h%read('little', val1k)

if (len_trim(val1k) /= 2) then
  write(stderr, *) 'expected len_trim 2, got len_trim = ', len(val1k)
  error stop
endif

call h%close()

print *, 'OK: test_string'

end program
