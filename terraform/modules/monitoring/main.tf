terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0" # Version plus récente pour meilleure gestion EKS
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0" # Support amélioré des charts complexes
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "monitoring_stack" {
  name       = var.release_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = var.repository
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  timeout    = 1200 # 20 minutes
  atomic     = true # Rollback automatique
  
  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  values = [
    <<-YAML
    grafana:
      enabled: true
      adminPassword: "${var.admin_password}"
      service:
        type: LoadBalancer
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      persistence:
        enabled: true
        storageClassName: "gp2"
        size: 10Gi

    prometheus:
      prometheusSpec:
        serviceMonitorSelectorNilUsesHelmValues: false
        storageSpec:
          volumeClaimTemplate:
            spec:
              storageClassName: "gp2"
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 50Gi
        resources:
          requests:
            memory: 2Gi
            cpu: 1

    alertmanager:
      alertmanagerSpec:
        storage:
          volumeClaimTemplate:
            spec:
              storageClassName: "gp2"
              accessModes: ["ReadWriteOnce"]
              resources:
                requests:
                  storage: 20Gi

    kubeEtcd:
      enabled: false

    kubeControllerManager:
      enabled: false

    kubeScheduler:
      enabled: false
    YAML
  ]
}