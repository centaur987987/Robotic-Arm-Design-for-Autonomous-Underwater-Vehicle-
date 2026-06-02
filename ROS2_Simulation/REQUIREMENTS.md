# Software Requirements

## Operating System
- Windows 11 (with WSL2)
- Ubuntu 22.04 LTS (via WSL2)

## ROS
- ROS 2 Humble Hawksbill
- Gazebo Classic 11
- ros-humble-desktop
- ros-humble-gazebo-ros-pkgs
- ros-humble-urdf-tutorial

## Python
- Python 3.10 (included with Ubuntu 22.04)
- rclpy (included with ROS 2 Humble)

## Build Tools
- colcon
- python3-colcon-common-extensions

## CAD
- SolidWorks 2021
- SW2URDF Exporter v1.6.1

## Display
- WSLg (included with WSL2 on Windows 11) — no additional X server needed

## Installation Notes
- GAZEBO_MODEL_PATH must be set before launching Gazebo:
  export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/$USER/ros2_ws/install/robot_arm_udrf/share
- URDF must have encoding declaration removed after SW2URDF export
- CMakeLists.txt and package.xml must use ROS 2 ament_cmake format