---
title: "GCC commits and patches"
tags: ["toolchain", "gcc", "binutils", "avr"]
date: "Thu Oct 20 10:00:01 UTC 2016"
categories: ["software", "toolchain"]
---
# Recent GCC commits
  [Return earlier if not effective_target_int32](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=7c57132aa809f75c61321ff786b58b15c945f460)

  [Fix gcc.dg/tree-ssa/pr59597.c failure for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=aec336e9a675d84edc03260e5999eb46dfa05b28)

  [Fix pr69941.c test failure for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=d204444eb12ee811bddf972c6bf31ecb53322491)

  [Fix failing gcc.target/avr/torture/builtins_error.c](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=4092cccfea9dd3e5210cc9ca221b1c31a4be84ad)

  [Fix bogus test failure for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=2e0bcd964c73da2188d7ac68f563035fd78dad05)

  [Provide right LDD offset bound in avr_address_cost](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=c1e3c76cb344503c869eeaac153622a50fdbd2b2)

  [Make integer size explicit](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=b5b88e7aa2ffc68211b169be959713ab83175859)

  [Fix testsuite failure for avr target](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=0665113b84575606d76bb7355adad071e9c79aa6)

  [Skip Wno-frame-address test for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=8925068a70df402d9694c998f8aeb75c858df2a9)

  [Fix more bogus testsuite failures for avr.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=1c02615cb22c38bd5529b1e236603324b9ae8553)

  [Fix bogus testsuite failures for avr.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=2fb84e50aa3765f550f0158eb9ab2f5243fbca1c)

  [Skip tests that assume 4 byte alignment for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=70fa7158d2469bbc09004b7c1d8d4987ee84499c)

  [Fix PR 71873 - ICE in push_reload](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=5186407c975ccaf3cc5d035a63fde9e007ab8adf)

  [Fix tests that break unnecessarily for avr.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=52e3c0e8b09af135fdaeeda2f53c19eea24b50cd)

  [Use __{U,}INTPTR_TYPE__ to avoid including stdint.h](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=69a499fa9b59da2cffb1427f79c8dcbb6fadf4b3)

  [Fix tests for targets with sizeof(int) != 32.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=1660595b07f5f618405c23a11af6160eef5b23e2)

  [Fix failing test for targets with sizeof(int) != 4.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=1697df0958aa625e2bb286459f068c65eca3ba7c)

  [Fix some bogus testsuite failures for avr.](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=2bbae5b90e80054fb6ebf6e642cdde3bd4c51b7a)

  [Fix PR target/50739](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=19aea164d2e99c8af93d1ca181b220e685cecde9)

  [Mark some more tests as UNSUPPORTED for avr](https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=faeffe493be6fb9c3ab298ec88a15844d4089b84)

