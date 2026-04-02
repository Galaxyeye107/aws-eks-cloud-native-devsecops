# 1. Namespace dành riêng cho Observability
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# 2. Cài đặt Prometheus & Grafana (Kube-Prometheus-Stack)
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Tự động hóa việc tạo Admin Password cho Grafana
  set = [
    {
      name  = "grafana.adminPassword"
      value = "admin123" # Bạn nên dùng biến bí mật trong thực tế
    },
    {
      name  = "grafana.ingress.enabled"
      value = "true"
    }
  ]

  depends_on = [module.eks]
}