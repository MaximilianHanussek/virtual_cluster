/*resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "vuc-cloud-key"
  public_key = "${var.public_key}"
}*/

resource "tls_private_key" "internal_connection_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/*resource "local_file" "connection_key" {
    content     = "${tls_private_key.internal_connection_key.private_key_pem}"
    filename = "${path.module}/connection_key.pem"
}*/

