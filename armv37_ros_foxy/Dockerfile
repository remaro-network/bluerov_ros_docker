FROM arm32v7/ubuntu:focal

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt update && \
    apt install -q -y --no-install-recommends tzdata \
    bash-completion \
    build-essential \
    git \
    dirmngr \
    gnupg2 \
    lsb-release \
    python3-pip \
    libasio-dev \
    libssl-dev \
    libtinyxml2-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu focal main" > /etc/apt/sources.list.d/ros2-latest.list

# setup keys
# RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    python3-rosinstall-generator \
    && rm -rf /var/lib/apt/lists/*

# install python packages
RUN pip3 install -U \
    argcomplete \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures
# This is a workaround for pytest not found causing builds to fail
# Following RUN statements tests for regression of https://github.com/ros2/ros2/issues/722
RUN pip3 freeze | grep pytest \
    && python3 -m pytest --version

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# clone source
ENV ROS2_WS /opt/ros2_ws
RUN mkdir -p $ROS2_WS/src
WORKDIR $ROS2_WS

# build source
RUN colcon \
    build \
    --cmake-args \
      -DSECURITY=ON --no-warn-unused-cli \
    --symlink-install

# setup bashrc
RUN cp /etc/skel/.bashrc ~/

ARG ROS_DISTRO=foxy
ENV ROS_DISTRO=$ROS_DISTRO
ENV ROS_VERSION=2 \
    ROS_PYTHON_VERSION=3

WORKDIR $ROS2_WS

RUN rosinstall_generator ros_core --rosdistro $ROS_DISTRO --deps --tar > foxy-ros-core.rosinstall \
    && vcs import src < foxy-ros-core.rosinstall

# install dependencies
RUN apt-get update && rosdep install -y \
    --from-paths src \
    --ignore-src \
    --skip-keys " \
        console_bridge \
        fastcdr \
        fastrtps \
        libopensplice69 \
        rti-connext-dds-6.0.1 \
        urdfdom_headers" \
    && rm -rf /var/lib/apt/lists/*

# build source
RUN colcon \
    build \
    --symlink-install \
    --mixin build-testing-on release \
    --cmake-args --no-warn-unused-cli

ARG RUN_TESTS
ARG FAIL_ON_TEST_FAILURE
RUN if [ ! -z "$RUN_TESTS" ]; then \
        colcon test; \
        if [ ! -z "$FAIL_ON_TEST_FAILURE" ]; then \
            colcon test-result; \
        else \
            colcon test-result || true; \
        fi \
    fi

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
