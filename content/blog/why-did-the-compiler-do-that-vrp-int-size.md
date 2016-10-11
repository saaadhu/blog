---
title: "Why did the compiler do that - the one with VRP and integer size"
description: "How VPR and avr's 16 bit integers make pr69941.c fail"
tags: ["toolchain", "gcc", "optimizations", "wdtcdt", "dejagnu"]
date: "2016-10-06"
categories: ["software", "toolchain", "gccdev", "compiler optimizations"]
---

Here's a simple program - it right shifts a signed int by 9 bits, 
truncates it to an unsigned char, and returns 1 or 0 after comparing 
the result with 0x74.

    $ cat test.c
    extern int e;
    int main() {
    unsigned char result = e >> 9; // result = 0x74;

    if ((int)result != 0x74)
      return 1;
    return 0;
    }
    
Let's compile this for the avr target, choosing to optimize for size.

    $ avr-gcc -mmcu=avr51 -Os test.c -S

Well, this can't be that complicated -  in the generated code, we wll 
probably see code for right shifting followed by a compare and branch.

    $ cat test.s
    main:
            ldi r24,lo8(1)
            ldi r25,0
            ret

All the code does is return 1 unconditionally - no comparison to 
be seen anywhere. That's all the code there is. 

Wat? Why did the compiler do that?

Let's dig in deeper. Is it the frontend/middle-end or the backend that is
doing this? Let's try dumping output from the final pass of the middle-end.

    $ avr-gcc -mmcu=avr51 -Os test.c -S -fdump-tree-optimized
    $ cat test.c.219t.optimized 

    ;; Function main (main, funcdef_no=0, decl_uid=1494, cgraph_uid=0, symbol_order=0) (executed once)

    main ()
    {
      <bb 2>:
      return 1;

    }

No code for the if statement there, so that rules out backend passes and the avr
target code. How do we find out which of the many front-end/middle-end passes
did this? 

Binary search (or git-bisect) style analysis is how. Let's dump output from all
the tree passes.

    $ avr-gcc -mmcu=avr51 -Os test.c -S -fdump-tree-all
    $ ls
    test.c                           test.c.034t.esra               test.c.094t.forwprop2   test.c.117t.isolate-paths  test.c.172t.thread3
    test.c.001t.tu                   test.c.035t.ealias             test.c.095t.objsz2      test.c.118t.phicprop1      test.c.173t.dom3
    test.c.002t.class                test.c.036t.fre1               test.c.096t.alias       test.c.119t.dse2           test.c.175t.thread4
    test.c.003t.original             test.c.037t.evrp               test.c.097t.retslot     test.c.120t.reassoc1       test.c.176t.vrp2
    test.c.004t.gimple               test.c.038t.mergephi1          test.c.098t.fre3        test.c.121t.dce3           test.c.177t.phicprop2
    test.c.006t.omplower             test.c.039t.dse1               test.c.099t.mergephi2   test.c.122t.forwprop3      test.c.178t.dse3
    test.c.007t.lower                test.c.040t.cddce1             test.c.100t.thread1     test.c.123t.phiopt2        test.c.179t.cddce2
    test.c.010t.eh                   test.c.041t.eipa_sra           test.c.101t.vrp1        test.c.124t.ccp3           test.c.180t.forwprop4
    test.c.011t.cfg                  test.c.042t.tailr1             test.c.103t.dce2        test.c.125t.sincos         test.c.181t.phiopt3
    test.c.012t.ompexp               test.c.043t.switchconv         test.c.104t.stdarg      test.c.126t.bswap          test.c.182t.fab1
    test.c.018t.fixup_cfg1           test.c.045t.profile_estimate   test.c.105t.cdce        test.c.127t.laddress       test.c.183t.widening_mul
    test.c.019t.ssa                  test.c.046t.local-pure-const1  test.c.107t.copyprop1   test.c.128t.lim2           test.c.184t.tailc
    test.c.021t.nothrow              test.c.047t.fnsplit            test.c.108t.ifcombine   test.c.129t.crited1        test.c.185t.dce7
    test.c.026t.fixup_cfg3           test.c.048t.release_ssa        test.c.109t.mergephi3   test.c.130t.pre            test.c.186t.crited2
    test.c.027t.inline_param1        test.c.049t.inline_param2      test.c.110t.phiopt1     test.c.131t.sink           test.c.188t.uncprop1
    test.c.028t.einline              test.c.086t.fixup_cfg4         test.c.111t.tailr2      test.c.135t.dce4           test.c.189t.local-pure-const2
    test.c.029t.early_optimizations  test.c.088t.oaccdevlow         test.c.112t.ch2         test.c.136t.fix_loops      test.c.218t.nrv
    test.c.030t.objsz1               test.c.090t.ccp2               test.c.113t.cplxlower1  test.c.162t.no_loop        test.c.219t.optimized
    test.c.031t.ccp1                 test.c.091t.cunrolli           test.c.114t.sra         test.c.165t.veclower21     test.c.300t.statistics
    test.c.032t.forwprop1            test.c.092t.backprop           test.c.115t.thread2     test.c.168t.reassoc2       testresults
    test.c.033t.ethread              test.c.093t.phiprop            test.c.116t.dom2        test.c.169t.slsr           test.s
    
