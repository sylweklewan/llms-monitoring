#!/bin/bash
set -e

# Start Ollama in the background
ollama serve &
sleep 10
echo "About to pull ${MODEL_NAME}"
ollama pull "${MODEL_NAME}"
while true; do
 sleep 5
done