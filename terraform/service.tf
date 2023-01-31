

resource "kubernetes_service" "api_service" {
  metadata {
    name = "${local.service_name}-service"
    labels = {
      app = "${local.service_name}-service"
      name = "${local.service_name}-service"
    }
  }
  spec {
    selector = {
      app = "${local.service_name}-service"
    }
    port{
        name = "http"
        value = 80
    }
    type = "ClusterIP"
  }
}