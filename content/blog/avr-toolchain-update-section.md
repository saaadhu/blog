---
title: "Making use of objcopy's --update-section for fun and profit"
description: "Using objcopy's --update-section to insert file contents"
tags: ["toolchain", "linker", "binutils", "avr"]
date: "2016-03-16"
categories: ["software", "toolchain"]
---

The binutils project's objcopy utility gained an --update-section feature with the 2.26 release. This flag lets you insert the contents of any file into an already existing section in the ELF.

You can make use of this flag to do a couple of things that are currently tricky to get right - placing data computed from the contents of the ELF (say the SHA1 hash of flash contents) into a binary, and creating a combined bootloader/application image from two separate binary files.

Let's say you have the following piece of codee

      $ cat main.c
      char __attribute__((section(".checksum"))) hash [40] ;
      int main() 
      { 
        return 0; 
      }

And you have the linker script customized to place checksum at a particular flash address, like so
     
     SECTIONS {
       .checksum : AT(0x500) {
        KEEP(*(.checksum))
       } > text
     }
      
You build the code as usual, generate a bin file (excluding the checksum section), and then compute the hash, using SHA1.

     $ avr-gcc -mmcu=atmega1280 main.c checksum.l
     $ avr-objcopy -O binary -R .checksum a.out a.bin
     $ printf `sha1sum -b a.bin | cut -d' ' -f1` > sha1

Now the file sha1 has the SHA1 hash of the bin file - effectively the bytes that will end up in flash.

Then you run avr-objcopy with the --update-section flag, telling it to write content from sha1 into the .checksum section.

     $ avr-objcopy --update-section .checksum=sha1 a.out

That should do the trick. Dumping the contents of the checksum section

     $ avr-objdump -s -j .checksum a.out

     a.out:     file format elf32-avr

     Contents of section .checksum:
     0112 30366133 38343664 62323364 62303562  06a3846db23db05b
     0122 36633561 38623131 39643231 32653464  6c5a8b119d212e4d
     0132 30666335 65336331                    0fc5e3c1      

and the sha1 file

     $ cat sha1
     06a3846db23db05b6c5a8b119d212e4d0fc5e3c1

you can see that the two are identical.

If you then run objcopy -O binary as before, this time without the -R option, you get a new bin file with the checksum included, which you can then use for programming. In your code, you'd treat the hash array as PROGMEM, and use a `__flash pointer` (or the `pgm_read_*` avr-libc macros) to read the hash.

You can use the same trick for embedding code as well, like a bootloader - you  allocate space in the linker script to a section, and then run objcopy --update-section with the section name and the bootloader binary as the argument. The resulting output file will have both the original code and the bootloader code.

Neat eh?
