variable "db_allocated_storage" {
    type = number
    default = 20
}
variable "db_instance_type" {
    type = string
    default = "db.t3.micro"
}

variable "db_username" {
    type = string
 default = "wordpress_admin"
}

variable "db_password" {
    type = string
    default = "A321Pa55#"
    sensitive = true
}

variable "db_name" {
    type = string
    default = "wordpressdb"
}

variable "db_engine" {
  type = string
  default = "mysql"
}

variable "db_engine_version" {
  type = string
  default = "5.7"
}

variable "db_port" {
    type = string
    default = "3306"
}

variable "my_ip" {}

variable "key_pair_name" {}

variable "root_volume_size" {}

variable "ec2_instance_type" {}