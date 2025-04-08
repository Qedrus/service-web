variable "db_name" {
  description = "Nom de la base de données"
  type        = string
}

variable "db_username" {
  description = "Nom d'utilisateur de la base de données"
  type        = string
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "Nom du groupe de sous-réseaux pour la base de données"
  type        = string
}

variable "security_group_id" {
  description = "ID du Security Group pour la base de données"
  type        = string
}

variable "allowed_ips" {
  description = "Liste des IP autorisées pour l'accès"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Par défaut, autorise toutes les IPs
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}
