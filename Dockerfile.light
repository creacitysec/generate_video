FROM runpod/worker-comfyui:5.7.1-base

# Install custom nodes for video generation
RUN comfy-node-install comfyui-videohelpersuite
RUN comfy-node-install comfyui-wanvideowrapper

# Download T5 text encoder (~10GB) - required for Wan2.1 I2V text conditioning
RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    mkdir -p /comfyui/models/text_encoders && \
    wget -q https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors \
    -O /comfyui/models/text_encoders/umt5-xxl-enc-bf16.safetensors && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download NSFW LoRAs for image quality
RUN mkdir -p /comfyui/models/loras && \
    wget -q https://civitai.com/api/download/models/135867 \
    -O /comfyui/models/loras/add-detail-xl.safetensors && \
    wget -q https://civitai.com/api/download/models/341068 \
    -O /comfyui/models/loras/nsfw-xl-2.1.safetensors || true
