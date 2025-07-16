# 使用 NVIDIA 官方 CUDA 镜像作为基础镜像
# FROM nvidia/cuda:12.2.0-cudnn8-devel-ubuntu22.04
# FROM nvidia/cuda:12.9.1-devel-ubuntu22.04
FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础依赖
RUN apt update && apt install -y \
    tzdata locales curl gnupg2 lsb-release \
    sudo git wget build-essential \
    python3 python3-pip python3-colcon-common-extensions \
    libopencv-dev python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# 设置 UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 安装 ROS2 Humble
RUN apt update && apt install -y software-properties-common && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - && \
    echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list && \
    apt update && \
    apt install -y ros-humble-desktop && \
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# 安装 PyTorch (CUDA 12.1 支持)
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 安装其他 Python 库
RUN pip3 install numpy scipy matplotlib pandas opencv-python

# 设置 ROS 环境变量
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# 创建一个 ROS 工作区（可选）
RUN mkdir -p /root/ws/src

WORKDIR /root/ws

# 默认进入 bash
CMD ["/bin/bash"]
