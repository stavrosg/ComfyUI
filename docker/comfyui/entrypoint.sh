#!/bin/bash
# set -e
# COMFYUI_ARGS=${COMFYUI_ARGS:---listen 0.0.0.0 --port 8188 --use-sage-attention}
# export COMFYUI_ARGS
# exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
comfycli launch -- --listen
