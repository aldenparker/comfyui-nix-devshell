# ComfyUI Nix Devshell
This project is a nix devshell for using ComfyUI as it is meant to be without running into a lot of different problems regarding torch and other dependencies. Lots of inspiration from [this repo](https://github.com/virchau13/automatic1111-webui-nix). Everything is kept in a python virtual env.

## Install
```
git clone --recurse-submodule https://github.com/aldenparker/comfyui-nix-devshell
cd comfyui-nix-devshell
nix develop ./#cuda # Make sure change this based on what you are running
cd ComfyUI
python -m pip install -r requirements.txt
```
You may need to install different versions of the torch packages based on your hardware. Look at the [ComfyUI](https://github.com/comfyanonymous/ComfyUI/tree/v0.3.41?tab=readme-ov-file#manual-install-windows-linux) repo to make sure.

## Troubleshooting
### NVIDIA
Nvidia can be somewhat complicated when it comes to meshing with python. To make sure that it works and you do not get a driver mismatch, make sure that the current locked driver version is the version your host system is running. The current version locked are below:

```
CUDA: 570.153.02
CUDA-BETA: 575.51.02
```
