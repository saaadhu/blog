---
title: "Thin LTO and compile time errors"
description: "How thin LTO breaks compiler errors"
tags: ["toolchain", "gcc", "lto", "dejagnu"]
date: "2016-10-04"
categories: ["software", "toolchain", "gccdev"]
---

GCC has had link time optimization (LTO) for quite a while now. Instead of
generating just assembly code, it streams intermediate representation (IR) 
for the translation unit to the object file. At link time, when you provide
all the object files necessary to link into the ELF, the compiler gets to see 
IR from all the translation units together, and this lets it perform 
optimizations across translation units. All you have to do is
add -flto to the compiler and linker invocations and you're done.

Prior to GCC 4.9, if you compile with -flto, the compiler driver generated and
placed both object code and IR into the object file. GCC 4.9 onwards places 
only streamed IR in object files (thin LTO) as opposed to the previous 
behavior (fat LTO), if configured with linker plugin support. There is, of 
course, a command line flag to control this - f(no)fat-lto-objects.

Watch out though - generating thin LTO object files by default can potentially
break DejaGNU compile-only tests. Take 
gcc/testsuite/gcc.target/avr/torture/builtins-error.c
for example. That test expects errors when compiling code calling a couple
of builtins with invalid (non const at compile time) parameters.

In the avr target, the TARGET_FOLD_BUILTIN target hook is responsible for 
detecting and emitting the error. But that doesn't run when generating thin 
LTO objects i.e. when compiling. It runs much later, when the streamed IR 
is read back and processed to generate assembly, but that obviously is at 
link time. If your test is dg-do compile, the test will fail.

Easy to fix though - you just add a dg-options DejaGNU directive to force 
ffat-lto-objects, which is what [this](https://github.com/gcc-mirror/gcc/commit/4092cccfea9dd3e5210cc9ca221b1c31a4be84ad)
commit does.
