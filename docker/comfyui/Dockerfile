#
# docker run \
#	--runtime nvidia \
#	--gpus all \
#	-v "/ssd/models:/comfyui/models" \
#	-v "/home/stavros/diffusion_models:/comfyui/models/diffusion_models" \
#	-v "/home/stavros/comfy/ComfyUI/temp:/comfyui/temp" \
#	-v "/home/stavros/comfy/ComfyUI/input:/comfyui/input" \
#	-v "/home/stavros/comfy/ComfyUI/output:/comfyui/output" \
#	-v "/home/stavros/comfy/ComfyUI/user:/comfyui/user/" \
#	-e COMFYUI_ARGS="--listen 0.0.0.0 --port 8188 --use-sage-attention" \
#	-p 127.0.0.1:8188:8188 \
#	--network=host \
#	--name comfyui-nvidia \
#	stavrosg/comfyui:pytorch280_cuda129
#
# docker build -f Dockerfile . -t stavrosg/comfyui:pytorch290_cuda128
#
FROM docker.io/nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04
ENV PIP_ROOT_USER_ACTION=ignore
ENV TZ="America/New_York"
ENV EXT_PARALLEL="4"
ENV PIP_BREAK_SYSTEM_PACKAGES=1
ENV NVCC_APPEND_FLAGS="--threads 8"
ENV MAX_JOBS="32"
RUN apt-get update -y \
	&& apt-get clean -y \
	&& apt-get autoremove -y \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		apt-utils \
		tzdata \
		supervisor \
		wget \
		curl \
		ffmpeg \
		libsm6 \
		libxext6 \
		software-properties-common \
		libfontconfig1 \
		libxrender1 \
		build-essential \
		vim \
		git \
		python3 \
		python3-venv \
		python3-pip \
	&& apt-get clean \
	&& rm -r -f /root/.cache \ 
	&& rm /usr/lib/python3.12/EXTERNALLY-MANAGED
RUN pip install --no-cache-dir comfy-cli \
	&& sed -i 's\if tracking_enabled is not None\if 1 == 1\g' \
		/usr/local/lib/python3.12/dist-packages/comfy_cli/tracking.py \
	&& sed -i 's\res = ui.prompt_confirm_action(f"Install from {url} to {comfy_path}?", True)\res = 1\g' \
		/usr/local/lib/python3.12/dist-packages/comfy_cli/command/install.py \
	&& comfycli --workspace=/comfyui install --nvidia \
	&& pip3 uninstall torch torchvision torchaudio --yes \
	&& pip3 --no-cache-dir install torch torchvision torchaudio \
		--index-url https://download.pytorch.org/whl/cu129 \
	&& pip install --no-cache-dir -U nvidia-pytriton accelerate \
	&& git clone https://github.com/thu-ml/SageAttention.git \
	&& cd SageAttention \
	&& python3 setup.py install \
	&& rm -r -f /root/.cache 
	

EXPOSE 8188
COPY entrypoint.sh /entrypoint.sh 
RUN chmod +xxx /entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf 
COPY entrypoint.sh /entrypoint.sh 
RUN chmod +xxx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]





