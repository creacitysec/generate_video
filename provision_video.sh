#!/bin/bash
set -e

VOL="/runpod-volume"
MODELS="$VOL/models"
MARKER="$MODELS/.wan22_ready"

# ── If network volume is mounted and models not yet downloaded ──
if [ -d "$VOL" ] && [ ! -f "$MARKER" ]; then
    echo "[provision] First start — downloading Wan2.2 Remix models to network volume..."
    mkdir -p "$MODELS/diffusion_models" "$MODELS/clip" "$MODELS/text_encoders" "$MODELS/vae"

    # Parallel downloads (~40GB total)
    (wget -q --show-progress -O "$MODELS/diffusion_models/wan22_remix_nsfw_i2v_high_v3.safetensors" \
        "https://civitai.com/api/download/models/2770795" && echo "[provision] UNET High done") &

    (wget -q --show-progress -O "$MODELS/diffusion_models/wan22_remix_nsfw_i2v_low_v3.safetensors" \
        "https://civitai.com/api/download/models/2771407" && echo "[provision] UNET Low done") &

    (wget -q --show-progress -O "$MODELS/clip/nsfw_wan_umt5-xxl_bf16.safetensors" \
        "https://huggingface.co/NSFW-API/NSFW-Wan-UMT5-XXL/resolve/main/nsfw_wan_umt5-xxl_bf16.safetensors" \
        && ln -sf "$MODELS/clip/nsfw_wan_umt5-xxl_bf16.safetensors" "$MODELS/text_encoders/nsfw_wan_umt5-xxl_bf16.safetensors" \
        && echo "[provision] CLIP done") &

    (wget -q --show-progress -O "$MODELS/vae/wan_2.1_vae.safetensors" \
        "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors" \
        && echo "[provision] VAE done") &

    wait
    touch "$MARKER"
    echo "[provision] All models ready on volume."
fi

# ── Symlink volume models into ComfyUI model dirs ──
if [ -d "$MODELS" ]; then
    for DIR in diffusion_models clip text_encoders vae; do
        if [ -d "$MODELS/$DIR" ]; then
            mkdir -p "/comfyui/models/$DIR"
            ln -sf "$MODELS/$DIR"/*.safetensors "/comfyui/models/$DIR/" 2>/dev/null || true
        fi
    done
    echo "[provision] Volume models symlinked into /comfyui/models/"
fi

# ── Hand off to original worker startup ──
exec /start.sh
