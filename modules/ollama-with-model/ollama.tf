resource "kubernetes_deployment" "ollama" {
  metadata {
    name = var.deployment_name
    labels = {
      app = "ollama-${var.model_size}"
    }
  }

  spec {
    replicas = var.replicas

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "ollama-${var.model_size}"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "ollama-${var.model_size}"
          exposes = "nvitop"
        }
      }

      spec {
        runtime_class_name = "nvidia"

        volume {
          name = "dev"
          host_path {
            path = "/dev"
          }
        }

        container {
          name = "ollama-otel-gpu-collector"
          image = "sylweklewan/ollama-with-model:latest"
          image_pull_policy = "Always"

          volume_mount {
              name      = "dev"
              mount_path = "/dev"
          }

          port {
            container_port = 11434
          }

          env {
             name = "PASS_DEVICE_SPECS"
             value = "true"
           }

          env {
             name = "MODEL_NAME"
             value = var.model_name
          }

          resources {
             limits = var.resource_limits
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ollama_service_np" {
  metadata {
    name = "ollama-svc-${var.model_size}"
  }

  spec {
    selector = {
      app = kubernetes_deployment.ollama.metadata[0].labels.app
    }

    port {
      port        = 11434
      target_port = 11434
      node_port   = var.port_to_access
    }

    type = "NodePort"
  }
}
