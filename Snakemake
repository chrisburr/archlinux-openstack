rule all:
    input:
        "images/archlinux_openstack.qcow2"

rule setup:
    output:
        "image-bootstrap/image-bootstrap"
    shell:
        "git submodule init && git submodule update"

rule generate_password:
    output:
        "images/archlinux_openstack_password.txt"

rule make_image:
    output:
        "images/archlinux_openstack_tmp.qcow2"
    shell:
        "qemu-img create -f qcow2 {output} 2G && "
        "sudo modprobe nbd max_part=16 && "
        "sudo qemu-nbd -c /dev/nbd0 {output} && "
        "sudo partprobe /dev/nbd0"

rule bootstrap_image:
    input:
        SCRIPT = "image-bootstrap/image-bootstrap"
        PASSWORD_FILE = "images/archlinux_openstack_password.txt"
        DISK_IMAGE = "images/archlinux_openstack_tmp.qcow2"
    output:
        "archlinux_openstack.qcow2"
    shell:
        "sudo {SCRIPT} --hostname arch-host --password-file {PASSWORD_FILE} "
        "--bootloader host-extlinux --scripts-chroot scripts/during_chroot --openstack arch /dev/nbd0 &&"
        "sudo qemu-nbd -d /dev/nbd0 &&"
        "mv {DISK_IMAGE} {output} ||"
        "sudo qemu-nbd -d /dev/nbd0"