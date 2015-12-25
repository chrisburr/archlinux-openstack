#!/bin/bash
# python2-requests is a dependency of cloud-init
# https://bugs.archlinux.org/task/46909
pacman --noconfirm -S python2-requests
