FROM runpod/worker-comfyui:5.8.5-base

# ── Custom nodes needed by Wan2.2 Remix NSFW I2V workflow ──
RUN comfy-node-install comfyui-videohelpersuite
RUN comfy-node-install comfyui-kjnodes

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/princepainter/ComfyUI-PainterI2Vadvanced.git && \
    cd ComfyUI-PainterI2Vadvanced && (pip install -r requirements.txt 2>/dev/null || true)

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/vrgamegirl19/comfyui-vrgamedevgirl.git && \
    cd comfyui-vrgamedevgirl && pip install librosa

# ── Provision script (downloads models to network volume on first cold start) ──
COPY provision_video.sh /provision_video.sh
RUN chmod +x /provision_video.sh

CMD ["/provision_video.sh"]
