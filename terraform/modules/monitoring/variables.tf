variable "namespace" {
  description = "Nom du namespace où sera déployé le stack de monitoring"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Version du chart kube-prometheus-stack"
  type        = string
  default     = "45.6.0"
}

variable "admin_password" {
  description = "Mot de passe de l'utilisateur admin de Grafana"
  type        = string
  sensitive   = true
}

variable "release_name" {
  description = "Nom du release Helm"
  type        = string
  default     = "kube-prometheus-stack"
}

variable "repository" {
  description = "URL du dépôt Helm"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}