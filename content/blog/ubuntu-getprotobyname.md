---
title: "getprotobyname and the default ubuntu:vivid Docker image"
description: "Resolving NULL return value from getprotobyname"
tags: ["development", "docker"]
date: "2015-08-01"
categories: ["software", "docker"]
---
Trying to setup a network server on a ubuntu:vivid docker image, I ran into a weird problem - the server would accept the TCP request and then drop the connection. After eliminating a bunch of possible causes (firewall, SELinux), I found that a simple python TCP server I cooked up worked just fine - it was just that particular network server program that was acting up. It worked perfectly fine on the Arch linux distribution running on my laptop though. Sigh.

Running the program under gdb showed that the program, after accepting a socker, was asserting getprotobyname("tcp") != NULL. In the container, that call was returning NULL, causing the program to drop the connection. Googling for the exact problem didn't really help, but there was one clue - one of the results said that getprotobyname usually consults /etc/protocols. Guess what, that file was missing in the container (and the original image).

Turns out that the [netbase](http://packages.ubuntu.com/vivid/netbase) package contains that file, and installing it fixed the problem right away. So if you run into the problem, you are only an "apt-get install netbase" away from fixing it.
