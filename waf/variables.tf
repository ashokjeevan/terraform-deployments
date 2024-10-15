variable "ec2_instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_pair_name" {
    type = string
    default = "may2024"
}

variable "root_volume_size" {
    type = number
    default = 8
}

variable "my_private_ip" {
    type    = string
    default = ""
}