variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_id" {
  description = "ID du sous-réseau public pour la NAT Gateway"
  type        = string
  default     = "" # Laisse vide ou donne une valeur par défaut si tu veux la spécifier
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

