##kiosk

resource "helm_release" "kiosk" {
  chart            = "kiosk"
  namespace        = "kiosk"
  create_namespace = "true"
  name             = "kiosk"
  version          = "0.2.11"
  repository       = "https://charts.devspace.sh/"
  atomic           = true
}