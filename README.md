# bluerov_ros_docker
Dockerfile for running bluerov ros packages

## Acknowledgements

<a href="https://remaro.eu/">
    <img height="50" alt="REMARO Logo" src="https://remaro.eu/wp-content/uploads/2020/09/remaro1-right-1024.png">
</a>

This work is part of the Reliable AI for Marine Robotics (REMARO) Project. For more info, please visist:  <a href="https://remaro.eu/">https://remaro.eu/

<br>

<a href="https://research-and-innovation.ec.europa.eu/funding/funding-opportunities/funding-programmes-and-open-calls/horizon-2020_en">
    <img align="left" height="50" alt="EU Flag" src="https://remaro.eu/wp-content/uploads/2020/09/flag_yellow_low.jpg">
</a>

This project has received funding from the European Union's Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No. 956200".


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
