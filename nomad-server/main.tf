resource "libvirt_volume" "root_vol" {
    count  = var.vm_count
    name   = "root_vol_${var.service_name}-${count.index + 1}.qcow2"
    pool   = var.vm_pool
    source = "/data/templates/${var.service_name}/${var.vm_source}.qcow2"
    format = "qcow2"
}

data "template_file" "user_data" {
    template = "${file("${path.module}/user_data.cfg")}"
}

data "template_file" "meta_data" {
    count    = var.vm_count
    template = "${file("${path.module}/meta_data.cfg")}"
    vars     = {
        address  = "10.0.0.3${count.index + 1}"
        hostname = "${var.service_name}-${count.index + 1}"
    }
}

resource "libvirt_cloudinit_disk" "commoninit" {
    count     = var.vm_count
    name      = "commoninit_${var.service_name}-${count.index + 1}.iso"
    user_data = data.template_file.user_data.rendered 

    # You need '[count.index]' since you defined a 'count' above in 
    # template_file.meta_data.
    meta_data = data.template_file.meta_data[count.index].rendered 

    pool      = var.vm_pool
}

resource "libvirt_domain" "nomad-server" {
    count     = var.vm_count
    name      = "${var.service_name}-${count.index + 1}"
    memory    = "1024"
    vcpu      = 2
    cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

    network_interface {
        network_name = "default"
    }

    disk {
        volume_id = libvirt_volume.root_vol[count.index].id
    }

    console {
        type        = "pty"
        target_type = "serial"
        target_port = "0"
    }
}

