FROM runpod/worker-comfyui:5.7.1-base

# ============================================================
# VelvetGen Image Worker - Juggernaut Ragnarok + LoRAs
# Checkpoints come from network volume, LoRAs baked in Docker
# ============================================================

RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# LoRA directory
RUN mkdir -p /comfyui/models/loras

# 1. Detail Tweaker XL (~223MB) - detail enhancer, weight [-3, 3]
RUN wget -q --show-progress -O /comfyui/models/loras/add-detail-xl.safetensors \
    "https://huggingface.co/AiWise/Detail-Tweaker-XL_v1/resolve/main/add-detail-xl.safetensors"

# 2. NSFW XL v2.0 (~665MB) - NSFW female poses
RUN wget -q --show-progress -O /comfyui/models/loras/nsfw-xl.safetensors \
    "https://huggingface.co/Dremmar/nsfw-xl/resolve/main/nsfw-xl-2.0.safetensors"

# 3. Adjust Details & Photorealism v9 ULTRA SDXL (~19MB) - realism boost
RUN wget -q --show-progress -O /comfyui/models/loras/adjust-photorealism.safetensors \
    "https://civitai.com/api/download/models/2612595"

# 4. NSFW POV All In One SDXL Mini (~74MB) - POV trigger words
RUN wget -q --show-progress -O /comfyui/models/loras/nsfw-pov-aio-mini.safetensors \
    "https://civitai.com/api/download/models/162180"
