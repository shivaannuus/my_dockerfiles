FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# 安装 ROS 2 Humble 所需依赖
RUN apt update && apt install -y \
    lsb-release gnupg2 curl git wget software-properties-common locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - \
    && add-apt-repository "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    && apt update && apt install -y ros-humble-desktop-full \
    && apt clean

# 安装开发工具
RUN apt update && apt install -y \
    python3-colcon-common-extensions python3-vcstool python3-rosdep \
    && rosdep init && rosdep update

# 创建工作区
RUN mkdir -p /ws_moveit/src
WORKDIR /ws_moveit

# 克隆 MoveIt 2 源码（这里选用 meta repo）
RUN git clone https://github.com/ros-planning/moveit2.git src/moveit2 \
    && vcs import src < src/moveit2/moveit2.repos

# 安装依赖
RUN source /opt/ros/humble/setup.bash && \
    rosdep install -r --from-paths src --ignore-src --rosdistro humble -y

# 编译
RUN source /opt/ros/humble/setup.bash && \
    colcon build --cmake-clean-cache

# 环境变量
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /ws_moveit/install/setup.bash" >> ~/.bashrc

# 默认工作目录
WORKDIR /ws_moveit