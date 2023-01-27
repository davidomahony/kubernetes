locals {
  environment_settings = {
    "dev" = {
      "env" : "dev",
      "dummy" : "value"
    }
    "prod" = {
      "env" : "prod",
      "dummy" : "value"
    }
  }
}

resource "kubernetes_config_map" "enviornment_settings" {
  depends_on = [
    kubernetes_namespace.namespace
  ]
  metadata {
    name      = "environment_settings"
    namespace = local.namespace
  }
  data = local.environment_settings[var.environment]
}
