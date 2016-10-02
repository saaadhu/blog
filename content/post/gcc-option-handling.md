---
title: "GCC's command line option handling and arbitrary values"
description: "Getting free form argument values to command line options to work."
tags: ["toolchain", "gcc", "driver"]
date: "2016-10-02"
categories: ["software", "toolchain", "gccdev"]
---

Say you want to add your own command line option to the gcc driver. It's pretty
easy to do it as long as it is a number or a bitmask - just add an entry to your 
target's opt file, and gcc's option handling mechanism[https://gcc.gnu.org/onlinedocs/gccint/Option-file-format.html] 
takes cares of it all.

For example, this is how the avr target's mn-flash option is described in avr.opt[https://github.com/gcc-mirror/gcc/blob/master/gcc/config/avr/avr.opt]

    mn-flash=
    Target RejectNegative Joined Var(avr_n_flash) UInteger Init(-1)
    Set the number of 64 KiB flash segments.

When you build the compiler, a bunch of awk scripts (gcc/opt-*.awk) take this 
text and generate C code out of it (options.{h,c}). The generator typically 
adds your option to a struct, with the member name set to whatever text you 
gave inside Var, prefixed by a x_. So for the above example, you get

    struct xxx_options 
    {
      int x_avr_n_flash;
    }

It also generates a macro to map the actual name to the struct, like so

    #define avr_n_flash   xxx_options.x_avr_n_flash
    
You can then access avr_n_flash in your code - the option handling code will 
deal with everything else - arg parsing, error handling etc..

The option handling framework supports the typical types of command line 
options - numbers and strings. You can use it for handling boolean values, 
setting bits in a bitmap, or as plain numbers. mn-flash, for example, uses 
the arg value as an integer.

But what if your arg value isn't any of the above? What if you need to take 
a range (x-y), a bunch of comma separated values (x,y,z) or simply a bigger
numerical value than the host's integer size?

Enter the Defer option attribute. This option tells gcc to keep its hands off
attempting to parse this argument. All it does is pack the value(s) in a vector
and hand them over to you, to do as you please.

Here's an example from ia64.opt[https://github.com/gcc-mirror/gcc/blob/master/gcc/config/ia64/ia64.opt]

    mfixed-range=
    Target RejectNegative Joined Var(ia64_deferred_options) Defer
    Specify range of registers to make fixed

As you'd expect, the name inside Var becomes the name of the vector. You'd then
use the TARGET_OVERRIDE_HOOK to look inside the vector and do the actual handling.

The ia64 port does it like so


    unsigned int i;
    cl_deferred_option *opt;
    VEC(cl_deferred_option,heap) *vec
      = (VEC(cl_deferred_option,heap) *) ia64_deferred_options;

    FOR_EACH_VEC_ELT (cl_deferred_option, vec, i, opt)
      {
        switch (opt->opt_index)
        {
        case OPT_mfixed_range_:
          fix_range (opt->arg);
          break;

        default:
          gcc_unreachable ();
        }
      }
      
You loop over all the entries, look for a element with 
opt\_index ==  OPT\_youroption, read opt->arg and do whatever fancy thing
you want with it.

Think of it as an escape hatch provided by the option handling framework!
