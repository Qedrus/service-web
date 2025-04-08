variable "key_name" {
  description = "Nom de la paire de clés SSH"
  type        = string
  default     = "eks-keypair"
}

variable "public_key_path" {
  default = "~/.ssh/eks-keypair.pub"
}

variable "private_key_path" {
  default = "~/.ssh/eks-keypair"
}
