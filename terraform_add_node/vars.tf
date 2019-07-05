variable "beeond_disk_size" {
  default = 10
}

variable "beeond_storage_backend" {
  default = "quobyte_hdd"
}

variable "flavors" {
  default = "de.NBI small"
}


variable "image_compute" {
  default = "unicore_compute_centos_20190701_orig"
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
      name = "denbi_uni_tuebingen_external"
    },
  ]
}

