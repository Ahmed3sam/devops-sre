resource "helm_release" "vault" {
  name             = "vault"
  namespace        = "tools"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.27.0"
  timeout          = 300
  atomic           = true
  create_namespace = true
  values = [
    <<YAML
ui:
  enabled: true
  serviceType: "LoadBalancer"
    YAML
  ]

}


resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "tools"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.18"
  timeout          = 300
  atomic           = true
  create_namespace = true

  values = [
    file("./values/argocd-values.yaml")
  ]
}


resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "tools"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "25.20.0"
  timeout          = 300
  atomic           = true
  create_namespace = true
  values = [
    <<YAML
server:    
  service:
    type: LoadBalancer
    YAML
  ]

}


resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "tools"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "7.3.8"
  timeout          = 300
  atomic           = true
  create_namespace = true
  values = [
    <<YAML
service:
  type: LoadBalancer
    YAML
  ]

}


