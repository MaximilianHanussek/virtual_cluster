resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "vuc-cloud-key"
  public_key = "${var.public_key}"
}

