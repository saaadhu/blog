---
title: "Installing 64 bit Windows 10 on VirtualBox headless"
description: "Tricky things to watch out for when installing 64 bit Windows 10 on VirtualBox headless"
tags: ["virtualbox", "windows"]
date: "2016-06-28"
categories: ["software", "virtualization"]
---

Wanted to try Windows 10's Windows On Linux subsystem to see if we can test mingw built toolchain binaries using the usual Dejagnu/expect/tcl testsuite runner. First step, of course, was to get my hands on a Windows 10 ISO. I didn't have a spare machine lying around, so I decided to try this on a VM.

I had a CentOS machine available that I could logon remotely, so I yum installed VirtualBox-5.0 after following the instructions at https://wiki.centos.org/HowTos/Virtualization/VirtualBox. I had a bit of trouble getting kernel module support working - had to install kernel-devel and update my repos before I was able to install it cleanly.

Following the instructions at https://www.virtualbox.org/manual/ch07.html to create a VM, I managed to create a Windows10 VM and start it with

     VBoxHeadless --startvm <VM Name> --vrde on
     
Only problem, the remote desktop client refused to connect - there was nothing running at port 3389.

Turns out you need the VirtualBox extension pack installed to have remote desktop support going. So downloading

     wget http://download.virtualbox.org/virtualbox/5.0.22/Oracle_VM_VirtualBox_Extension_Pack-5.0.22.vbox-extpack

and then installing it with
    
     VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.0.22.vbox-extpack
     
and then running VBoxHeadless again fixed that.

Unfortunately, the Windows installer then complained that it's not running on a 64 bit processor. I had enabled everything related to virtualization on the host machine's BIOS, so this was a nasty surprise.

After digging into the logs a little, I found that I'd created the machine with --ostype Windows10, when it should have been Windows10_64. Just changing the type in the .vbox file did not help, so I was wondering if I'd have to redo everything over. Fortunately, there is the longmode option - just doing
    
     VBoxManage modifyvm <vmname> --longmode on
     
fixed that for me. After that, it was all smooth sailing.
