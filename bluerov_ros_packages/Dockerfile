FROM arm32v7/ros:foxy

RUN apt-get update && apt-get install --no-install-recommends -y \
    libboost-all-dev \
    python-is-python3 \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /bluerov_deps_ws/src
COPY bluerov_deps.rosinstall /bluerov_deps_ws/bluerov_deps.rosinstall

WORKDIR /bluerov_deps_ws
RUN vcs import src < bluerov_deps.rosinstall --recursive

RUN [ "/bin/bash","-c","source /opt/ros2_ws/install/setup.bash \
            && apt update && rosdep update \
            && rosdep install --from-paths src --ignore-src -r -y \
            && rm -rf /var/lib/apt/lists/"]

RUN [ "/bin/bash","-c","source /opt/ros2_ws/install/setup.bash \
            && colcon build --symlink-install"]

RUN mkdir -p /bluerov_ws/src
COPY bluerov.rosinstall /bluerov_ws/bluerov.rosinstall
WORKDIR /bluerov_ws
RUN vcs import src < bluerov.rosinstall --recursive

RUN [ "/bin/bash","-c","source /bluerov_deps_ws/install/setup.bash \
            && apt update && rosdep update \
            && rosdep install --from-paths src --ignore-src -r -y \
            && rm -rf /var/lib/apt/lists/"]

RUN [ "/bin/bash","-c","source /bluerov_deps_ws/install/setup.bash \
            && colcon build --symlink-install"]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
