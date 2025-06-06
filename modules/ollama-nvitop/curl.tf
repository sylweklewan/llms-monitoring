resource "local_file" "curl_prompt_script" {
  filename        = "curl-${var.deployment_name}.sh"
  file_permission = "0755"

  content = <<-EOT
    #!/bin/bash

    PROMPT="${var.prompt}"
    HOST_IP="${var.target_host}"
    PORT="${var.fw_port_to_access}"
    MODEL="${var.model_name}"

    read -r -d '' PAYLOAD <<EOF
    {
      "model": "$MODEL",
      "prompt": "$PROMPT",
      "stream": false
    }
    EOF

    curl -s -X POST "$HOST_IP:$PORT/api/generate" -d "$PAYLOAD"
  EOT
}