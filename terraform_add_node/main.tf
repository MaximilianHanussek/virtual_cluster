data "openstack_images_image_v2" "vuc-image-compute" {
  name = "${var.vuc-image-compute}"
  most_recent = true
}

resource "openstack_blockstorage_volume_v2" "beeond_volume_compute" {
  name          = "${var.name_prefix}beeond_volume_compute-${file(var.next_node_number)}"
  size          = "${var.beeond_disk_size}"
  volume_type   = "${var.beeond_storage_backend}"
}


resource "openstack_compute_instance_v2" "compute" {
  name            = "${var.name_prefix}compute-node-${file(var.next_node_number)}"
  flavor_name     = "${var.flavors}"
  image_id        = "${data.openstack_images_image_v2.vuc-image-compute.id}"
  key_pair        = "${var.openstack_key_name}"
#  key_pair        = "${file(var.initial_cluster_connection_key_public)}"
  security_groups = "${var.security_groups}"
#  network         = "${var.network}"
  network {
    name = "${var.network}"
  }


block_device {
    uuid                  = "${data.openstack_images_image_v2.vuc-image-compute.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.beeond_volume_compute.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }
  
  provisioner "remote-exec" {
    script = "mount_cinder_volumes.sh"
    
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }

  provisioner "file" {
#    content     = "${tls_private_key.internal_connection_key.private_key_pem}"
    content     = "${file(var.initial_cluster_connection_key_private)}"
    destination = "~/.ssh/connection_key.pem"
    
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }
  
  provisioner "remote-exec" {
    script = "public_key_to_authorized_key_file.sh"
    
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }

  provisioner "file" {
    source = "../beeond"
    destination = "/home/centos/beeond"

    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }

  provisioner "file" {
    source = "../beegfs-ondemand-stoplocal"
    destination = "/home/centos/beegfs-ondemand-stoplocal"

    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/centos/beeond /opt/beegfs/sbin/beeond",
      "sudo mv /home/centos/beegfs-ondemand-stoplocal /opt/beegfs//lib/beegfs-ondemand-stoplocal",
      "sudo chmod 777 /opt/beegfs/sbin/beeond",
      "sudo chmod 777 /opt/beegfs/lib/beegfs-ondemand-stoplocal"
    ]

    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "5m"
    }
  }
}
