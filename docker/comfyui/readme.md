The below command shows 4 persistent volumes being used for important data; **model, input, output, and workspace**.


```bash
docker run \  
    runtime nvidia \  
    gpus all \  
    -v "/home/stavrosg/comfy/ComfyUI/models:/comfyui/models" \  
    -v "/home/stavrosg/comfy/ComfyUI/input:/comfyui/input" \  
    -v "/home/stavrosg/comfy/ComfyUI/output:/comfyui/output" \  
    -v "/home/stavrosg/comfy/ComfyUI/user/default/workflows:/comfyui/user/default/workflows" \  
    -e COMFYUI_ARGS="--listen 0.0.0.0 --port 8188 --use-sage-attention" \  
    -p 127.0.0.1:8188:8188 \  
    --network=host \  
    --name comfyui-nvidia \  
    stavrosg/comfyui:pytorch280_cuda129
```
	
Advanced users, or people with exsting installations, might want persistent storage 
for the entire profile. This can be accomplished by tweaking the last volume statement,
as seen below;

```bash
    -v "/home/stavrosg/comfy/ComfyUI/user:/comfyui/user"
```



