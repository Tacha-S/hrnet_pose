# FROM nvidia/cuda:10.2-cudnn8-devel

# ENV DEBIAN_FRONTEND=noninteractive
# ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list' && \
#     apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
#     apt-get update && \
#     apt-get install -y ros-melodic-ros-base

# RUN apt-get update && \
#     apt-get install -y python-catkin-tools python3-dev python3-catkin-pkg-modules python3-numpy python3-yaml ros-melodic-cv-bridge git python3-pip

# RUN mkdir ros &&\
#     cd ros &&\
#     catkin init &&\
#     catkin config -DPYTHON_EXECUTABLE=/usr/bin/python3 -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so &&\
#     catkin config --install &&\
#     git clone https://github.com/ros-perception/vision_opencv.git src/vision_opencv &&\
#     cd src/vision_opencv/ &&\
#     git checkout melodic &&\
#     cd ../../ &&\
#     /bin/bash -c "source /opt/ros/melodic/setup.bash; catkin build cv_bridge"

FROM ros-melodic-cuda

RUN cd ros/src && \
    git clone --recursive https://github.com/Tacha-S/hrnet_pose.git && \
    pip3 install torch torchvision numpy==1.19.5 && \
    pip3 install -r hrnet_pose/deep-high-resolution-net/requirements.txt && \
    cd hrnet_pose/deep-high-resolution-net/lib && \
    make &&\
    cd ../../../../.. && \
    git clone https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    python3 setup.py install --user && \
    cd ../../ros && \
    /bin/bash -c "source /opt/ros/melodic/setup.bash; catkin build hrnet_pose"

