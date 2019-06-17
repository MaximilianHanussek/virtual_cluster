resource "openstack_blockstorage_volume_v2" "beeond_volume_master" {
  name 		= "${var.name_prefix}beeond_volume_master"
  size 		= "${var.beeond_disk_size}"
  volume_type 	= "${var.beeond_storage_backend}"
}

resource "openstack_blockstorage_volume_v2" "beeond_volume_compute" {
  count         = "${var.compute_node_count}"
  name          = "${var.name_prefix}beeond_volume_compute-${count.index}"
  size          = "${var.beeond_disk_size}"
  volume_type   = "${var.beeond_storage_backend}"
}


resource "openstack_compute_instance_v2" "master" {
  name            = "${var.name_prefix}master"
  flavor_name     = "${var.flavors["master"]}"
  image_id        = "${openstack_images_image_v2.vuc-image-master.id}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.security_groups}"
  network         = "${var.network}"

block_device {
    uuid                  = "${openstack_images_image_v2.vuc-image-master.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.beeond_volume_master.id}"
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
      timeout     = "2m"
    }
  }

  provisioner "file" {
    content = "${tls_private_key.internal_connection_key.private_key_pem}"
    destination = "~/.ssh/connection_key.pem"  
  
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "2m"
    }
  } 

  provisioner "remote-exec" {
    script = "public_key_to_authorized_key_file.sh"

    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "2m"
    }
  }
}



resource "openstack_compute_instance_v2" "compute" {
  count           = "${var.compute_node_count}"
  name            = "${var.name_prefix}compute-node-${count.index}"
  flavor_name     = "${var.flavors["compute"]}"
  image_id        = "${openstack_images_image_v2.vuc-image-compute.id}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.security_groups}"
  network         = "${var.network}"

block_device {
    uuid                  = "${openstack_images_image_v2.vuc-image-compute.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

block_device {
#    uuid                  = "${openstack_blockstorage_volume_v2.beeond_volume_compute.0.id}"
     uuid		  = "${count.index != "0" ? "${openstack_blockstorage_volume_v2.beeond_volume_compute.1.id}" : "${openstack_blockstorage_volume_v2.beeond_volume_compute.0.id}"}"
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
      timeout     = "2m"
    }
  }

  provisioner "file" {
    content     = "${tls_private_key.internal_connection_key.private_key_pem}"
    destination = "~/.ssh/connection_key.pem"
    
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "2m"
    }
  }
  
  provisioner "remote-exec" {
    script = "public_key_to_authorized_key_file.sh"
    
    connection {
      type        = "ssh"
      private_key = "${file(var.private_key_path)}"
      user        = "centos"
      timeout     = "2m"
    }
  }
}






