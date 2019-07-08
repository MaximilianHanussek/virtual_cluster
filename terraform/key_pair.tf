resource "tls_private_key" "internal_connection_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "internal_connection_key_file" {
  content  = "${tls_private_key.internal_connection_key.private_key_pem}"
  filename = "${path.module}/connection_key.pem"
}

resource "local_file" "internal_connection_key_public_file" {
  content  = "${tls_private_key.internal_connection_key.public_key_openssh}"
  filename = "${path.module}/connection_key_public.pem"
}

