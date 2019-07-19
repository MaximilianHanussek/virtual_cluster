variable "beeond_disk_size" {
  default = 10
}

variable "beeond_storage_backend" {
  default = "quobyte_hdd"
}

variable "flavors" {
  type = "map"
  default = {
    "master" = "de.NBI small"
    "compute" = "de.NBI small"
  }
}

variable "compute_node_count" {
  default = 2
}

variable "image_master" {
  type = "map"
  default = {
    "name" = "unicore_master_centos_20190712"
    "image_source_url" = "https://s3.denbi.uni-tuebingen.de/max/unicore_master_centos_20190712.qcow2"
    "container_format" = "bare"
    "disk_format" = "qcow2"
   }
}

variable "image_compute" {
  type = "map"
  default = {
    "name" = "unicore_compute_centos_20190719"
    "image_source_url" = "https://s3.denbi.uni-tuebingen.de/max/unicore_compute_centos_20190719.qcow2"
    "container_format" = "bare"
    "disk_format" = "qcow2"
   }
}


variable "openstack_key_name" {
  default = "maximilian-demo"
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
  default = [
    {
      name = "demo_external"
    },
  ]
}

