resource "tls_private_key" "internal_connection_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