Let's pick an early pass (test.c.003t.original) dump and see if it has code for the if statement.

    $ cat *.original

    {
      unsigned char result = (unsigned char) (e >> 9);

        unsigned char result = (unsigned char) (e >> 9);
      if (result != 116)
        {
          return 1;
        }
      return 0;
    }
    return 0;

It clearly is there, so let's pick a later pass that runs half way done the line, 
say test.c.116t.dom2, because 220 divided by 2 is 116 in 
hexadecimal. Just kidding!

    $ cat *.dom2

    main ()
    {
      unsigned char result;

      <bb 2>:
      return 1;

    }

Gone now, so let's pick one that runs half way between between 003t.original and
116t.dom2. Rinse and repeat, and eventually we find that test.c.101t.vrp1 removes it.

    $ cat *.vrp1

    Value ranges after VRP:

    e.0_1: VARYING
    _2: [-64, 63]
    _3: [1, 1]
    result_5: ~[64, 191]


    Folding predicate result_5 != 116 to 1
    Removing basic block 3
    Merging blocks 2 and 4
    main ()
    {
      unsigned char result;
      int e.0_1;
      int _2;

      <bb 2>:
      e.0_1 = e;
      _2 = e.0_1 >> 9;
      result_5 = (unsigned char) _2;
      return 1;

    }

VRP (value range propagation) pass generates this dump, and you can clearly see
"Folding predicate result_5 != 116 to 1" there. It somehow figured out
the comparison will always succeed and optimized it away.

But why did it do that?

Again, the dump explains why - VRP also says

    result_5: ~[64, 191]

VRP figured out result_5 *cannot* take values between [64, 191] (both inclusive).
The tilde represents an anti-range; as the name implies, it's the range of values
a variable cannot take. 0x74 (116 decimal) is in the anti-range, so VRP rightly 
concluded that the if statement is always true. 

How did the VRP pass deduce the anti-range though?

Well, we could dig into the code (gcc/gcc/tree-vrp.c), or we could try to reason
it out ourselves. Let's try the latter - if we're stuck, we can always fall back
to the source.

Let's see, the code rights shifts a signed integer (e) by 9 bits and assigns it to
and unsigned char (result). A signed integer is 16 bits on the AVR. If you right 
shift that by 9 bits, you have to end up with one of the below patterns for the
integer, because of the way sign
extension works.

    non-negative int  0000 0000 00xx xxxx
    negative int      1111 1111 11xx xxxx

If you had a non-negative integer, the top 9 bits will be zeros, because
the MSB would have been zero before shifting. For a negative
integer, the MSB would have been one, so the top 9 bits will end up as ones. Ok,
we've made some headway - what could we deduce further?

Well, the C code truncates the integer to an unsigned char before promoting it
back as an int, so we really only need to look at the lower 8 bits.

    non-negative int   00xx xxxx
    negative int       11xx xxxx

If it must be one those two bit patterns, then it cannot be the bit patterns 01xx
xxxx and 10xx xxxx, for any combination of 0's and 1's for x. Let's try 
substituting all zeros and all ones to find out what range those bit 
patterns represent.

    0100 0000 = 0x40 = 64
    1011 1111 = 0xBF = 191
    
Bingo - that is exactly the same range that the VRP pass deduced. The VRP pass
is right, that variable can never hold the value 0x74. so it is perfectly ok 
to fold the conditional and eventually delete the if statement.

Whew, now we know why the compiler did that! 

All this came from a testcase (gcc/gcc/testsuite/gcc.dg/torture/pr69941.c) in
the gcc testsuite that fails only for the avr target.

    $ cat 
    /* { dg-do run } */

    int a = 0;
    int b = 0;
    int c = 0;
    int e = 0;
    int f = 0;
    int *g = &e;

    int fn1() { return b ? a : b; }

    int main() {
      int h = fn1() <= 0x8000000000000000ULL; // h = 1;

      int k = f; // k = 0;

      long i = h ? k : k / h; // i = 0;

      long l = (unsigned short)(i - 0x1800); // l = 0xe800

      i = l ? l : c; // i = 0xe800;

      *g = i; // *g = 0xe800; e = 0xe800;

      unsigned char result = e >> 9; // result = 0x74;

      if ((int)result != 0x74)
        __builtin_abort ();
      return 0;
    }
    
The test compiles just fine. When run, the code calls abort, gcc testsuite speak 
for execution failure. We now know why - the last few lines of the testcase are
the same as the code we were looking.

The code generated for that part looks like ths.

    .L9:
            lds r30,g
            lds r31,g+1
            std Z+1,r25
            st Z,r24
            call abort

Five lines down from .L9, there's the unconditional call to abort.

Simple to fix though, all we have to do is ensure the integers involved 
are more than 16 bits wide. That is what
[this](https://github.com/gcc-mirror/gcc/commit/d204444eb12ee811bddf972c6bf31ecb53322491)
commit does.
