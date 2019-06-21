variable "beeond_disk_size" {
  default = 10
}

variable "beeond_storage_backend" {
  default = "quobyte_hdd"
}

variable "flavors" {
  type = "map"
  default = {
    "master" = "de.NBI small disc"
    "compute" = "de.NBI small disc"
  }
}

variable "compute_node_count" {
  default = 2
}

variable "image_master" {
  type = "map"
  default = {
    "name" = "unicore_master_centos"
    "image_source_url" = "https://s3.denbi.uni-tuebingen.de/max/unicore_master_centos.qcow2"
    "container_format" = "bare"
    "disk_format" = "qcow2"
   }
}

variable "image_compute" {
  type = "map"
  default = {
    "name" = "unicore_compute_centos"
    "image_source_url" = "https://s3.denbi.uni-tuebingen.de/max/unicore_compute_centos.qcow2"
    "container_format" = "bare"
    "disk_format" = "qcow2"
   }
}


variable "openstack_key_name" {
  default = "maximilian-demo"
}

/*variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGCoCJq3YLZSSIQWp9E8lHoS2Uyls66498ZcEqxJIGEP6gu+W9AAw7x0FBGlvnoHAw1wEsMbcihrTVLlU0r2VKtNVdvW26ACB01Y663IsiqrgtWChmLEWxOJE/8k3F+ZQ8aIjfYWr4O33IBItr32OP3lka/3wrLqOYh27JUcc3hvo+4KNdYoEso/P2bvvrL3jU/obB5iCtpI3QHpnA3fEHCuLK6A0J13cedcNJTWnm1O8aLo0NPdimqB4I82e1WfdflabJCVQjuWjA224zNakNdxa7T11aQJjJWKWLNL5nKrM+sjeUpcKzNeMDTIrPQpF/mqqkEM/sRgDKPgYZ/uqf"
}*/

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

