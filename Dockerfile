FROM runpod/worker-comfyui:5.7.1-base

# ============================================================
# VelvetGen Image Worker - Juggernaut Ragnarok + LoRAs + NudeNet
# TOUT baked dans le Docker — pas besoin de network volume
# ============================================================

RUN apt-get update && apt-get install -y --no-install-recommends wget git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ComfyUI-Nudenet custom node (for selective censoring)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/phuvinh010701/ComfyUI-Nudenet.git && \
    cd ComfyUI-Nudenet && \
    [ -f requirements.txt ] && pip install -r requirements.txt || true

# Checkpoint + LoRAs + NudeNet model (all in parallel)
RUN mkdir -p /comfyui/models/checkpoints /comfyui/models/loras && \
    wget -q -O /comfyui/models/checkpoints/juggernaut_ragnarok.safetensors \
      "https://huggingface.co/RunDiffusion/Juggernaut-XL-v9/resolve/main/Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors" & \
    wget -q -O /comfyui/models/loras/add-detail-xl.safetensors \
      "https://huggingface.co/AiWise/Detail-Tweaker-XL_v1/resolve/main/add-detail-xl.safetensors" & \
    wget -q -O /comfyui/models/loras/nsfw-xl.safetensors \
      "https://huggingface.co/Dremmar/nsfw-xl/resolve/main/nsfw-xl-2.0.safetensors" & \
    wait
