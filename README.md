# arm-gcc-blink-example
A simple blink example by using ARM gcc for Ameba dev. board

Work on Windows Cygwin evironment, can port onto Linux

toolchain : ARM GCC
     https://launchpad.net/gcc-arm-embedded
     
setup

  cd templates
  cd ameba-example
  ./setup.sh


Make procedure : insert Arduino dev board and then :
   $cd build
   $make

Clean procedure :
   $cd build
   $make clean
