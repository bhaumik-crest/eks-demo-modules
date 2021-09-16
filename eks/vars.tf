variable "vpc_id" {
    description = "VPC id"
}

variable "private_subnets" {
    type = list(string)
}

variable "worker_one_id" {
  
}

variable "worker_two_id" {
  
}

variable "cluster_name" { 
    description = "EKS CLuster name"
}