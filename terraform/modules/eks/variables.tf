variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnets" {
  description = "Subnets IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Version of the EKS Cluster"
  type        = string
}

variable "node_instance_type" {
  description = "Type of instance to be used for EKS nodes"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for the node group"
  type        = number
}

variable "max_capacity" {
  description = "Maximum capacity for the node group"
  type        = number
}

variable "min_capacity" {
  description = "Minimum capacity for the node group"
  type        = number
}
variable "keypair_key_name" {
  description = "Nom de la clé SSH pour EC2"
  type        = string
}
