FROM eriksf/nvitop:latest AS nvitop

FROM ollama/ollama:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
build-essential \
    curl \
    gcc \
    pip \
    pipx \
    python3-venv \
    locales \
    lsof \
    python3-dev \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Rust using rustup, and make it available in PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
 && echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.profile

# Manually export the path in the current Docker layer
ENV PATH="/root/.cargo/bin:$PATH"
ENV MODEL_NAME=deepseek-r1:8b

# # Install necessary Python packages
RUN pip install --no-cache-dir --no-binary :psutil: psutil==6.1.0 nvidia-ml-py==12.560.30 amdsmi==6.2.4 openlit==1.29.0

# Install network tools: netstat (in net-tools) and ss (in iproute2)
RUN apt-get update && \
    apt-get install -y net-tools iproute2 curl gnupg procps && \
    rm -rf /var/lib/apt/lists/*

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV OLLAMA_HOST=0.0.0.0:11434

# Expose necessary ports
EXPOSE 11434 5050
ENTRYPOINT ["/entrypoint.sh"]
