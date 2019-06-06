resource "openstack_images_image_v2" "vuc-image-master" {
  name   = "${var.image_master["name"]}"
  image_source_url = "${var.image_master["image_source_url"]}"
  container_format = "${var.image_master["container_format"]}"
  disk_format = "${var.image_master["disk_format"]}"
}

resource "openstack_images_image_v2" "vuc-image-compute" {
  name   = "${var.image_compute["name"]}"
  image_source_url = "${var.image_compute["image_source_url"]}"
  container_format = "${var.image_compute["container_format"]}"
  disk_format = "${var.image_compute["disk_format"]}"
}
