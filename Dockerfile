FROM runpod/worker-comfyui:5.7.1-base

# ============================================================
# VelvetGen Image Worker - Juggernaut Ragnarok + LoRAs
# TOUT baked dans le Docker — pas besoin de network volume
# ============================================================

RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Checkpoint (~6.5GB)
RUN mkdir -p /comfyui/models/checkpoints && \
    wget -q --show-progress -O /comfyui/models/checkpoints/juggernaut_ragnarok.safetensors \
    "https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors"

# LoRAs (HuggingFace only — CivitAI requires auth, avoid)
RUN mkdir -p /comfyui/models/loras

# 1. Detail Tweaker XL (~223MB)
RUN wget -q --show-progress -O /comfyui/models/loras/add-detail-xl.safetensors \
    "https://huggingface.co/AiWise/Detail-Tweaker-XL_v1/resolve/main/add-detail-xl.safetensors"

# 2. NSFW XL v2.0 (~665MB)
RUN wget -q --show-progress -O /comfyui/models/loras/nsfw-xl.safetensors \
    "https://huggingface.co/Dremmar/nsfw-xl/resolve/main/nsfw-xl-2.0.safetensors"
