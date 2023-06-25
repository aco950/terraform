terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
            version = "0.7.0"
        }
    }
}

provider "libvirt" {
    # Configuration options go here.
    uri = "qemu:///system"
}

