#
# docker run --rm -it \
#	--runtime nvidia \
#	--gpus all \
#	-v "/ssd/models:/comfyui/models" \
#	-v "/home/stavros/comfy/ComfyUI/input:/comfyui/input" \
#	-v "/home/stavros/comfy/ComfyUI/output:/comfyui/output" \
#	-v "/home/stavros/comfy/ComfyUI/user:/comfyui/user/" \
#	-e COMFYUI_ARGS="--listen 0.0.0.0 --port 8188 --use-sage-attention" \
#	-p 127.0.0.1:8188:8188 \
#	--network=host \
#	--name comfyui-nvidia \
#	stavrosg/comfyui:pytorch280_cuda129
#
# docker build -f Dockerfile . -t stavrosg/comfyui:pytorch280_cuda129
#
FROM docker.io/nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04
ENV PIP_ROOT_USER_ACTION=ignore
ENV TZ="America/New_York"
ENV EXT_PARALLEL="4"
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
	&& rm -r -f /root/.cache
RUN python3 -m pip config set global.break-system-packages true 
RUN pip install --no-cache-dir comfy-cli \
	&& sed -i 's\if tracking_enabled is not None\if 1 == 1\g' \
		/usr/local/lib/python3.12/dist-packages/comfy_cli/tracking.py \
	&& sed -i 's\res = ui.prompt_confirm_action(f"Install from {url} to {comfy_path}?", True)\res = 1\g' \
		/usr/local/lib/python3.12/dist-packages/comfy_cli/command/install.py \
	&& comfycli --workspace=/comfyui install --nvidia \
	&& pip3 uninstall torch torchvision torchaudio --yes \
	&& pip3 --no-cache-dir install torch torchvision torchaudio \
		--index-url https://download.pytorch.org/whl/cu129 \ 
	&& pip install --no-cache-dir -U nvidia-pytriton \
	&& curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
	&& apt-get install -y nodejs \
	&& curl -qL https://www.npmjs.com/install.sh | sh \
	&& git clone https://github.com/thu-ml/SageAttention.git \
	&& cd SageAttention \
	&& python3 setup.py install  \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/cubiq/ComfyUI_essentials \
	&& cd ComfyUI_essentials/ \
	&& pip3 install --no-cache-dir -r requirements.txt \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/chrisgoringe/cg-use-everywhere  \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/neuratech-ai/ComfyUI-MultiGPU 	\
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/city96/ComfyUI-GGUF	\
	&& pip install --no-cache-dir --upgrade gguf \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/rgthree/rgthree-comfy.git \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/kijai/ComfyUI-KJNodes \
	&& cd ComfyUI-KJNodes/ \
	&& pip3 install --no-cache-dir -r requirements.txt \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/kijai/ComfyUI-Florence2 \
	&& cd ComfyUI-Florence2/ \ 
	&& pip3 install --no-cache -r requirements.txt \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/Pixelailabs/paint_editor.git \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/kijai/ComfyUI-segment-anything-2 \
	&& cd /comfyui/custom_nodes/ \
	&& git clone https://github.com/M1kep/ComfyLiterals \
	&& rm -r -f /root/.cache 
	
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf 
#COPY entrypoint.sh /entrypoint.sh 
#RUN chmod +xxx /entrypoint.sh

EXPOSE 8188
ENTRYPOINT ["/usr/local/bin/comfycli"]
CMD ["launch", "--","--listen"]

