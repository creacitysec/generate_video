FROM runpod/worker-comfyui:5.7.1-base

# ============================================================
# VelvetGen Video Worker - Wan2.1 Image-to-Video
# Uses ONLY core ComfyUI nodes (no custom nodes needed)
# Models are baked into the Docker image for reliability
# ============================================================

# Install wget for downloads
RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 1. T5 text encoder for Wan2.1 (~10GB)
RUN mkdir -p /comfyui/models/text_encoders && \
    wget -q --show-progress -O /comfyui/models/text_encoders/umt5-xxl-enc-bf16.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5-xxl-enc-bf16.safetensors"

# 2. Wan2.1 I2V 14B diffusion model fp8 (~7GB)
RUN mkdir -p /comfyui/models/diffusion_models && \
    wget -q --show-progress -O /comfyui/models/diffusion_models/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_i2v_480p_14B_fp8_e4m3fn.safetensors"

# 3. Wan2.1 VAE (~1GB)
RUN mkdir -p /comfyui/models/vae && \
    wget -q --show-progress -O /comfyui/models/vae/Wan2_1_VAE_bf16.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan2.1_vae.safetensors"

# 4. CLIP Vision for I2V conditioning (~1.5GB)
RUN mkdir -p /comfyui/models/clip_vision && \
    wget -q --show-progress -O /comfyui/models/clip_vision/clip_vision_h.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
