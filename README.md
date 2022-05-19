# bluerov_ros_docker
Dockerfile for running bluerov ros packages

## Build docker image with ROS2 foxy for amrv37

```Bash
cd arm32v7_ros_foxy/
sudo docker build -t arm32v7/ros:foxy .
```

ps: if you want to build a different version of ros2 change:
- In `FROM arm32v7/ubuntu:focal` and `RUN echo "deb http://packages.ros.org/ros2/ubuntu focal main" > /etc/apt/sources.list.d/ros2-latest.list` change `focal` to the ubuntu version required
- `ARG ROS_DISTRO=foxy` to the ros version required

## Build docker image with bluerov ros packages

```Bash
cd bluerov_ros_packages/
sudo docker build -t bluerov_ros:foxy .
```
