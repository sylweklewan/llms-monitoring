#!/bin/bash
set -e

# Start Ollama in the background
ollama serve &
sleep 10
echo "About to pull ${MODEL_NAME}"
ollama pull "${MODEL_NAME}"
pipx run nvitop-exporter --bind-address 0.0.0.0 --port 5050

