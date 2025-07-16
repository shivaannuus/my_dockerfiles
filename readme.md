# README

## cuda_ros2_humble

### 准备环境

cuda在容器中运行需要nvidia-container-runtime和nvidia-container-toolkit

```bash

# cuda source
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
sudo apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

sudo apt-get update

# nvidia-container-runtime
sudo apt-get install nvidia-container-runtime nvidia-container-toolkit

# 把运行时添加到docker中：
systemctl stop docker
dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime

```

### 编译镜像

如果基于nvidia官方镜像构建新的镜像, 则需要编译dockerfile

```bash
# docker build -t cuda_ros2_humble.dockerfile .
docker build -f cuda_ros2_humble.dockerfile -t my-cuda-ros2-humble .
```

### 运行

* 创建容器时一定要指定gpus参数: docker run -it --gpus=all 镜像名  执行命令
* 进入容器后执行 nvidia-smi, 查看环境

```bash
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
docker run --rm --gpus all nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04 nvidia-smi

docker run --rm -it --gpus all --net host --privileged \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    my-ros2-gpu

```

## Docker容器内用户

待验证 <https://tianws.github.io/skill/2020/05/29/docker-uid-setting/>

## 备用镜像

<https://hub.docker.com/r/nvidia/cuda/tags?name=ubuntu22.04>
