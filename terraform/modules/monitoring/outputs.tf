output "namespace" {
  description = "Namespace où le stack de monitoring a été déployé"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_admin_password" {
  description = "mdp de l'utilisateur admin de Grafana"
  value       = var.admin_password
  sensitive   = true
}

output "helm_release_name" {
  description = "Nom du release Helm"
  value       = helm_release.monitoring_stack.name
}

output "prometheus_url" {
  description = "URL interne du service Prometheus dans le cluster"
  value       = "http://${helm_release.monitoring_stack.name}-prometheus.${var.namespace}.svc.cluster.local"
}

output "grafana_url" {
  description = "URL interne du service Grafana dans le cluster"
  value       = "http://${helm_release.monitoring_stack.name}-grafana.${var.namespace}.svc.cluster.local"
}