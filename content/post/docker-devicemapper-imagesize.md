---
title: "Docker - setting the default size of images with device mapper storage driver"
description: "How to set the default size of docker images"
tags: ["devops", "docker"]
date: "2014-06-24"
categories: ["software", "docker"]
---

Been playing around with docker (http://docker.io) for a while now to see if it can help create a one script setup for setting up the build environment for the avr8 toolchain. One pesky problem when using the device mapper storage driver (the default on RHEL) is that the created images/containers are small - only 10G. That isn't going to cut it for building the GNU toolchain - the gcc repo itself takes up 2.6G on my machine. Of course, mapping directories on the host would help, but I figured the more self contained the whole thing is, the better. 

Googling for a solution only turned up this page[http://jpetazzo.github.io/2014/01/29/docker-device-mapper-resize], but that isn't really practical without the ability to commit the enlarged container. So I decided to check out the source (oh the joy of open source software :)) from github[https://github.com/dotcloud/docker.git] to see how to get around this. Turns out it is already documented - the device mapper driver's README.md[https://github.com/dotcloud/docker/blob/master/daemon/graphdriver/devmapper/README.md] says passing dm.basesize=<size> should do the trick.

Had to delete the storage pool to get it to work though - I guess that's because all images are snapshotted off a base device that is created only once. And the --storage-opts option for the docker daemon is not supported on older versions of docker (<= 0.7 IIRC) - all the more reason to upgrade to 1.0.
