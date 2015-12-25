#!/bin/bash
pacman -Syy
pacman --noconfirm -S wget zsh

wget https://gist.githubusercontent.com/chrisburr/3e3a5f34def0a5a9f5d7/raw/2cd497f966f4855628e9158fa6bdc11cf58a153d/cloud.cfg
chown --reference=/etc/cloud/cloud.cfg cloud.cf
chmod --reference=/etc/cloud/cloud.cfg cloud.cf
mv cloud.cfg /etc/cloud/cloud.cfg
