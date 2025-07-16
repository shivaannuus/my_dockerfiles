FROM moveit/moveit2:humble-source 

WORKDIR /home/houy/apollo/arm_ws_src
COPY . /home/houy/apollo/arm_ws_src

RUN apt install -y build-essential
# RUN apt install -y plocate 
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ws_moveit/install/setup.bash" >> ~/.bashrc
# RUN echo "source /workspace/fue_interfaces/install/setup.bash" >> ~/.bashrc


CMD ["/bin/bash"]

# docker run -it -v /home/houy/apollo/arm_ws_src:/workspace -w /workspace -p 1234:1234 armwssrc /bin/bash