# GCC Patches
  [[testsuite] Fix sso.exp not calling torture-finish for avr](http://patchwork.ozlabs.org/patch/683661/)

  [Backport fix for PR 52085 to gcc-5-branch?](http://patchwork.ozlabs.org/patch/682842/)

  [[reload,tentative,PR,71627] Tweak conditions in find_valid_class_1](http://patchwork.ozlabs.org/patch/681633/)

  [[testsuite] Fix gcc.g/tree-ssa/pr59597.c failure for avr](http://patchwork.ozlabs.org/patch/680680/)

  [[testsuite] Fix pr69941.c test failure for avr](http://patchwork.ozlabs.org/patch/678551/)

  [[testsuite] Add ffat-lto-objects to gcc.target/avr/torture/builtins_error.c](http://patchwork.ozlabs.org/patch/677702/)

  [[testsuite] Require int32plus for builtin-sprintf-warn-1.c](http://patchwork.ozlabs.org/patch/675519/)

  [Backport fix for PR 65210 to gcc-5-branch](http://patchwork.ozlabs.org/patch/673365/)

  [[avr] Provide correct LD offset bound in avr_address_cost](http://patchwork.ozlabs.org/patch/673127/)

  [[testsuite] Make pr64130.c pass for avr](http://patchwork.ozlabs.org/patch/672593/)

  [[reload,tentative,PR,71627] Tweak conditions in find_valid_class_1](http://patchwork.ozlabs.org/patch/671081/)

  [[testsuite] Require int32plus for pr70421.c](http://patchwork.ozlabs.org/patch/670823/)

  [[testsuite,avr] Skip gcc.dg/Wno-frame-address.c for avr](http://patchwork.ozlabs.org/patch/666501/)

  [[testsuite] Fix more bogus failures for avr](http://patchwork.ozlabs.org/patch/664893/)

  [[testsuite] Fix more bogus test failures for avr](http://patchwork.ozlabs.org/patch/662166/)

  [[testsuite] Skip tests that expect 4 byte alignment for avr](http://patchwork.ozlabs.org/patch/658094/)

  [[tentative,reload] Make push_reload work with more types of subregs?](http://patchwork.ozlabs.org/patch/657688/)

  [[tentative,reload] Make push_reload work with more types of subregs?](http://patchwork.ozlabs.org/patch/656799/)

  [[wwwdocs] Add caveat for AVR port](http://patchwork.ozlabs.org/patch/656609/)

  [[testsuite] Fix some more bogus failures for avr](http://patchwork.ozlabs.org/patch/655367/)

  [[tentative,reload] Make push_reload work with more types of subregs?](http://patchwork.ozlabs.org/patch/653619/)

  [[testuite,committed] Fix some more tests that fail for non 32-bit int targets](http://patchwork.ozlabs.org/patch/652629/)

  [[testuite,committed] Fix some more tests that fail for non 32-bit int targets](http://patchwork.ozlabs.org/patch/652242/)

  [[testsuite,tentative] Explicitly disable pointer &amp;lt;-&amp;gt; int cast warnings for avr?](http://patchwork.ozlabs.org/patch/650564/)

  [[testsuite,committed] Fix gcc.dg/params/blocksort-part.c for non 32-bit int targets](http://patchwork.ozlabs.org/patch/650194/)

  [[testsuite] Fix some bogus testsuite failures for avr](http://patchwork.ozlabs.org/patch/647877/)

  [[avr] Fix PR 50739 - nameless error with -fmerge-all-constants](http://patchwork.ozlabs.org/patch/644464/)

  [[testsuite] Mark some more tests as UNSUPPORTED for avr](http://patchwork.ozlabs.org/patch/637879/)

  [MAINTAINERS (Write After Approval): Add myself](http://patchwork.ozlabs.org/patch/637477/)

  [[avr] Fix PR 71151](http://patchwork.ozlabs.org/patch/636242/)

  [[testsuite] Skip some more tests for targets with int size &amp;lt; 32](http://patchwork.ozlabs.org/patch/632239/)

  [[avr] Fix broken stack-usage-1.c test](http://patchwork.ozlabs.org/patch/632176/)

  [[avr] Fix PR 71151](http://patchwork.ozlabs.org/patch/629848/)

  [[testsuite] Make some more tests xfail/pass/unsupported for avr](http://patchwork.ozlabs.org/patch/626190/)

  [[avr] Include INCOMING_FRAME_SP_OFFSET when printing stack usage](http://patchwork.ozlabs.org/patch/622058/)

  [Fix PR 60040](http://patchwork.ozlabs.org/patch/616063/)

  [Fix PR 60040](http://patchwork.ozlabs.org/patch/616028/)

  [Fix PR 60040](http://patchwork.ozlabs.org/patch/610961/)

  [Fix PR 60040](http://patchwork.ozlabs.org/patch/607377/)

  [[testsuite] Require int32plus and scheduling support for some tests](http://patchwork.ozlabs.org/patch/605855/)

  [[testsuite] Skip testcase for avr](http://patchwork.ozlabs.org/patch/598569/)

  [[testsuite] Skip testcase for avr](http://patchwork.ozlabs.org/patch/598389/)

  [[avr] Fix multiple ICE fallout of PR 69764](http://patchwork.ozlabs.org/patch/595789/)

  [[testsuite] Require int32 target support in sso tests](http://patchwork.ozlabs.org/patch/578924/)

  [[avr] Restore default value of PARAM_ALLOW_STORE_DATA_RACES to 1](http://patchwork.ozlabs.org/patch/576529/)

  [[RFC,ARM,7/8] ARMv8-M Security Extension&amp;#39;s cmse_nonsecure_call: use __gnu_cmse_nonsecure_call]](http://patchwork.ozlabs.org/patch/569033/)

  [[avr] Provide correct memory move costs](http://patchwork.ozlabs.org/patch/557328/)

  [[vrp] Allow VRP type conversion folding only for widenings upto word mode](http://patchwork.ozlabs.org/patch/546324/)

  [[vrp] Allow VRP type conversion folding only for widenings upto word mode](http://patchwork.ozlabs.org/patch/545759/)

  [[vrp] Allow VRP type conversion folding only for widenings upto word mode](http://patchwork.ozlabs.org/patch/544773/)

  [[vrp] Allow VRP type conversion folding only for widenings upto word mode](http://patchwork.ozlabs.org/patch/544739/)

  [[avr] Fix PR 67839 - bit addressable instructions generated for out of range addresses](http://patchwork.ozlabs.org/patch/526257/)

  [[testsuite] Skip addr_equal-1 if target keeps null pointer checks](http://patchwork.ozlabs.org/patch/523259/)

  [[avr] Fix PR65210](http://patchwork.ozlabs.org/patch/513338/)

  [[avr] Fix PR 65657 - read from __memx address space tramples arguments to function call](http://patchwork.ozlabs.org/patch/461719/)

  [[dwarf,RFC] Emitting per-function dwarf info](http://patchwork.ozlabs.org/patch/459916/)

  [[regcprop] Tentative fix for PR 64331](http://patchwork.ozlabs.org/patch/421924/)

  [[avr] Add device name to cpp_builtins](http://patchwork.ozlabs.org/patch/374683/)

  [[avr] Add device name to cpp_builtins](http://patchwork.ozlabs.org/patch/372839/)

  [Fix address space computation in expand_debug_expr](http://patchwork.ozlabs.org/patch/356334/)

  [Fix address space computation in expand_debug_expr](http://patchwork.ozlabs.org/patch/356084/)

  [[avr] Propagate -mrelax gcc driver flag to assembler](http://patchwork.ozlabs.org/patch/349085/)

  [[avr] Fix PR60991](http://patchwork.ozlabs.org/patch/347948/)

  [[avr] Propagate -mrelax gcc driver flag to assembler](http://patchwork.ozlabs.org/patch/340262/)

  [[avr] Propagate -mrelax gcc driver flag to assembler](http://patchwork.ozlabs.org/patch/338606/)

  [[avr] Remove atxmega16x1 from device list](http://patchwork.ozlabs.org/patch/325742/)

  [[Testsuite] Skip torture/pr60183.c for AVR target](http://patchwork.ozlabs.org/patch/320940/)

  [Fix broken build for AVR and SPU targets](http://patchwork.ozlabs.org/patch/319570/)

  [[testsuite] Require scheduling support in gcc.dg/superblock.c](http://patchwork.ozlabs.org/patch/288190/)

  [[avr] Emit diagnostics if -f{pic,PIC,pie,PIE} or -shared is passed](http://patchwork.ozlabs.org/patch/288178/)

  [Fix infinite loop/crash if array initializer index equals max value](http://patchwork.ozlabs.org/patch/272622/)

  [Fix infinite loop/crash if array initializer index equals max value](http://patchwork.ozlabs.org/patch/269182/)

  [[testsuite] Require scheduling support for test that uses -fschedule-insns](http://patchwork.ozlabs.org/patch/240757/)

  [[testsuite] Add -gdwarf to debug/dwarf2 testcases (Take 2)](http://patchwork.ozlabs.org/patch/240370/)

  [Emit error for negative _Alignas alignment values](http://patchwork.ozlabs.org/patch/239403/)

  [[Ping,testsuite] Add -gdwarf to dg-options in debug/dwarf2 testcases](http://patchwork.ozlabs.org/patch/237670/)

  [[testsuite] Add -gdwarf to dg-options in debug/dwarf2 testcases](http://patchwork.ozlabs.org/patch/235674/)

  [Add -gdwarf option to make gcc generate DWARF with the default version](http://patchwork.ozlabs.org/patch/235606/)

  [Add -gdwarf option to make gcc generate DWARF with the default version](http://patchwork.ozlabs.org/patch/235394/)

  [Emit error for negative _Alignas alignment values](http://patchwork.ozlabs.org/patch/233465/)

  [Emitting correct DWARF location descriptor for multi-reg frame pointer](http://patchwork.ozlabs.org/patch/203572/)

  [[Ping] Allow dg-skip-if to use compiler flags specified through set_board_info cflags](http://patchwork.ozlabs.org/patch/184628/)

  [Allow dg-skip-if to use compiler flags specified through set_board_info cflags](http://patchwork.ozlabs.org/patch/176697/)

