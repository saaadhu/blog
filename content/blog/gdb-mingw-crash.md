---
title: "Debugging a debugger - gdb crash on Windows XP"
description: "Why gdb built with a certain version of mingw-gcc crashes on Windows XP"
tags: ["toolchain", "gdb", "crash"]
date: "2014-03-26"
categories: ["software", "toolchain"]
---

If you're one of the crazy guys building gdb for Windows using the 4.6.1 version of the mingw gcc compiler, here's something to watch out for. gdb will crash on any error (even a mistyped command), but only on Windows XP.

Turns out that gdb uses a setjmp/longjmp based error handling mechanism (see gdb/exceptions.c), and any error causes gdb to execute a longjmp. In Windows land, longjmp is implemented in msvcrt.dll, and it so happens that the implementation expects the frame pointer to be setup correctly.

    msvcrt!longjmp+<offset>:
    77c36dc4 6a00            push    0
    77c36dc6 8b4314          mov     eax,dword ptr [ebx+14h]
    77c36dc9 e875e7ffff      call    msvcrt!_NLG_Notify (77c35543)

    msvcrt!_NLG_Notify:
    77c35543 53              push    ebx
    77c35544 51              push    ecx
    77c35545 bb90f9c577      mov     ebx,offset msvcrt!_NLG_Destination (77c5f990)
    77c3554a 8b4d08          mov     ecx,dword ptr [ebp+8]

Note the read from ebp+8 in the last line. When the crash happens, ebp holds a random value, and the memory read results in an access violation and eventually results in a call to msvcrt!_abnormal_termination.

Why does ebp have a random value? Because the default CFLAGS for gcc when building gdb is "-O2 -g", and gcc gleefully chose not to setup a stack frame or use the frame pointer; instead, it simply uses the stack pointer and offsets to refer to locals and parameters. Here's a function foo that calls setjmp and longjmp


    #include <setjmp.h>
    #include <stdio.h>

    void foo()
    {
        volatile char x;
        jmp_buf buf;

        if (setjmp(buf))
        {
            x++;
            printf ("%s", "Here"); 
        }

        x++;
        longjmp(buf, 2);
    }

    int main()
    {
        foo();

        return 1;
    }

and here's the code generated.


    00401390 <_foo>:
      401390:       83 ec 6c                sub    $0x6c,%esp
      401393:       8d 44 24 1c             lea    0x1c(%esp),%eax
      401397:       89 04 24                mov    %eax,(%esp)
      40139a:       e8 71 0a 00 00          call   401e10 <__setjmp>
      40139f:       85 c0                   test   %eax,%eax
      4013a1:       75 20                   jne    4013c3 <_foo+0x33>
      4013a3:       0f b6 44 24 5f          movzbl 0x5f(%esp),%eax
      4013a8:       c7 44 24 04 02 00 00    movl   $0x2,0x4(%esp)
      4013af:       00
      4013b0:       83 c0 01                add    $0x1,%eax
      4013b3:       88 44 24 5f             mov    %al,0x5f(%esp)
      4013b7:       8d 44 24 1c             lea    0x1c(%esp),%eax
      4013bb:       89 04 24                mov    %eax,(%esp)
      4013be:       e8 55 0a 00 00          call   401e18 <_longjmp>
      4013c3:       0f b6 44 24 5f          movzbl 0x5f(%esp),%eax
      4013c8:       c7 44 24 04 24 30 40    movl   $0x403024,0x4(%esp)
      4013cf:       00
      4013d0:       c7 04 24 29 30 40 00    movl   $0x403029,(%esp)
      4013d7:       83 c0 01                add    $0x1,%eax
      4013da:       88 44 24 5f             mov    %al,0x5f(%esp)
      4013de:       e8 3d 0a 00 00          call   401e20 <_printf>
      4013e3:       eb be                   jmp    4013a3 <_foo+0x13>


As you can see, there is no prologue code setting up the frame pointer, and ebp isn't set or used at all.

Later versions of Windows ship with a different version of msvcrt.dll (and longjmp) that doesn't assume the presence of a valid frame pointer, which explains why the crash occurs only on Win XP.

Figuring out the reason for the crash proved to be particularly trick, because frame pointer omission meant the debugger (Windbg) wasn't able to show any callstack information. Just letting the debugger stop on access violation only shows the offending function (msvcrt!_NLG_Notify) containing the read from ebp - no callstack. I eventually had to do a "depth first search" on the call graph to isolate the call to that function from longjmp :)

This has been found out before and fixed in newer versions of gcc (see here[https://sourceware.org/ml/gdb/2011-10/msg00065.html] and here[http://gcc.gnu.org/ml/gcc/2011-10/msg00329.html], but I only realized it after googling with very specific search terms :) 
