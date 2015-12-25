import time


rule all:
    input:
        time.strftime("images/archlinux_openstack_%Y-%m-%d_%H-%M.qcow2")


rule setup:
    output:
        "image-bootstrap/image-bootstrap"
    shell:
        "git submodule init && git submodule update"


rule generate_password:
    output:
        "images/{identifier}.txt"
    shell:
        "tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1 > {output}"


rule make_image:
    output:
        "images/{identifier}.tmp-qcow2"
    shell:
        "qemu-img create -f qcow2 {output} 2G && "
        "sudo modprobe nbd max_part=16 && "
        "sudo qemu-nbd -c /dev/nbd0 {output} && "
        "sudo partprobe /dev/nbd0"


rule bootstrap_image:
    input:
        script="image-bootstrap/image-bootstrap",
        password_file="images/{identifier}.txt",
        disk_image="images/{identifier}.tmp-qcow2"
    output:
        "images/{identifier}.qcow2"
    shell:
        "sudo {input.script} --hostname arch-host --password-file {input.password_file} "
        "--bootloader host-extlinux --scripts-chroot scripts/during_chroot --openstack arch /dev/nbd0 &&"
        "sudo qemu-nbd -d /dev/nbd0 &&"
        "mv {input.disk_image} {output} ||"
        "sudo qemu-nbd -d /dev/nbd0"