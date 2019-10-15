variable "beeond_disk_size" {
  default = 10
}

variable "beeond_storage_backend" {
  default = "quobyte_hdd"
}

variable "flavors" {
  default = "de.NBI small"
}


variable "vuc-image-compute" {
  default = "unicore_compute_centos_20190719"
}

variable "next_node_number" {
  default = "../next_node_number"
}


variable "openstack_key_name" {
  default = "maximilian-demo"
}

variable "initial_cluster_connection_key_private" {
  default = "../terraform/connection_key.pem"
}

variable "private_key_path" {
  default = "/home/mhanussek/Zertifikate/maximilian-demo.pem"
}

variable "name_prefix" {
  default = "unicore-"
}

variable "security_groups" {
  default = [
    "virtual-unicore-cluster-public"
  ]
}

variable "network" {
  default = "demo_external"
}
