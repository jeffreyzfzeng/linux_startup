# Learn linux startup

# stage 1: Debug grub2 using gdb

# Download grub2 source code and compile it
1. download grub2 from ftp://ftp.gnu.org/gnu/grub/
2. configure make file
    ./configure --prefix=DIR    # DIR: install grub2 under this folder after compile complete
3. compile and install
    make
    make install
    
    modify stdin.in.h under grub-2.00/grub-core/gnulib/ if compile failed because of gets function
      +#if defined gets
       #undef gets
       _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
      +#endif
4. create bootable disk image using create_grub2_boot_disk_img.sh
5. start qemu with qemu-system-i386 disk.img -s -S
6. open another terminal, go to grub source code folder grub-2.00/grub-core
   gdb -x gdb_grub
7. set break point:
   break *0x7c00
   press 'c'
8. start debug grub source code as you want

# create_grub2_boot_disk_img.sh:
This script create bootable disk img with both grub2 in ubuntu or self compiled grub2 utility

