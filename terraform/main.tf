resource "openstack_compute_instance_v2" "master" {
  name            = "${var.name_prefix}master"
  flavor_name     = "${var.flavors["master"]}"
  image_id        = "${openstack_images_image_v2.vuc-image-master.id}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.security_groups}"
  network         = "${var.network}"
}

resource "openstack_compute_instance_v2" "compute" {
  count           = "${var.compute_node_count}"
  name            = "${var.name_prefix}compute-node-${count.index}"
  flavor_name     = "${var.flavors["compute"]}"
  image_id        = "${openstack_images_image_v2.vuc-image-compute.id}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.security_groups}"
  network         = "${var.network}"
}
