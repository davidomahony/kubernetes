
resource "kubernetes_deployment" "api_deployment" {
  metadata {
    name = "${local.service_name}-deployment"
    labels = {
      app = "${local.service_name}-deployment"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "${local.service_name}-service"
        name = "${local.service_name}-service"
      }
    }

    template {
      metadata {
        labels = {
          name = "${local.service_name}-deployment"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}