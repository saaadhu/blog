---
title: LTO and the linker command line
tags: ["toolchain", "linker", "lto"]
date: 2014-03-17
categories:
    - "software"
    - "toolchain"
---

If you're using GCC's [LTO](http://gcc.gnu.org/wiki/LinkTimeOptimization) feature, make sure you repeat the compiler flags when linking. So, if you compile code with `-Os -ffunction-sections`, make sure you pass the same flags to the gcc driver when linking.

This is needed because LTO effectively recompiles by streaming in IR from the object files and regenerating code. Only this time it knows about the code in all the object files that's going to be part of the final executable, so it can perform a bunch of optimizations it previously couldn't. The consequence, of course, is that the command line options affect everything from IR -> asssembly code generation -> assembly.

Just a tiny example to demonstrate the point.

    $ cat lto-test.c
    extern int x;
    void foo() {x++; }

    int main() { return 0; }

    $ gcc lto-test.c -ffunction-sections -c 
    $ gcc lto-test.o -Wl,--gc-sections

This program links even though x is not defined anywhere, because -ffunction-sections makes the compiler put each function in its own section, and --gc-sections makes the linker discards unused sections. The linker throws away foo because it isn't referenced anywhere, and therefore there are no references to x either.

With LTO and the same command line, however, this is what happens

    $ gcc lto-test.c -ffunction-sections -c -flto
    $ gcc lto-test.o -Wl,--gc-sections -flto
    /tmp/ccbA5pMx.ltrans0.ltrans.o: In function `foo.2380':
    ccbA5pMx.ltrans0.o:(.text+0x6): undefined reference to `x'
    ccbA5pMx.ltrans0.o:(.text+0xf): undefined reference to `x'
    collect2: error: ld returned 1 exit status

You know by now why the linker is complaining about x - the link command line only passes -flto. The LTO'ed code does not have per-function sections, --gc-sections of course can't eliminate foo because it's not in a separate section, and x is referenced from the code without a definition.

Adding -ffunction-sections to the link command line makes the problem go away.

    $ gcc lto-test.o -Wl,--gc-sections -flto -ffunction-sections 
    $

Just something to keep in mind if you're using LTO.


