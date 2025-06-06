FROM ollama/ollama:latest

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MODEL_NAME=deepseek-r1:8b
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV OLLAMA_HOST=0.0.0.0:11434

# Expose necessary ports
EXPOSE 11434
ENTRYPOINT ["/entrypoint.sh"]