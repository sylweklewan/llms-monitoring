resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = "prometheus-config"
    namespace = "default"
  }

  data = {
    "prometheus.yml" = file("${path.module}/prometheus.yaml")
  }
}

resource "kubernetes_deployment" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "default"
    labels = {
      app = "prometheus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        container {
          name  = "prometheus"
          image = "prom/prometheus:latest"

          args = [
            "--config.file=/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path=/prometheus/"
          ]

          port {
            container_port = 9090
          }

          volume_mount {
            mount_path = "/etc/prometheus"
            name       = "prometheus-config"
          }

          volume_mount {
            mount_path = "/prometheus"
            name       = "prometheus-storage"
          }
        }

        volume {
          name = "prometheus-config"

          config_map {
            name = kubernetes_config_map.prometheus_config.metadata[0].name
          }
        }

        volume {
          name = "prometheus-storage"

          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "prometheus_svc" {
  metadata {
    name      = "prometheus"
    namespace = "default"
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      name        = "http"
      port        = 9090
      target_port = 9090
      node_port = var.node_port_to_access_prometheus
    }

    type = "NodePort"
  }
}



