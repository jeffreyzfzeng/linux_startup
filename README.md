# Learn linux startup

# stage 1: Debug grub2 using gdb

# Download grub2 source code and compile it
1. download grub2 from ftp://ftp.gnu.org/gnu/grub/
2. Go to grub-2.00 source code directory
2. configure make file
    ./configure --prefix=DIR    # DIR: install grub2 under this folder after compile complete

    for example: 
    ./configure --prefix=$PWD/install
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
       press 'c' to continue
8. start debug grub source code as you want

If gdb could not resolve symbol file of grub2 source code, execute command: load_all_modules
load_all_modules loads new inserted grub2 modules' symbol file in gdb environment

Without grub.cfg and linux image in disk.img, after grub_load_normal_normal, grub2 go to grub console window wait for further operations.



# create_grub2_boot_disk_img.sh:
This script create bootable disk img with both grub2 in ubuntu or self compiled grub2 utility


# Compile linux kernel
1. Download linux source code and extract it.
2. Create config file and save config file:
	make menuconfig
	or make defconfig
   result saved in .config file, make sure CONFIG_DEBUG_INFO set as 'y'
3. Compile kernel source code and install it
	make
	make install
4. New kernel image could be found under /boot with version information as suffix
5. Copy grub.cfg linux kernel image to disk file
