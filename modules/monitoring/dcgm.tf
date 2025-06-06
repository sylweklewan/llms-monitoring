resource "kubernetes_config_map" "dcgm_metrics_cm" {
  metadata {
    name      = "dcgm-metrics-cm"
    namespace = "default"
  }

  data = {
    "default-counters.csv" = <<EOT
# GPU Utilization
      DCGM_FI_DEV_POWER_USAGE, gauge, Power draw (in W).
      DCGM_FI_DEV_FB_FREE, gauge, Framebuffer memory free (in MiB).
      DCGM_FI_DEV_FB_USED, gauge, Framebuffer memory used (in MiB).
EOT
  }
}

resource "kubernetes_daemonset" "dcgm_exporter_ds" {
  metadata {
    name      = "dcgm-exporter-ds"
    namespace = "default"
    labels = {
      app = "dcgm-exporter"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "dcgm-exporter"
      }
    }

    template {
      metadata {
        labels = {
          app = "dcgm-exporter"
        }
      }

      spec {
        runtime_class_name = "nvidia"
        toleration {
            key      = "nvidia.com/gpu"
            operator = "Exists"
            effect   = "NoSchedule"
        }

        container {
            name  = "dcgm-exporter"
            image = "nvcr.io/nvidia/k8s/dcgm-exporter:4.2.3-4.1.1-ubuntu22.04"

            port {
                container_port = 9400
                name           = "metrics"
            }

            volume_mount {
                name       = "pod-gpu-resources"
                mount_path = "/var/lib/kubelet/pod-resources"
                read_only  = true
            }

            volume_mount {
                name       = "metrics-config"
                mount_path = "/etc/dcgm-exporter"
                read_only  = true
            }

            env {
             name = "DCGM_EXPORTER_KUBERNETES"
             value = "true"
           }
          
            security_context {
                privileged               = true
                allow_privilege_escalation = true

                capabilities {
                add = ["ALL"]
                }
            }
        }


        volume {
          name = "pod-gpu-resources"
          host_path {
            path = "/var/lib/kubelet/pod-resources"
          }
        }

        volume {
          name = "metrics-config"
          config_map {
            name = kubernetes_config_map.dcgm_metrics_cm.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dcgm_exporter_svc" {
  metadata {
    name      = "dcgm-exporter-svc"
    namespace = "default"
    labels = {
      app = "dcgm-exporter"
    }
  }

  spec {
    selector = {
      app = "dcgm-exporter"
    }

    port {
      name        = "metrics"
      port        = 9400
      target_port = "metrics"
    }
  }
}


